--!native
--!strict

--[[
	Written by @TenebrisNoctua.
	The main module of Class++.
--]]

--[[
	WARNING: Unless you know exactly what you're doing, it is not recommended to modify the source code below.
	If you ever encounter a bug due to a modification that you have made (which is very likely to happen), DO NOT CREATE A BUG REPORT.
]]

--// Variables

const Util = require("@self/Utility")
const Logger = require("@self/Log/Logger")
const Type = require("@self/Type")

const nativeType = type
const nativeTypeof = typeof

const type = Type.type
const typeof = Type.typeof

const logError = Logger.logError
const logErrorNonFatal = Logger.logErrorNonFatal
const logWarn = Logger.logWarn

const inClassScope = Util.inClassScope
const binarySearch = Util.binarySearch
const getMethodContext = Util.getMethodContext
const findPropertyFromIndex = Util.findPropertyFromIndex
const returnAccessSpecifier = Util.returnAccessSpecifier
const checkFriendship = Util.checkFriendship

const classes = {} :: {[string]: internalClass}
const classpp = {version = {major = 2, minor = 2, patch = 0, beta = false}, autoObjectDestruction = true} :: classPP

const accessSpecifiers: accessSpecifiers = {"Friend", "Internal", "Private", "Protected", "Public"}
const overloadableOperators: overloadableOperators = {"operator_add", "operator_div", "operator_eq", "operator_idiv", "operator_mod", "operator_mul", "operator_pow", "operator_sub", "operator_unm"}
const operatorMetamethodNames: operatorMetamethodNames = {["operator_add"] = "__add", ["operator_div"] = "__div", ["operator_eq"] = "__eq", ["operator_idiv"] = "__idiv", ["operator_mod"] = "__mod", ["operator_mul"] = "__mul", ["operator_pow"] = "__pow", ["operator_sub"] = "__sub", ["operator_unm"] = "__unm"}

--// Types

type classPP = Type.classPP<typeof(Util), typeof(Type)>
type accessSpecifiers = Type.accessSpecifiers
type overloadableOperators = Type.overloadableOperators
type operatorMetamethodNames = Type.operatorMetamethodNames

export type classData<T> = Type.classData<T>
export type class<T> = Type.class<T>
export type object<T> = Type.object<T>

type defaultClassData = Type.defaultClassData
type objectData = Type.objectData
type internalClass = Type.internalClass

type anyTable = Type.anyTable
type deepAnyTable = Type.deepAnyTable
type metatable<T, V> = setmetatable<{T}, {V}>

--// Local Functions

-- Shallow copies the original to a copy
local function shallowCopy(original: anyTable, copy: anyTable): ()
	for key, val in original do
		copy[key] = val
	end
end

-- A deep copy function for tables, with support for metatables.
local function deepCopy<T>(original: T | anyTable, copyMetatable: boolean?): T 
	local copy = {}
	shallowCopy(original, copy)
	
	for key, value in original do
		if nativeType(value) ~= "table" then continue end
		local metatable = getmetatable(value)

		if not metatable then 
			copy[key] = deepCopy(value, true) 
		elseif not copyMetatable then 
			local success, result = pcall(setmetatable, value, {})
			local copyTable

			if success then 
				copyTable = result
			else
				copyTable = {}
				shallowCopy(value, copyTable)
			end

			copy[key] = deepCopy(copyTable, true) 
		else 
			copy[key] = value
		end
	end

	return copy
end

-- Recursively cleans the given table.
local function recursiveClean(tbl: anyTable)
	for key, value in tbl do
		local keyType = nativeTypeof(key)
		local valueType = nativeTypeof(value)

		if keyType == "Instance" then key:Destroy() end
		if valueType == "table" then
			for _, v in tbl do
				if v == value then return end
			end
			recursiveClean(value)
		elseif valueType == "Instance" then
			value:Destroy()
		elseif valueType == "RBXScriptConnection" then
			value:Disconnect()
		elseif valueType == "thread" then
			pcall(task.cancel, value)
		end

		tbl[key] = nil
	end
end

-- Detects when an object gets garbage collected.
local function runOnGarbageCollection(object: unknown, callback: () -> ())
	local alive_test = setmetatable({object}, {__mode = "v"})
	coroutine.wrap(function() -- Unlike task.spawn, this method is faster at creating a new thread, though a bit more unreliable.
		repeat task.wait(1) until alive_test[1] == nil
		callback()
	end)()
