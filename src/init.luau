--!native
--!strict

--[[
	Written by @TenebrisNoctua.
	The main module of Class++.
--]]

--// Variables

-- Use @self when it becomes available.
local Util = require("./ClassPP/Utility")
local Logger = require("./ClassPP/Log/Logger")
local Type = require("./ClassPP/Type")

local LogError = Logger.logError
local LogErrorNonFatal = Logger.logErrorNonFatal
local LogWarn = Logger.logWarn

local classes = {} :: {[string]: internalClass}
local classpp = {version = {major = 2, minor = 0, patch = 0, beta = true}} :: classPP<typeof(Util), typeof(Type)>

local accessSpecifiers: accessSpecifiers = {"Public", "Private", "Protected", "Friend", "Internal", "Static"}
local overloadableOperators: overloadableOperators = {"operator_add", "operator_sub", "operator_mul", "operator_div", "operator_idiv", "operator_mod", "operator_pow", "operator_unm", "operator_eq"}

--// Types

type classPP<Util, Type> = Type.classPP<Util, Type>
type accessSpecifiers = Type.accessSpecifiers
type overloadableOperators = Type.overloadableOperators

export type classData<T> = Type.classData<T>
export type class<AccessSpecifierTable> = Type.class<AccessSpecifierTable, AccessSpecifierTable>

type defaultClassData = classData<{Public: {}, Private: {}, Protected: {}, Friend: {}}> 
type objectData = Type.objectData
type internalClass = Type.internalClass

type anyTable = Type.anyTable
type deepAnyTable = Type.deepAnyTable
type metatable<T, V = any?> = setmetatable<{T}, {V}>

--// Local Functions

-- A deep copy function for tables, with support for metatables.
local function deepCopy<T>(original: T): T
	local copy = table.clone(original) :: T & anyTable
	
	for key, value in (original :: anyTable) do
		if type(value) == "table" then
			local tmetatable = getmetatable(value :: metatable<{}>);
			copy[key] = if not tmetatable then deepCopy(value :: metatable<{}>) else value
		end
	end

	return copy
end

-- Recursively cleans the given table.
local function recursiveClean(tbl: deepAnyTable)
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

-- Sorts the classData into an objectData that can be used inside objects.
local function sortAttributes(data: defaultClassData, className: string): objectData
	local classObjTbl = deepCopy(data) :: anyTable

	classObjTbl.Friend = nil
	classObjTbl.Internal = {
		__type = className,
		__locked = false,
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

-- Cleans the given object's objectData table.
local function objectCleaner(objectData: objectData): objectData
	for accessSpecifier, attributesData in objectData do
		if accessSpecifier == "Internal" then continue end
		recursiveClean(attributesData)
	end

	objectData.Internal.__locked = true
	return objectData
end

-- Merge the <code>classData</code>s in the given <code>classDataTable</code> with the <code>childClassData</code>.
local function mergeClassDatas(classDataTable: {defaultClassData}, childClassData: defaultClassData): defaultClassData
	local newClassData = {Public = {}, Private = {}, Protected = {}} :: defaultClassData

	local function merge(classData: defaultClassData)
		if classData.Public then
			for attributeName, attributeData in classData.Public do
				newClassData.Public[attributeName] = attributeData
			end
		end
		if classData.Protected then
			for attributeName, attributeData in classData.Protected do
				newClassData.Protected[attributeName] = attributeData
			end
		end

		if classData.constructor then newClassData.constructor = classData.constructor end
		if classData.destructor then newClassData.destructor = classData.destructor end
	end

	-- Merge all classData tables.
	for _, classData in ipairs(classDataTable) do
		merge(classData)
	end

	-- Merge the childClassData.
	merge(childClassData)
	
	newClassData.Private = childClassData.Private
	newClassData.Friend = childClassData.Friend

	return newClassData
end

-- Checks if the given string is a valid access specifier.
local function checkValidAccessSpecifier(specifierString: string): (boolean, string?)	
	for _, accessSpecifier in accessSpecifiers do
		if specifierString == accessSpecifier then
			return true, accessSpecifier
		end
	end

	return false, nil
end

-- Returns the access specifier of an index.
local function returnAccessSpecifier(index: string, classData: objectData): string?
	for accessSpecifier, attributesData in classData do
		if typeof(attributesData) == "table" and attributesData[index] ~= nil then
			return accessSpecifier
		end
	end

	return nil
end

-- Finds the property that's been set to the given index. If given an access specifier string, it will try to find the property inside that access specifier.
local function findPropertyFromIndex(classData: objectData, index: string, accessSpecifier: string?): any?
	local fAccessSpecifier = accessSpecifier or returnAccessSpecifier(index, classData)
	local attributesData = classData[fAccessSpecifier]

	if not attributesData then return end
	return attributesData[index]
end

-- Checks if the given index has already been set inside an access specifier.
local function checkRedeclaration(classData: defaultClassData, index: string?): (boolean, any?)
	if not classData then return false end

	if index then
		local fnumber = 0
		for accessSpecifier, attributesData in classData do
			if typeof(attributesData) ~= "table" then continue end
			if (attributesData :: anyTable)[index] then fnumber += 1 end
		end
		if fnumber >= 2 then return true, index end
	else
		for accessSpecifier, attributesData in classData do
			if typeof(attributesData) ~= "table" then continue end
			for attributeKey, _ in attributesData do
				if checkRedeclaration(classData, attributeKey) then return true, attributeKey end
			end
		end
	end

	return false
end

-- Checks if there are any indexes inside the classData that aren't valid access specifiers or functions.
local function checkOutsideAccessSpecifierDecleration(classData: defaultClassData): boolean
	for index, value in classData do
		if typeof(index) ~= "string" then continue end
		if not checkValidAccessSpecifier(index) and index ~= "constructor" and index ~= "destructor" then
			return true
		end
	end

	return false
end

-- Calls an operator function from the given name.
local function callOperator(functionName: string, obj: anyTable, obj2: anyTable?, silenceError: boolean?): boolean | any
	if typeof(obj) == "userdata" then
		if obj[functionName] then
			return obj[functionName](obj, obj2)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, {functionName})
		end
	elseif typeof(obj2) == "userdata" then
		if (obj2 :: anyTable)[functionName] then
			return (obj2 :: anyTable)[functionName](obj2, obj)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, {functionName})
		end
	end

	return false
