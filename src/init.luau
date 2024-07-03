--!native
--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		The main module of Class++.
	////
--]]

--////// Variables

local classpp = { class = function(className: string) end }

local Util = require(script.Util)
local Error = require(script.Error)
local Type = require(script.Type)

local LogError = Error.logError
local LogErrorNonFatal = Error.logErrorNonFatal

local Classes: {[string]: class} = {}

--// For preventing operator functions to be called without the usage of operators. (e.g: "obj:operator_add()")

local operatorFuncNames: {string} = {
	"operator_add",
	"operator_sub",
	"operator_mul",
	"operator_div",
	"operator_idiv",
	"operator_mod",
	"operator_pow",
	"operator_unm",
	"operator_eq"
}

--////// Types

export type classData = {
	constructor: (any: any, ...any) -> ()?,
	destructor: (any: any) -> ()?,
	Public: {[any]: any}?,
	Private: {[any]: any}?,
	Protected: {[any]: any}?,
	Friend: {any}?
}

type internalClassData = {
	Public: {[any]: any}?,
	Private: {[any]: any}?,
	Protected: {[any]: any}?,
	Friend: {any}?,
	Internal: {
		__type: string?,
		__locked: boolean?,
		constructor: (any: any, ...any) -> ()?,
		destructor: (any: any) -> ()?,
	}
}

export type class = typeof(setmetatable({} :: {
	new: (...any) -> any,
	extends: (className: string) -> (classData: classData) -> class,
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
	Name: string
}, {
	__index = function(t, i) return end :: ({any}, any) -> (any),
	__newindex = function(t, i, v) end :: ({any}, any, any) -> (),
	__type = "",
	__classtype = "",
	__abstract = false,
	__final = false
}))

type internalClass = typeof(setmetatable({} :: {
	new: (...any) -> any,
	extends: (className: string) -> (classData: classData) -> class,
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
	Name: string,
	Inherits: typeof(setmetatable({}, {__newindex = function() end, __metatable = {}, __tostring = function() end}))?,
	Friends: typeof(setmetatable({}, {__newindex = function() end, __metatable = {}, __tostring = function() end}))?
}, {
	__index = function(t, i) return end :: ({any}, any) -> (any),
	__newindex = function(t, i, v) end :: ({any}, any, any) -> (),
	__type = "",
	__classtype = "",
	__abstract = false,
	__final = false
}))

--////// Local Functions

local function deepCopy<T>(original: T & {[any]: any}): T & {[any]: any}
	local copy = table.clone(original) :: T & {[any]: any}

	for key, value in (original :: {[any]: any}) do
		if type(value) == "table" then
			local tmetatable = getmetatable(value);
			(copy :: {[any]: any})[key] = if not tmetatable then deepCopy(value) else setmetatable(deepCopy(value) :: {[any]: any}, tmetatable)
		end
	end

	return copy
end

local function sortAttributes(data: classData, className: string): internalClassData
	local classObjTbl: internalClassData = deepCopy(data)

	classObjTbl.Internal = {
		__type = className,
		__locked = false
	}

	local InternalFunctionNames = {"constructor", "destructor"}
	for _, functionName in InternalFunctionNames do
		if classObjTbl[functionName] then
			classObjTbl.Internal[functionName] = classObjTbl[functionName]
			classObjTbl[functionName] = nil
		end
	end

	return classObjTbl
end

local function objectCleaner(objectTbl: {[string]: any}): {}
	for accessSpecifier, attributesData in objectTbl do
		if accessSpecifier == "Internal" then continue end
		local function recursiveClean(tbl: {[any]: any})
			for key, value in tbl do
				if typeof(key) == "Instance" then key:Destroy() end
				if typeof(value) == "table" then
					tbl[key] = recursiveClean(value)
				elseif typeof(value) == "Instance" then
					value:Destroy()
				end

				tbl[key] = nil
			end
			return
		end
		recursiveClean(attributesData)
	end
	objectTbl.Internal.__locked = true
	return objectTbl
end