end

-- Cleans the given object's objectData table.
local function objectCleaner(objectData: objectData): objectData
	for accessSpecifier, attributesData in objectData do
		if accessSpecifier == "Internal" then continue end
		recursiveClean(attributesData)
		objectData[accessSpecifier] = nil
	end

	objectData.Internal.__locked = true
	return objectData
end

-- Runs on garbage collection.
local function garbageCollectionCallback(objectData: objectData)
	if objectData.Internal.__locked then
		table.clear(objectData)
	else
		if objectData.Internal.destructor then
			-- We create a copy of the object here, because giving a direct reference to the object will cause this function to never be run.
			-- This copy will immediately be deleted after destructor runs.
			local objectCopy = setmetatable({}, {__metatable = "This table is locked."}) :: metatable<{[string]: any}, {__metatable: string}>

			for k, v in objectData.Protected do
				objectCopy[k] = v
			end
			for k, v in objectData.Public do
				if k == "Destroy" or k == "super" then continue end
				objectCopy[k] = v
			end
			for k, v in objectData.Private do
				objectCopy[k] = v
			end

			local success, err = pcall(objectData.Internal.destructor, objectCopy)
			if not success then logErrorNonFatal("unhandledError", true, {"destructor", err}) end

			objectCleaner(objectData)
			table.clear(objectCopy)

			objectCopy = nil
		end

		table.clear(objectData)
	end
end

-- Recursively finds the parent function, and calls it.
local function recursiveFindParentFunction(obj: objectData, method: (...any) -> (any), class: internalClass, findType: "constructor" | "function", methodName: string?, ...)
	local inheritedClass: internalClass? = class.Inherits[1]
	if not class.classData then return end

	if findType == "constructor" then
		if inheritedClass and class.classData.constructor == method and inheritedClass.classData then
			return inheritedClass.classData.constructor(obj, ...)
		elseif inheritedClass then
			return recursiveFindParentFunction(obj, method, inheritedClass, "constructor", nil, ...)
		else
			logError("invalidConstructor", true, {typeof(obj)})
		end
	else
		if inheritedClass and inheritedClass.classData then
			local inheritedClassData = inheritedClass.classData
			local foundPublic: (...any) -> (any?) = inheritedClassData.Public[methodName]
			local foundProtected: (...any) -> (any?) = inheritedClassData.Protected[methodName]

			if foundPublic and nativeTypeof(foundPublic) == "function" and class.classData.Public[methodName] == method then 
				return foundPublic(obj, ...) 
			elseif foundProtected and nativeTypeof(foundProtected) == "function" and (class.classData.Protected[methodName] == method or class.classData.Public[methodName] == method) and method ~= foundProtected then
				return foundProtected(obj, ...)
			else
				return recursiveFindParentFunction(obj, method, inheritedClass, "function", methodName, ...)
			end
		else
			logError("cannotFindBaseClassMethod", true, {methodName, class.Name})
		end
	end
end

-- Sorts the classData into an objectData that can be used inside objects.
local function sortAttributes(classData: defaultClassData, className: string, class: internalClass): objectData
	local objectTbl: objectData = {
		Public = deepCopy(classData.Public),
		Private = deepCopy(classData.Private),
		Protected = deepCopy(classData.Protected),
		Internal = {
			__type = "Object",
			__objtype = className,
			__locked = false,
			constructor = classData.constructor,
			destructor = classData.destructor
		}
	}

	local inheritedClassNum = #class.Inherits
	local inheritedClass: internalClass = class.Inherits[1]
	local inheritedClassData = if inheritedClass then inheritedClass.classData else nil
	local classType = typeof(class)
	local destructor = objectTbl.Internal.destructor

	function objectTbl.Public.Destroy(obj: objectData)
		local objectType = type(obj)
		local objectClassType = typeof(obj)

		if objectType ~= "Object" then logError("invalidDestructorCall", true) end
		if objectClassType ~= classType then logError("classTypeMismatch", true, {objectType, classType}) end
		if getMethodContext(5) == objectTbl.Internal.constructor then logError("cannotCallFunctionFrom", true, {"Destroy", "constructor"}) end

		if destructor then 
			local success, err = pcall(destructor, obj)
			if not success then logErrorNonFatal("unhandledError", true, {"destructor", err}) end
		end

		objectCleaner(objectTbl)
	end

	function objectTbl.Public.super(obj: objectData, ...)
		local objectType = type(obj)
		local objectClassType = typeof(obj)

		if objectType ~= "Object" then logError("invalidSuperCall", true) end
		if objectClassType ~= classType then logError("classTypeMismatch", true, {objectType, classType}) end
		if inheritedClassNum > 1 or not inheritedClass then logError("invalidInheritation", true) end
		if not inheritedClassData then return end

		local method, currentMethod = getMethodContext(5)
		if method == destructor then logError("cannotCallFunctionFrom", true, {"super", currentMethod}) end

		if currentMethod == "constructor" then
			return recursiveFindParentFunction(obj, method, class, "constructor", nil, ...)
		else
			return recursiveFindParentFunction(obj, method, class, "function", currentMethod, ...)
		end
	end

	return objectTbl