end

-- Sets the metamethods of an object.
local function setMetamethods(class: internalClass, classData: objectData, methods: anyTable)
	methods.__metatable = 'The metatable is locked.'

	function methods:__index(index: string): any
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)
		
		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Internal" and Util.getMethodContext(7) ~= Type.typeof then
				LogError("classPropertyIsInternal", true, {index})
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, true, false) then
				LogError("classPropertyIsProtected", true, {index})
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
			for _, opfuncname in overloadableOperators do
				if index == opfuncname and Util.getMethodContext(5) ~= callOperator :: any then -- Temp usage for :: any to silence the type warning bug.
					LogError("nonNativeOperatorCall", true, {index})
				end
			end
		end
		
		local rprop = findPropertyFromIndex(classData, index, accessSpecifier)
		if rprop ~= nil then return rprop elseif index ~= "constructor" and index ~= "destructor" and index ~= "__tostring" and not sFound then LogError("classMemberNotFound", true, {index}) end		
		return
	end

	function methods:__newindex(index: string, value)
		if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
		if value == nil then LogError("classMemberCannotSetToNil", true) end

		local accessSpecifier = returnAccessSpecifier(index, classData)

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Internal" then
				LogError("classPropertyIsInternal", true, {index})
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, false, false) then
				LogError("classPropertyIsProtected", true, {index})
			end
		end

		for _, attributesData in classData do
			local foundAttribute = attributesData[index]
			if typeof(attributesData) == "table" and foundAttribute ~= nil then
				if foundAttribute == value then return end
				attributesData[index] = value
				return
			end
		end

		LogError("classMemberNotFound", true, {index})
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

	for _, operatorFuncName in overloadableOperators do
		if not classData.Public then return end
		if not classData.Public[operatorFuncName] then continue end

		methods[string.gsub(operatorFuncName, "operator", "_")] = function(obj, obj2)
			if classData.Internal.__locked == true then LogError("classObjectLocked", true) end
			return callOperator(operatorFuncName, obj, obj2)
		end
	end
end

local function getInheritedClassConstructors(parent: internalClass, inheritedClassConstructors: {any})
	local parentClassData: defaultClassData = parent.classData
	if parentClassData.constructor then table.insert(inheritedClassConstructors, 1, parentClassData.constructor) end
	if parent.Inherits[1] then getInheritedClassConstructors(parent.Inherits[1], inheritedClassConstructors) end
end

local returnClassFunction: (className: string, ...any) -> any