local function mergeClassData(superClassData: classData, childClassData: classData): classData
	local newClassData: classData = {
		Public = {},
		Private = {},
		Protected = {}
	}

	for accessSpecifier, attributesData in superClassData do
		if accessSpecifier == "Private" then continue end

		for attributeName, attributeData in (attributesData :: any) do
			newClassData[accessSpecifier][attributeName] = attributeData
		end
	end
	for accessSpecifier, attributesData: any in childClassData do
		if typeof(accessSpecifier) ~= "string" then continue end

		local n: string? = if typeof(attributesData) == "function" then debug.info(attributesData, "n") else nil

		if n and n == "destructor" or n and n == "constructor" then
			newClassData[n] = attributesData
			continue
		end

		for attributeName, attributeData in attributesData do
			newClassData[accessSpecifier][attributeName] = attributeData
		end
	end

	return newClassData
end

local function checkValidAccessSpecifier(specifierString: string): (boolean, string?)
	local accessSpecifiers: {string} = {
		"Public",
		"Private",
		"Protected",
		"Internal",
		"Friend"
	}

	for _, accessSpecifier in accessSpecifiers do
		if specifierString == accessSpecifier then
			return true, accessSpecifier
		end
	end

	return false
end

local function returnAccessSpecifier(index: string, classData: any): string?
	for accessSpecifier, attributesData in classData do
		if typeof(attributesData) == "table" and attributesData[index] ~= nil then
			return accessSpecifier
		end
	end

	return
end

local function findPropertyFromIndex(classData: internalClassData | classData, index: string, accessSpecifier: string?): any?
	local fAccessSpecifier = accessSpecifier or returnAccessSpecifier(index, classData)
	if typeof((classData :: any)[fAccessSpecifier]) ~= "table" then return end
	if (classData :: any)[fAccessSpecifier][index] ~= nil then
		return (classData :: any)[fAccessSpecifier][index]
	end
	return
end

local function callOperator(functionName, obj, obj2: any?, silenceError: boolean?): boolean | any
	if typeof(obj) == "userdata" then
		if obj[functionName] then
			return obj[functionName](obj, obj2)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, functionName)
		end
	elseif typeof(obj2) == "userdata" then
		if obj2[functionName] then
			return obj2[functionName](obj2, obj)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, functionName)
		end
	end

	return false
end

local function checkRedecleration(classData: classData, index: string?): (boolean, any?)
	if not classData then return false end

	if index then
		local fnumber = 0
		for accessSpecifier, attributesData in classData do
			if typeof(attributesData) ~= "table" then continue end
			if (attributesData :: any)[index] then fnumber += 1 end
		end
		if fnumber >= 2 then return true, index end
	else
		for accessSpecifier, attributesData in classData do
			if typeof(attributesData) ~= "table" then continue end
			for attributeKey, _ in (attributesData :: any) do
				if checkRedecleration(classData, attributeKey) then return true, attributeKey end
			end
		end
	end

	return false
end

local function checkOutsideAccessSpecifierDecleration(classData: classData): boolean
	for key, value in classData do
		if typeof(key) ~= "string" then continue end
		if not checkValidAccessSpecifier(key) and key ~= "constructor" and key ~= "destructor" then
			return true
		end
	end

	return false
end