end

-- Merge the <code>classData</code>s in the given <code>classDataTable</code> with the <code>childClassData</code>.
local function mergeClassDatas(classDataTable: {defaultClassData}, childClassData: defaultClassData): defaultClassData
	local newClassData = {Public = {}, Private = {}, Protected = {}}

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
	end

	local function finalize(classData: defaultClassData)
		for name, _ in newClassData.Protected do
			if newClassData.Public[name] or newClassData.Private[name] then
				newClassData.Protected[name] = nil
			end
		end

		if classData.constructor then newClassData.constructor = classData.constructor end
		if classData.destructor then newClassData.destructor = classData.destructor end

		newClassData.Private = classData.Private
		newClassData.Friend = classData.Friend
	end

	-- Merge all classData tables.
	for _, classData in ipairs(classDataTable) do
		merge(classData)
	end

	-- Merge the childClassData.
	merge(childClassData)

	-- Finalize the merge.
	finalize(childClassData)

	return newClassData
end

-- Checks if the given string is a valid access specifier.
local function checkValidAccessSpecifier(specifierString: string): (boolean, string?)
	local isFound = binarySearch(accessSpecifiers, specifierString)
	return isFound ~= nil, accessSpecifiers[isFound]
end

-- Checks if the given index has already been set inside an access specifier.
local function checkRedeclaration(classData: defaultClassData, index: string?): (boolean, any?)
	if not classData then return false end

	if index then
		local fnumber = 0

		if classData.Public and classData.Public[index] then fnumber += 1 end
		if classData.Private and classData.Private[index] then fnumber += 1 end
		if classData.Protected and classData.Protected[index] then fnumber += 1 end
		if fnumber >= 2 then return true, index end
	else
		for _, attributesData in classData do
			if nativeTypeof(attributesData) ~= "table" then continue end
			for attributeKey, _ in attributesData do
				if checkRedeclaration(classData, attributeKey) then return true, attributeKey end
			end
		end
	end

	return false
end

-- Checks if there are any indexes inside the classData that aren't valid access specifiers or functions.
local function checkOutsideAccessSpecifierDecleration(classData: defaultClassData): boolean
	for index, _ in classData do
		if nativeTypeof(index) ~= "string" then return true end
		if not checkValidAccessSpecifier(index) and index ~= "constructor" and index ~= "destructor" then return true end
	end

	return false
end

-- Checks if the given classData is valid and can be used.
local function checkValidClassData(classData: defaultClassData, className: string)
	if nativeTypeof(classData) ~= "table" then logError("classDataNotTable", false, {className}) end
	if getmetatable(classData) or not select(1, pcall(setmetatable, classData, {})) then logError("classDataContainsMetatable", false, {className}) end

	local isAPropertyRedeclared: boolean, redeclaredIndex: any? = checkRedeclaration(classData)
	if isAPropertyRedeclared then logError("classPropertyRedeclaration", false, redeclaredIndex) end

	if findPropertyFromIndex(classData, "Destroy") then logError("invalidPropertyDecleration", false, {"Destroy"}) end
	if findPropertyFromIndex(classData, "super") then logError("invalidPropertyDecleration", false, {"super"}) end
	if checkOutsideAccessSpecifierDecleration(classData) then logError("invalidAccessSpecifierInClassData", false, {className}) end
end