local function createClassObject(newClassData: defaultClassData, className: string, inheritedClasses: {internalClass}?)
	local class: internalClass = {
		Inherits = setmetatable(inheritedClasses or {}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= createClassObject then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end, __metatable = {} }),
		Friends = setmetatable(newClassData.Friend or {}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= createClassObject then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end, __metatable = {} }),
		Name = className
	}
	
	class.Statics = setmetatable({}, {__newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= class.static then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end :: (...any) -> any, __metatable = {}, __tostring = function() return '{}' end :: () -> any})
	if not class.Statics then return (LogError("unknownError", true) :: any) {} :: any end -- For type refinement, should never run.
	
	local overloadedFunctions: {(...any) -> (...any?)} = {}
	local inheritedClassConstructors: {(self: any, ...any) -> (any)} = {}
	
	if inheritedClasses then getInheritedClassConstructors(inheritedClasses[1], inheritedClassConstructors) end
	
	if not newClassData.Public then (newClassData :: any).Public = {} end
	if not newClassData.Private then (newClassData :: any).Private = {} end
	if not newClassData.Protected then (newClassData :: any).Protected = {} end
	
	--// Class Metatable

	local methods = {
		__type = "Class",
		__classtype = className,
		__abstract = false,
		__final = false
	}	

	function methods.__index(t: internalClass, i: string): any
		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == Util.getMethodContext(5) or classpp.final == Util.getMethodContext(5) then
				return (methods.__abstract) :: any -- Cast to :: any to silence the type solver bug related to type packs.
			end
		end
		if i == "__final" then 
			if classpp.final == Util.getMethodContext(5) or classpp.abstract == Util.getMethodContext(5) or returnClassFunction :: any == Util.getMethodContext(5) then
				return (methods.__final) :: any -- Cast to :: any to silence the type solver bug related to type packs.
			end
		end
		if i == "classData" then
			local f = (Util.getMethodContext(5) :: any)
		
			if returnClassFunction == f or createClassObject == f or getInheritedClassConstructors == f then
				return newClassData
			else
				LogError("classClassDataInternal", true, {className})
			end
		end
		if i == "overloadlist" then
			if Util.inClassScope == Util.getMethodContext(5) then
				return overloadedFunctions
			end
		end

		local result = newClassData[i] or findPropertyFromIndex(newClassData :: objectData, i)
		if not result then return class.Statics[i] end

		local methodContext = Util.getMethodContext(5)
		if typeof(result) == "function" and methodContext ~= Util.inClassScope and methodContext ~= Util.checkFriendship then LogError("cannotCallFunctionError", true) elseif typeof(result) == "table" and getmetatable(result :: metatable<{}>) and getmetatable(result :: metatable<{__call: () -> ()}>)["__call"] and methodContext ~= Util.inClassScope then LogError("cannotCallFunctionError", true) end

		return result
	end

	function methods.__newindex(t: internalClass, i: string, v: any)
		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == Util.getMethodContext(5) and v == true then
				methods.__abstract = true
				class.new = function()
					return LogError("attemptToCreateObjectFromAbstractClass", true)
				end :: any
			end
			return
		end
		if i == "__final" then
			if classpp.final == Util.getMethodContext(5) and v == true then methods.__final = true end
			return
		end

		newClassData[i] = v

		return v
	end
	
	--// Class Methods
	
	function class.new(...)
		local newObjData: objectData = sortAttributes(newClassData, className)
		local newObject = newproxy(true)
		local proxyMethods = getmetatable(newObject)
		
		setMetamethods(class, newObjData, proxyMethods)
		
		for _, inheritedConstructor in inheritedClassConstructors do
			inheritedConstructor(newObject, ...)
		end
		
		if newObjData.Internal.constructor then newObjData.Internal.constructor(newObject, ...) end
		
		return newObject
	end
	
	function class.extends()
		LogError("extendsDeprecated", true)
	end
	
	function class.overload(accessSpecifier: string, name: string, functionTable: {(...any) -> (any)})
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" then LogError("invalidAccessSpecifierError", true) end
		if not name then LogError("overloadfunctionNameNotSet", true) end
		if typeof(functionTable) ~= "table" or #functionTable == 0 then LogError("overloadfunctionTableNotGiven", true) end
		if not specifierName then return end
		
		for _, func in functionTable do
			if typeof(func) ~= "function" then LogError("expectedFunctionError", true, {typeof(func)}) end
		end
		
		local function overloadHandler(...)
			if Util.getMethodContext(4) == deepCopy then return end

			local args = {...}
			local f = false

			for _, func in functionTable do
				local argCount, isVariadic = debug.info(func, 'a')
				if argCount == #args or isVariadic then
					f = true
					return func(...)
				end
			end

			if not f and #args > 0 then LogErrorNonFatal("overloadfunctionArgumentMismatch", false, {#args, name}) end
		end
		
		newClassData[specifierName][name] = overloadHandler
		table.insert(overloadedFunctions, overloadHandler)
	end
	
	function class.static(accessSpecifier: string, name: string, property: any)
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" or specifierName and specifierName == "Protected" then LogError("invalidAccessSpecifierError", true) end
		if not name then LogError("staticMemberNameNotSet", true) end
		if not class.Statics then return end
		
		local newObj = newproxy(true)
		local methods = getmetatable(newObj)

		function methods:__index(index): any
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {name})
			end

			return property
		end

		function methods:__newindex(index, value)
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {name})
			end

			property = value
			return property
		end

		function methods:__call(...)
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {name})
			end

			if typeof(property) == "function" then 
				return property(...) 
			else
				return property
			end
		end

		function methods:__tostring()
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {name})
			end

			return tostring(property)
		end

		class.Statics[name] = newObj
		
		return newObj
	end
	
	return setmetatable(class, methods)
