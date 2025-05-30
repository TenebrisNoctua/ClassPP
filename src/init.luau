--!native
--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		The main module of Class++.
	////
--]]

--////// Variables

local classpp = {}

local Util = require(script.Util)
local Error = require(script.Error)
local Type = require(script.Type)

local LogError = Error.logError
local LogErrorNonFatal = Error.logErrorNonFatal
local LogWarning = Error.logWarning

local operatorFuncNames: {string} = {"operator_add", "operator_sub", "operator_mul", "operator_div", "operator_idiv", "operator_mod", "operator_pow", "operator_unm", "operator_eq"}
local silenceUpdateWarning: boolean = script:GetAttribute("silenceUpdateWarning") or false

local Classes: {[string]: class} = {}

--////// Types

export type classData = Type.classData
export type class<AccessSpecifier = any?> = Type.class<AccessSpecifier>

type internalClassData = {
	Public: {[any]: any}?,
	Private: {[any]: any}?,
	Protected: {[any]: any}?,
	Friend: {any}?,
	Internal: {
		__type: string?,
		__locked: boolean?,
		constructor: (self: any, ...any) -> ()?,
		destructor: (self: any) -> ()?,
	}
}
type internalClass<AccessSpecifier = any?> = typeof(setmetatable({} :: {
	new: (...any) -> AccessSpecifier,
	extends: (className: string) -> (classData: classData) -> class<AccessSpecifier>,
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
	static: (accessSpecifier: string, name: string, property: any) -> (),
	Name: string,
	Inherits: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end})),
	Friends: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end})),
	Statics: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end}))?
}, {
	__index = function(t, i) return end :: ({any}, any) -> (any),
	__newindex = function(t, i, v) end :: ({any}, any, any) -> (),
	__type = "",
	__classtype = "",
	__abstract = false,
	__final = false
}))

--////// Local Functions

--// A deep copy function for tables, with support for metatables.
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

--// Sorts the classData into an objectData that can be used inside objects.
local function sortAttributes(data: classData, className: string): internalClassData
	local classObjTbl: internalClassData = deepCopy(data)

	classObjTbl.Friend = nil
	classObjTbl.Internal = {
		__type = className,
		__locked = false
	}

	if classObjTbl["constructor"] then 
		classObjTbl.Internal.constructor = classObjTbl["constructor"] 
		classObjTbl["constructor"] = nil
	end

	if classObjTbl["destructor"] then
		classObjTbl.Internal.destructor = classObjTbl["destructor"]
		classObjTbl["destructor"] = nil
	end

	return classObjTbl
end

--// Recursively cleans the given table.
local function recursiveClean(tbl: {[any]: any})
	for key, value in tbl do
		if typeof(key) == "Instance" then key:Destroy() end
		if typeof(value) == "table" then
			for _, v in tbl do
				if v == value then return end
			end
			recursiveClean(value)
		elseif typeof(value) == "Instance" then
			value:Destroy()
		end

		tbl[key] = nil
	end
end

--// Cleans the objectData (except for the Internal data) and locks the object.
local function objectCleaner(objectTbl: {[string]: any}): {}
	for accessSpecifier, attributesData in objectTbl do
		if accessSpecifier == "Internal" then continue end
		recursiveClean(attributesData)
	end
	objectTbl.Internal.__locked = true
	return objectTbl
end

--// Merges classDatas of two related classes for inheritation.
local function mergeClassData(superClassData: classData, childClassData: classData): classData
	local newClassData: classData = {
		Public = {},
		Private = {},
		Protected = {}
	}

	for accessSpecifier, attributesData in superClassData do
		if accessSpecifier == "Private" then continue end
		if typeof(attributesData) == "function" then continue end

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

--// Checks if the given string is a valid access specifier.
local function checkValidAccessSpecifier(specifierString: string): (boolean, string?)
	local accessSpecifiers: {string} = {"Public", "Private", "Protected", "Internal", "Friend"}

	for _, accessSpecifier in accessSpecifiers do
		if specifierString == accessSpecifier then
			return true, accessSpecifier
		end
	end

	return false
end

--// Returns the access specifier of an index.
local function returnAccessSpecifier(index: string, classData: any): string?
	for accessSpecifier, attributesData in classData do
		if typeof(attributesData) == "table" and attributesData[index] ~= nil then
			return accessSpecifier
		end
	end
	return
end

--// Finds the property that's been set to the given index. If given a string that contains an access specifier, it tries to find the property inside that access specifier.
local function findPropertyFromIndex(classData: internalClassData | classData, index: string, accessSpecifier: string?): any?
	local fAccessSpecifier = accessSpecifier or returnAccessSpecifier(index, classData)
	if not (classData :: any)[fAccessSpecifier] then return end
	if (classData :: any)[fAccessSpecifier][index] ~= nil then
		return (classData :: any)[fAccessSpecifier][index]
	end
	return