-- Calls an operator function from the given name.
local function callOperator(functionName: string, obj: anyTable, obj2: anyTable?, silenceError: boolean?): boolean | any
	if nativeTypeof(obj) == "userdata" then
		local objFunction = obj[functionName] :: (...any) -> (any)
		if objFunction then
			return objFunction(obj, obj2)
		elseif not silenceError then
			logError("classNoMatchingFunctionError", true, {functionName})
		end
	elseif obj2 and nativeTypeof(obj2) == "userdata" then
		local objFunction = obj2[functionName] :: (...any) -> (any)
		if objFunction then
			return objFunction(obj2, obj)
		elseif not silenceError then
			logError("classNoMatchingFunctionError", true, {functionName})
		end
	end

	return false
end

-- Sets the metamethods of an object.
local function setMetamethods(class: internalClass, objectData: objectData, methods: anyTable)
	local Internal = objectData.Internal
	methods.__metatable = 'The metatable is locked.'

	function methods:__index(index: string)
		if Internal.__locked == true then logError("classObjectLocked", true) end

		local accessSpecifier, property = returnAccessSpecifier(index, objectData)
		local isOperatorCall = string.find(index, "operator")

		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not inClassScope(class, objectData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Protected" and not inClassScope(class, objectData, true, false) then
				logError("classPropertyIsProtected", true, {index})
			elseif accessSpecifier == "Internal" and getMethodContext(7) ~= type and getMethodContext(7) ~= typeof then
				logError("classPropertyIsInternal", true, {index})
			end
		end

		if isOperatorCall then
			local isFound = binarySearch(overloadableOperators, index)
			if isFound and getMethodContext(5) ~= callOperator then
				logError("nonNativeOperatorCall", true, {index})
			end
		end

		if property ~= nil then return property elseif index ~= "constructor" and index ~= "destructor" and index ~= "__tostring" and not isOperatorCall then logError("classMemberNotFound", true, {index}) end		
		return
	end

	function methods:__newindex(index: string, value: any)
		if Internal.__locked == true then logError("classObjectLocked", true) end
		if value == nil then logError("classMemberCannotSetToNil", true) end

		local accessSpecifier, property = returnAccessSpecifier(index, objectData)
		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not inClassScope(class, objectData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Protected" and not inClassScope(class, objectData, true, false) then
				logError("classPropertyIsProtected", true, {index})
			elseif accessSpecifier == "Internal" and getMethodContext(7) ~= type and getMethodContext(7) ~= typeof then
				logError("classPropertyIsInternal", true, {index})
			end
		end

		if property == nil then logError("classMemberNotFound", true, {index}) elseif property == value then return end
		objectData[accessSpecifier][index] = value
	end

	function methods:__tostring()
		if Internal.__locked == true then logError("classObjectLocked", true) end

		local result = callOperator("__tostring", self, nil, true)
		if result then
			return result
		else
			return class.Name
		end
	end

	for _, operatorFuncName in overloadableOperators do
		if not objectData.Public[operatorFuncName] then continue end
		methods[operatorMetamethodNames[operatorFuncName]] = function(obj, obj2)
			if Internal.__locked == true then logError("classObjectLocked", true) end
			return callOperator(operatorFuncName, obj, obj2)
		end
	end
end

local returnClassFunction: (className: string, ...any) -> any

local function createClassObject(newClassData: defaultClassData, className: string, inheritedClasses: {internalClass}?)
	local staticFunction = nil
	local overloadedFunctions: {(...any) -> (...any?)} = {}
	local class = ({
		Inherits = table.freeze(inheritedClasses or {}),
		Friends = table.freeze(newClassData.Friend or {}),
		Statics = setmetatable({}, {__tostring = function() return '{}' end, __newindex = function(t, i, v) local f = getMethodContext(5); if f ~= staticFunction then logError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v); return end, __metatable = {} }),
		Name = className
	} :: any) :: internalClass

	newClassData.Public = setmetatable(newClassData.Public or {}, {__newindex = function(t, i, v) 
		local previousAccessSpecifier = returnAccessSpecifier(i, newClassData)
		if previousAccessSpecifier then newClassData[previousAccessSpecifier][i] = nil end 
		rawset(t, i, v)
	end}) :: any

	newClassData.Private = setmetatable(newClassData.Private or {}, {__newindex = function(t, i, v) 
		local previousAccessSpecifier = returnAccessSpecifier(i, newClassData)
		if previousAccessSpecifier then newClassData[previousAccessSpecifier][i] = nil end 
		rawset(t, i, v)
	end}) :: any

	newClassData.Protected = setmetatable(newClassData.Protected or {}, {__newindex = function(t, i, v) 
		local previousAccessSpecifier = returnAccessSpecifier(i, newClassData)
		if previousAccessSpecifier then newClassData[previousAccessSpecifier][i] = nil end 
		rawset(t, i, v)
	end}) :: any

	--// Class Metatable

	local methods = {
		__type = "Class",
		__classtype = className,
		__abstract = false,
		__final = false
	}

	function methods.__index(t: internalClass, i: string): any
		local methodContext = getMethodContext(5)
		local isNotInClassScope = methodContext ~= inClassScope
		local isNotCheckFriendShip = methodContext ~= checkFriendship 

		if isNotInClassScope then
			if i == "__type" then return end
			if i == "__abstract" then 
				if classpp.abstract == methodContext or classpp.final == methodContext then
					return methods.__abstract
				end
			end
			if i == "__final" then 
				if classpp.final == methodContext or classpp.abstract == methodContext or returnClassFunction == methodContext then
					return methods.__final
				end
			end
			if i == "classData" then
				if returnClassFunction == methodContext or createClassObject == methodContext or sortAttributes == methodContext or recursiveFindParentFunction == methodContext then
					return newClassData
				else
					logError("classPropertyIsInternal", true, {"classData"})
				end
			end
		else
			if i == "overloadlist" then
				return overloadedFunctions
			end
		end

		local result = newClassData[i] or findPropertyFromIndex(newClassData, i)
		if not result then return class.Statics[i] end

		local resultType = nativeTypeof(result)
		if resultType == "function" and isNotInClassScope and isNotCheckFriendShip then 
			logError("cannotCallFunctionError", true, {i}) 
		elseif resultType == "table" then 
			local metatable = getmetatable(result :: any)
			if metatable["__call"] and isNotInClassScope then
				logError("cannotCallFunctionError", true, {i}) 
			end
		end

		return result
	end

	function methods.__newindex(t: internalClass, i: string, v: any)
		local methodContext = getMethodContext(5)

		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == methodContext and v == true then
				methods.__abstract = true
				class.new = function()
					logError("attemptToCreateObjectFromAbstractClass", true)
				end
				return
			end
		end
		if i == "__final" then
			if classpp.final == methodContext and v == true then 
				methods.__final = true 
				return
			end
		end

		if not checkValidAccessSpecifier(i) and i ~= "constructor" and i ~= "destructor" then
			logError("invalidClassNewIndex", true, {className})
		end

		newClassData[i] = v

		return v
	end

	--// Class Methods

	function class.new(...)
		local newObjData: objectData = sortAttributes(newClassData, className, class)
		local newObject = newproxy(true)
		local proxyMethods = getmetatable(newObject)

		if classpp.autoObjectDestruction then
			runOnGarbageCollection(newObject, function() 
				garbageCollectionCallback(newObjData)
				newObjData = nil :: any
			end)
		end

		setMetamethods(class, newObjData, proxyMethods)

		if newObjData.Internal.constructor then newObjData.Internal.constructor(newObject, ...) end
		return newObject
	end

	function class.extends()
		logError("extendsDeprecated", true)
	end

	function class.overload(accessSpecifier: string, name: string, functionTable: {(...any) -> (any)})
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" then logError("invalidAccessSpecifierError", true) end
		if not name then logError("overloadfunctionNameNotSet", true) end
		if nativeTypeof(functionTable) ~= "table" or #functionTable == 0 then logError("overloadfunctionTableNotGiven", true) end
		if not specifierName then return end

		for _, func in functionTable do
			if nativeTypeof(func) ~= "function" then logError("expectedFunctionError", true, {nativeTypeof(func)}) end
		end

		local function overloadHandler(...)
			if getMethodContext(4) == deepCopy then return end

			local args = {...}
			local f = false

			for _, func in functionTable do
				local argCount, isVariadic = debug.info(func, 'a')
				if argCount == #args or isVariadic then
					f = true
					return func(...)
				end
			end

			if not f and #args > 0 then logErrorNonFatal("overloadfunctionArgumentMismatch", false, {#args, name}) end
		end

		newClassData[specifierName][name] = overloadHandler
		table.insert(overloadedFunctions, overloadHandler)
	end

	function class.static(accessSpecifier: string, name: string, property: any)
		local accessSpecifierCheck, specifierName = checkValidAccessSpecifier(accessSpecifier)
		if not accessSpecifierCheck or specifierName and specifierName == "Internal" or specifierName and specifierName == "Protected" then logError("invalidAccessSpecifierError", true) end
		if not name then logError("staticMemberNameNotSet", true) end
		if not class.Statics then return end

		local newObj = newproxy(true)
		local methods = getmetatable(newObj)

		function methods:__index(): any
			if accessSpecifier == "Private" and not inClassScope(class, newClassData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {name})
			end

			return property
		end

		function methods:__newindex(index: any, value: any)
			if accessSpecifier == "Private" and not inClassScope(class, newClassData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {name})
			end

			property = value
			return property
		end

		function methods:__call(...)
			if accessSpecifier == "Private" and not inClassScope(class, newClassData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {name})
			end

			if nativeTypeof(property) == "function" then 
				return property(...) 
			else
				return property
			end
		end

		function methods:__tostring()
				if accessSpecifier == "Private" and not inClassScope(class, newClassData, false, true, classes) then
				logError("classPropertyIsPrivate", true, {name})
			end

			return tostring(property)
		end

		class.Statics[name] = newObj

		return newObj
	end

	staticFunction = class.static
	return setmetatable(class, methods)
end

local function constructClass(classDataArg: defaultClassData, className: string, otherClassDatas: {defaultClassData}?, otherClasses: {internalClass}?)
	checkValidClassData(classDataArg, className)

	local newClassData: defaultClassData = if not otherClassDatas then classDataArg else mergeClassDatas(otherClassDatas, classDataArg)
	local nCObj = createClassObject(newClassData, className, otherClasses)

	classes[className] = nCObj

	return nCObj
end

returnClassFunction = function(className: string, ...): any
	local argTable = {...}
	local count = #argTable
	local firstArg = argTable[1]

	if count >= 2 then
		local classDataTable: {defaultClassData} = {}
		local classTable: {internalClass} = {}

		for _, class: internalClass in argTable do
			if type(class) ~= "Class" then continue end
			if class["__final"] then logError("attemptToExtendAFinalClass", true) end
			if not class.classData then continue end

			table.insert(classDataTable, class.classData)
			table.insert(classTable, class)
		end

		return function(classDataArg: defaultClassData)
			return constructClass(classDataArg, className, classDataTable, classTable)
		end
	elseif count == 1 and type(firstArg) == "Class" then
		local class: internalClass = firstArg
		if class["__final"] then logError("attemptToExtendAFinalClass", true) end
		if not class.classData then return end

		local classDataTable: {defaultClassData} = {class.classData}
		local classTable: {internalClass} = {class}

		return function(classDataArg: defaultClassData)
			return constructClass(classDataArg, className, classDataTable, classTable)
		end
	else
		return constructClass(argTable[1], className)
	end
end

--// Module Functions

function classpp.class(className: string): any
	return function(...): any
		return returnClassFunction(className, ...)
	end
end

function classpp.abstract(classTable: {internalClass}): any
	if nativeTypeof(classTable) ~= "table" then logError("invalidModifierArgument", true) end

	for _, class in classTable do
		if type(class) ~= "Class" then logError("typeofObjectIsNotClass", false) end
		if class["__final"] then logError("illegalModifierCombination", true, {`abstract and final`}) end 

		class["__abstract"] = true
	end

	return classTable[1]
end

function classpp.final(classTable: {internalClass}): any
	if nativeTypeof(classTable) ~= "table" then logError("invalidModifierArgument", true) end

	for _, class in classTable do
		if type(class) ~= "Class" then logError("typeofObjectIsNotClass", false) end
		if class["__abstract"] then logError("illegalModifierCombination", true, {`final and abstract`}) end 

		class["__final"] = true
	end

	return classTable[1]
end

function classpp.getClass(className: string): any
	if nativeTypeof(className) ~= "string" then logError("classNameNotString", false) end
	if not classes[className] then logError("classNotFound", false) end
	return classes[className]
end

classpp.Type = Type
classpp.Util = Util

return classpp