local function setMetamethods(class: internalClass, classData: internalClassData, methods)
	methods.__metatable = 'The metatable is locked.'

	function methods:__index(index): any
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then -- Util.inClassScope(class, false, true, methods, Classes)
				LogError("classPropertyIsPrivate", true, index)
			elseif accessSpecifier == "Internal" and Util.getMethodContext(5) ~= class.new and Util.getMethodContext(7) ~= Type.typeof --[[ and not Util.inClassScope(class, true, true, methods, Classes)]] then
				LogError("classPropertyIsInternal", true, index)
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, false, false) then
				LogError("classPropertyIsProtected", true, index)
			end
		end

		if index == "Destroy" then
			return function() 
				if classData.Internal.destructor then classData.Internal.destructor(self) end
				objectCleaner(classData)
			end
		end

		-- Checking if the index is calling an operator function, this part can be removed if you want to support operator functions still being callable even without operators.
		local sFound = string.find(index, "operator")
		if sFound then
			for _, opfuncname in operatorFuncNames do
				if index == opfuncname and Util.getMethodContext(5) ~= callOperator then
					LogError("nonNativeOperatorCall", true, index)
				end
			end
		end

		local rprop = findPropertyFromIndex(classData, index, accessSpecifier)
		if rprop == nil and index ~= "constructor" and index ~= "destructor" and index ~= "__tostring" and not sFound then LogError("classMemberNotFound", true, index) end

		return rprop
	end

	function methods:__newindex(index, value)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, index)
			elseif accessSpecifier == "Internal" and Util.getMethodContext(5) ~= class.new then
				LogError("classPropertyIsInternal", true, index)
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, false, false) then
				LogError("classPropertyIsProtected", true, index)
			end
		end

		for _, attributesData in classData do
			if typeof(attributesData) == "table" and (attributesData :: any)[index] ~= nil then
				if (attributesData :: any)[index] == value then return end
				(attributesData :: any)[index] = value
				return
			end
		end

		LogError("classMemberNotFound", true, index)
	end

	function methods:__tostring()
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end

		local result = callOperator("__tostring", self, nil, true)
		if result then
			return result
		else
			return class.Name
		end
	end

	function methods.__add(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_add", obj, obj2)
	end

	function methods.__sub(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_sub", obj, obj2)
	end

	function methods.__mul(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_mul", obj, obj2)
	end

	function methods.__div(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_div", obj, obj2)
	end

	function methods.__idiv(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_idiv", obj, obj2)
	end

	function methods.__mod(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_mod", obj, obj2)
	end

	function methods.__pow(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_pow", obj, obj2)
	end

	function methods:__unm()
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_unm", self)
	end

	function methods.__eq(obj, obj2)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		return callOperator("operator_eq", obj, obj2)
	end
end

local function createClassObject(nClassData: classData, className: string, internalFunctionsList: {(...any) -> (any)}?): internalClass
	local class: internalClass = setmetatable({
		Inherits = setmetatable({}, { __tostring = function() return '{}' end, __newindex = function() local f = Util.getMethodContext(5) if f ~= createClassObject and internalFunctionsList and not table.find(internalFunctionsList, f) then LogError("attemptToModifyReadOnlyTable", false) end end, __metatable = {} }),
		Friends = setmetatable({}, { __tostring = function() return '{}' end, __newindex = function() local f = Util.getMethodContext(5) if f ~= createClassObject and internalFunctionsList and not table.find(internalFunctionsList, f) then LogError("attemptToModifyReadOnlyTable", false) end end, __metatable = {} }),
		Name = className
	} :: {
		new: (...any) -> any,
		extends: (className: string) -> (classData: classData) -> class,
		overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
		Name: string,
		Inherits: typeof(setmetatable({}, {__newindex = function() end, __metatable = {}, __tostring = function() end}))?,
		Friends: typeof(setmetatable({}, {__newindex = function() end, __metatable = {}, __tostring = function() end}))?
	}, {
		__index = function(t, i) return rawget(t, i)  end,
		__newindex = function(t, i, v) rawset(t, i, v) end,
		__type = "",
		__classtype = "",
		__abstract = false,
		__final = false
	})

	if nClassData.Friend and class.Friends then
		for _, friend in nClassData.Friend do
			class.Friends[friend] = true
		end
	end

	local methods = {
		__type = "Class",
		__classtype = className,
		__abstract = false,
		__final = false
	}

	methods.__index = function(t, i)
		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == Util.getMethodContext(5) or classpp.final == Util.getMethodContext(5) then
				return methods["__abstract"] 
			end
		end
		if i == "__final" then 
			if classpp.final == Util.getMethodContext(5) or classpp.abstract == Util.getMethodContext(5) then
				return methods["__final"] 
			end
		end

		local result = nClassData[i] or findPropertyFromIndex(nClassData, i)
		if not result then return end

		local methodContext = Util.getMethodContext(5)
		local foundmetatable = getmetatable(result)

		if typeof(result) == "function" and methodContext ~= Util.inClassScope then LogError("cannotCallFunctionError") elseif typeof(result) == "table" and foundmetatable and foundmetatable["__call"] and methodContext ~= Util.inClassScope then LogError("cannotCallFunctionError") end

		return result
	end

	methods.__newindex = function(t, i, v)
		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == Util.getMethodContext(5) and v == true then
				methods.__abstract = true
				class.new = function()
					return LogError("attemptToCreateObjectFromAbstractClass", true)
				end
			end
			return
		end
		if i == "__final" then
			if classpp.final == Util.getMethodContext(5) and v == true then
				methods.__final = true
				class.extends = function()
					LogError("attemptToExtendAFinalClass", true)
					return function() 
						return setmetatable({}, {}) :: class
					end
				end
			end
			return
		end

		nClassData[i] = v
		return v
	end

	function class.new(...): any
		local newObjTbl: internalClassData = sortAttributes(nClassData, className)
		local newObj = newproxy(true)
		local methods = getmetatable(newObj)

		setMetamethods(class, newObjTbl, methods)

		if newObj.constructor then
			newObj:constructor(...)
		end

		return newObj
	end

	function class.extends(className: string): (extendedClassData: classData) -> class
		if typeof(className) ~= "string" then LogError("classNameNotString") end
		if Classes[className] then LogError("classAlreadyExists", false, className) end

		return function(extendedClassData: classData): class
			local newClassData = mergeClassData(nClassData, extendedClassData)
			local newClass = createClassObject(newClassData, className, {debug.info(1, 'f')})
			Classes[className] = newClass

			if newClass.Inherits then newClass.Inherits[class] = true end

			return newClass
		end
	end

	function class.overload(accessSpecifier: string, name: string, functionTable: {(...any) -> (any)})
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" then LogError("invalidAccessSpecifierError", true) end
		if not name then LogError("overloadfunctionNameNotSet", true) end
		if typeof(functionTable) ~= "table" or #functionTable == 0 then LogError("overloadfunctionTableNotGiven", true) end

		for _, func in functionTable do
			if typeof(func) ~= "function" then LogError("expectedFunctionError", true, typeof(func)) end
		end

		local methods = {
			__index = function(tbl, i) return end,
			__newindex = function(tbl, i) return end
		}

		methods.__call = function(tbl, ...)
			if Util.getMethodContext(4) == deepCopy then return end

			local args = {...}
			local f = false
			for _, func in functionTable do
				local argCount, isVariadic = debug.info(func, 'a')
				if argCount == #args or isVariadic then
					f = true
					func(...)
					return -- Comment or remove this if you want to run multiple functions at the same time.
				end
			end

			if not f and #args > 0 then LogErrorNonFatal("overloadfunctionArgumentMismatch", false, #args, name) end
		end

		if not nClassData[specifierName] then nClassData[specifierName] = {} end
		nClassData[specifierName][name] = setmetatable({}, methods)
	end

	return setmetatable(class :: any, methods)
end

--////// Module Functions


--[[
	Returns a new <code>class</code> with the given <code>classData</code>.
]]
function classpp.class(className: string): (classData: classData) -> class
	if typeof(className) ~= "string" then LogError("classNameNotString") end
	if Classes[className] then LogError("classAlreadyExists", false, className or "Unknown") end

	return function(classData: classData): class
		if typeof(classData) ~= "table" then LogError("classDataNotTable") end

		if getmetatable(classData :: any) or not select(1, pcall(function() setmetatable(classData, {}) end)) then -- Checking if the given ClassData contains a metatable.
			LogError("classDataContainsMetatable")
		end

		local isAPropertyRedeclared, redeclaredIndex = checkRedecleration(classData)
		if isAPropertyRedeclared then LogError("classPropertyRedecleration", false, redeclaredIndex) end

		if findPropertyFromIndex(classData, "Destroy") then LogError("invalidDestructorDecleration", false) end
		if checkOutsideAccessSpecifierDecleration(classData) then LogError("invalidAccessSpecifierError", false) end

		local nCObj: class = createClassObject(classData, className)
		Classes[className] = nCObj

		return nCObj
	end
end

function classpp.abstract(class: class): class
	if Type.typeof(class) ~= "Class" then LogError("typeofObjectIsNotClass") end
	if class["__final"] then LogError("illegalModifierCombination", true, `abstract and final`) end 

	class["__abstract"] = true
	return class
end

function classpp.final(class: class): class
	if Type.typeof(class) ~= "Class" then LogError("typeofObjectIsNotClass") end
	if class["__abstract"] then LogError("illegalModifierCombination", true, `final and abstract`) end 

	class["__final"] = true
	return class
end

function classpp.getClass(className: string): class
	if typeof(className) ~= "string" then LogError("classNameNotString") end
	if not Classes[className] then LogError("classNotFound") end

	return Classes[className]
end

classpp.Type = Type
classpp.Util = Util

return classpp