end

--// Calls an operator function from the given name.
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

--// Checks if the given index has already been set inside an access specifier.
local function checkRedeclaration(classData: classData, index: string?): (boolean, any?)
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
				if checkRedeclaration(classData, attributeKey) then return true, attributeKey end
			end
		end
	end

	return false
end

--// Checks if there are any indexes inside the classData that aren't valid access specifiers or functions.
local function checkOutsideAccessSpecifierDecleration(classData: classData): boolean
	for index, value in classData do
		if typeof(index) ~= "string" then continue end
		if not checkValidAccessSpecifier(index) and index ~= "constructor" and index ~= "destructor" then
			return true
		end
	end

	return false
end

--// Sets the metamethods of an object.
local function setMetamethods(class: internalClass, classData: internalClassData, methods)
	methods.__metatable = 'The metatable is locked.'

	function methods:__index(index): any
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, index)
			elseif accessSpecifier == "Internal" and Util.getMethodContext(7) ~= Type.typeof then
				LogError("classPropertyIsInternal", true, index)
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, true, true, Classes) then
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
		if rprop ~= nil then return rprop elseif index ~= "constructor" and index ~= "destructor" and index ~= "__tostring" and not sFound then LogErrorNonFatal("classMemberNotFound", true, index) end

		return
	end

	function methods:__newindex(index, value)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		if value == nil then LogError("classMemberCannotSetToNil", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, index)
			elseif accessSpecifier == "Internal" then
				LogError("classPropertyIsInternal", true, index)
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, true, true, Classes) then				
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

	for _, operatorFuncName in operatorFuncNames do
		if not (classData.Public :: {[any]: any})[operatorFuncName] then continue end

		methods[string.gsub(operatorFuncName, "operator", "_")] = function(obj, obj2)
			if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
			return callOperator(operatorFuncName, obj, obj2)
		end
	end
end

--// Creates a new class object with the given classData, className and an additional internalFunctionsList table to allow access for functions inside it to write to Inherits and Friends tables.
local function createClassObject<AccessSpecifier>(nClassData: classData, className: string, internalFunctionsList: {(...any) -> (any)}?, superClassConstructor: (self: any, ...any) -> ()?): internalClass<AccessSpecifier>
	local class: internalClass = setmetatable({
		Inherits = setmetatable({}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5) if f ~= createClassObject and internalFunctionsList and not table.find(internalFunctionsList, f) then LogError("attemptToModifyReadOnlyTable", false) end rawset(t :: any, i :: any, v :: any) end, __metatable = {} }),
		Friends = setmetatable({}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5) if f ~= createClassObject and internalFunctionsList and not table.find(internalFunctionsList, f) then LogError("attemptToModifyReadOnlyTable", false) end rawset(t :: any, i :: any, v :: any) end, __metatable = {} }),
		Name = className
	} :: {
		new: (...any) -> AccessSpecifier,
		extends: (className: string) -> (classData: classData) -> class,
		overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
		static: (accessSpecifier: string, name: string, property: any) -> (),
		Name: string,
		Inherits: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end})),
		Friends: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end})),
		Statics: typeof(setmetatable({}, {__newindex = function(t, i, v) end, __metatable = {}, __tostring = function() end}))?
	}, {
		__index = function(t, i) return rawget(t, i)  end,
		__newindex = function(t, i, v) rawset(t, i, v) end,
		__type = "",
		__classtype = "",
		__abstract = false,
		__final = false
	})

	class.Statics = setmetatable({}, {__tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5) if f ~= class.static then LogError("attemptToModifyReadOnlyTable", false) end rawset(t :: any, i :: any, v :: any) end, __metatable = {}})

	if not nClassData.Public then nClassData.Public = {} end
	if not nClassData.Private then nClassData.Private = {} end
	if not nClassData.Protected then nClassData.Protected = {} end
	
	if nClassData.Friend then
		for _, friend in nClassData.Friend do
			table.insert(class.Friends :: any, friend)
		end
	end
	
	local overloadedFunctions = {}

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
		if i == "__ovfunc" and Util.getMethodContext(5) == Util.inClassScope then
			return overloadedFunctions
		end

		local result = nClassData[i] or findPropertyFromIndex(nClassData, i)
		if not result then return (class.Statics :: any)[i] end

		local methodContext, name = Util.getMethodContext(5)
		if typeof(result) == "function" and methodContext ~= Util.inClassScope then LogError("cannotCallFunctionError") elseif typeof(result) == "table" and getmetatable(result) and getmetatable(result)["__call"] and methodContext ~= Util.inClassScope then LogError("cannotCallFunctionError") end

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

		if superClassConstructor then superClassConstructor(newObj, ...) end

		if newObjTbl.Internal.constructor then
			newObjTbl.Internal.constructor(newObj, ...)
		end

		return newObj
	end

	function class.extends(className: string): (extendedClassData: classData) -> class
		if typeof(className) ~= "string" then LogError("classNameNotString") end
		if Classes[className] then LogError("classAlreadyExists", false, className) end
		if not silenceUpdateWarning then LogWarning("compatibilityWarning", false) end

		return function(extendedClassData: classData): class
			local newClassData = mergeClassData(nClassData, extendedClassData)
			local newClass = createClassObject(newClassData, className, {debug.info(1, 'f')}, nClassData.constructor)
			Classes[className] = newClass

			table.insert(newClass.Inherits :: any, class)

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
			table.insert(overloadedFunctions, func)
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

		nClassData[specifierName][name] = setmetatable({}, methods)
	end

	function class.static(accessSpecifier: string, name: string, property: any)
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" or specifierName and specifierName == "Protected" then LogError("invalidAccessSpecifierError", true) end
		if not name then LogError("staticMemberNameNotSet", true) end
		if not class.Statics then return end
		if not nClassData[specifierName] then nClassData[specifierName] = {} end
		
		if not silenceUpdateWarning then LogWarning("compatibilityWarning", false) end

		local newObj = newproxy(true)
		local methods = getmetatable(newObj)

		function methods:__index(index): any
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, name)
			end

			return property
		end

		function methods:__newindex(index, value)
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, name)
			end

			property = value
			return property
		end

		function methods:__call(...)
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, name)
			end

			if typeof(property) == "function" then 
				return property(...) 
			else
				return property
			end
		end

		function methods:__tostring()
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, Classes) then
				LogError("classPropertyIsPrivate", true, name)
			end

			return tostring(property)
		end

		class.Statics[name] = newObj
	end

	return setmetatable(class :: any, methods)