end

local function constructClass(classDataArg: defaultClassData, className: string, otherClassDatas: {defaultClassData}?, otherClasses: {internalClass}?)
	if typeof(classDataArg) ~= "table" then LogError("classDataNotTable", false, {className}) end
	if getmetatable(classDataArg :: metatable<defaultClassData>) or not select(1, pcall(setmetatable, classDataArg, {})) then LogError("classDataContainsMetatable", false, {className}) end
	
	local isAPropertyRedeclared: boolean, redeclaredIndex: any? = checkRedeclaration(classDataArg)
	if isAPropertyRedeclared then LogError("classPropertyRedeclaration", false, redeclaredIndex) end

	if findPropertyFromIndex(classDataArg :: objectData, "Destroy") then LogError("invalidDestructorDecleration", false) end
	if checkOutsideAccessSpecifierDecleration(classDataArg) then LogError("invalidAccessSpecifierInClassData", false, {className}) end
	
	local newClassData: defaultClassData = if not otherClassDatas then classDataArg else mergeClassDatas(otherClassDatas, classDataArg)

	local nCObj: internalClass = createClassObject(newClassData, className, otherClasses)
	classes[className] = nCObj

	return nCObj
end

returnClassFunction = function(className: string, ...): any?
	local argTable = {...}
	local count = #argTable
	local firstArg = argTable[1]

	if count >= 2 then
		local classDataTable: {defaultClassData} = {}
		local classTable: {internalClass} = {}

		for _, class in argTable do
			local class: internalClass = class
			if Type.type(class) ~= "Class" then continue end
			if class["__final"] then LogError("attemptToExtendAFinalClass", true) end

			table.insert(classDataTable, class.classData)
			table.insert(classTable, class)
		end

		return function<T>(classDataArg: T)
			return constructClass(classDataArg, className, classDataTable, classTable)
		end
	elseif count == 1 and Type.type(firstArg) == "Class" then
		local class: internalClass = firstArg
		if class["__final"] then LogError("attemptToExtendAFinalClass", true) end
		
		local classDataTable: {defaultClassData} = {class.classData}
		local classTable: {internalClass} = {class}

		return function<T>(classDataArg: T)
			return constructClass(classDataArg, className, classDataTable, classTable)
		end
	else
		return constructClass(argTable[1], className)
	end
end	

--// Module Functions

function classpp.class(className: string): any?
	return function (...): any?
		return returnClassFunction(className, ...)
	end
end

function classpp.abstract(classTable: {internalClass})
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class in classTable do
		if Type.type(class) ~= "Class" then LogError("typeofObjectIsNotClass", false) end
		if class["__final"] then LogError("illegalModifierCombination", true, {`abstract and final`}) end 

		class["__abstract"] = true
	end

	return classTable[1]
end

function classpp.final(classTable: {internalClass})
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class in classTable do
		if Type.type(class) ~= "Class" then LogError("typeofObjectIsNotClass", false) end
		if class["__abstract"] then LogError("illegalModifierCombination", true, {`final and abstract`}) end 

		class["__final"] = true
	end

	return classTable[1]
end

function classpp.getClass(className: string)
	if typeof(className) ~= "string" then LogError("classNameNotString", false) end
	if not classes[className] then LogError("classNotFound", false) end
	return classes[className]
end

classpp.Type = Type
classpp.Util = Util

return classpp