end

--////// Module Functions

--[[
	Returns a new <code>class</code> with the given <code>className</code> and <code>classData</code>.
]]
function classpp.class(className: string): <T>(classData: {Public: T?} & classData) -> class<T>
	if typeof(className) ~= "string" then LogError("classNameNotString") end
	if Classes[className] then LogError("classAlreadyExists", false, className or "Unknown") end

	return function<T>(classData: classData & {Public: T?}): class<T>
		if typeof(classData) ~= "table" then LogError("classDataNotTable") end
		if getmetatable(classData :: any) or not select(1, pcall(setmetatable, classData, {})) then LogError("classDataContainsMetatable") end

		local isAPropertyRedeclared: boolean, redeclaredIndex: any? = checkRedeclaration(classData)
		if isAPropertyRedeclared then LogError("classPropertyRedeclaration", false, redeclaredIndex) end

		if findPropertyFromIndex(classData, "Destroy") then LogError("invalidDestructorDecleration", false) end
		if checkOutsideAccessSpecifierDecleration(classData) then LogError("invalidAccessSpecifierInClassDataError", false) end
		
		local nCObj: internalClass<T> = createClassObject(classData, className)
		Classes[className] = nCObj

		return nCObj
	end
end

--[[
	Marks the given <code>class</code> or <code>class</code>es as abstract. If given multiple, then the first class will be returned.
]]
function classpp.abstract(classTable: {class}): class
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class: class in classTable do
		if Type.typeof(class) ~= "Class" then LogError("typeofObjectIsNotClass") end
		if class["__final"] then LogError("illegalModifierCombination", true, `abstract and final`) end 

		class["__abstract"] = true
	end

	return classTable[1]
end

--[[
	Marks the given <code>class</code> or <code>class</code>es as final. If given multiple, then the first class will be returned.
]]
function classpp.final(classTable: {class}): class
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class: class in classTable do
		if Type.typeof(class) ~= "Class" then LogError("typeofObjectIsNotClass") end
		if class["__abstract"] then LogError("illegalModifierCombination", true, `final and abstract`) end 

		class["__final"] = true
	end

	return classTable[1]
end

--[[
	Returns the <code>class</code> with the given <code>className</code>, if it exists.
]]
function classpp.getClass(className: string): class
	if typeof(className) ~= "string" then LogError("classNameNotString") end
	if not Classes[className] then LogError("classNotFound") end

	return Classes[className]
end

classpp.Type = Type
classpp.Util = Util

return classpp