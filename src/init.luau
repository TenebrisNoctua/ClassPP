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

local Util = require("@self/Utility")
local Logger = require("@self/Log/Logger")
local Type = require("@self/Type")

local LogError = Logger.logError
local LogErrorNonFatal = Logger.logErrorNonFatal
local LogWarn = Logger.logWarn

local classes = {} :: {[string]: internalClass}
local classpp = {version = {major = 0, minor = 5, patch = 0, beta = true}, autoObjectDestruction = true} :: classPP

local accessSpecifiers: accessSpecifiers = {"Friend", "Internal", "Private", "Protected", "Public"}
local overloadableOperators: overloadableOperators = {"operator_add", "operator_div", "operator_eq", "operator_idiv", "operator_mod", "operator_mul", "operator_pow", "operator_sub", "operator_unm"}

--// Types

type classPP = Type.classPP<typeof(Util), typeof(Type)>
type accessSpecifiers = Type.accessSpecifiers
type overloadableOperators = Type.overloadableOperators

export type classData<T> = Type.classData<T>
export type class<T> = Type.class<T, T>

type defaultClassData = Type.defaultClassData
type objectData = Type.objectData
type internalClass = Type.internalClass

type anyTable = Type.anyTable
type deepAnyTable = Type.deepAnyTable
type metatable<T, V = any?> = setmetatable<{T}, {V}>

--// Local Functions

-- A deep copy function for tables, with support for metatables.
local function deepCopy<T>(original: T, copyMetatable: boolean?): T 
	local original: anyTable = original
	local copy = table.clone(original)
	
	for key, value in original do
		if type(value) ~= "table" then continue end
		local metatable = getmetatable(value :: any) 
		
		if not metatable then 
			copy[key] = deepCopy(value, true) 
		elseif not copyMetatable then 
			local success, result = pcall(setmetatable, value, {})
			local copyTable
			
			if success then 
				copyTable = result
			else
				copyTable = {}
				for key, val in value do
					copyTable[key] = val
				end
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
		local keyType = typeof(key)
		local valueType = typeof(value)
		
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
			if not success then LogErrorNonFatal("unhandledError", true, {"destructor", err}) end
			
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
			LogError("invalidConstructor", true, {Type.typeof(obj)})
		end
	else
		if inheritedClass and inheritedClass.classData then
			local inheritedClassData = inheritedClass.classData
			local foundPublic: (...any) -> (any?) = inheritedClassData.Public[methodName]
			local foundProtected: (...any) -> (any?) = inheritedClassData.Protected[methodName]
			
			if foundPublic and typeof(foundPublic) == "function" and class.classData.Public[methodName] == method then 
				return foundPublic(obj, ...) 
			elseif foundProtected and typeof(foundProtected) == "function" and (class.classData.Protected[methodName] == method or class.classData.Public[methodName] == method) then
				return foundProtected(obj, ...)
			else
				return recursiveFindParentFunction(obj, method, inheritedClass, "function", methodName, ...)
			end
		else
			LogError("cannotFindBaseClassMethod", true, {methodName, class.Name})
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
	local classType = Type.typeof(class)
	local destructor = objectTbl.Internal.destructor
	
	function objectTbl.Public.Destroy(obj: objectData)
		local objectType = Type.type(obj)
		local objectClassType = Type.typeof(obj)
		
		if objectType ~= "Object" then LogError("invalidDestructorCall", true) end
		if objectClassType ~= classType then LogError("classTypeMismatch", true, {objectType, classType}) end
		if Util.getMethodContext(5) == objectTbl.Internal.constructor then LogError("cannotCallFunctionFrom", true, {"Destroy", "constructor"}) end
		
		if destructor then 
			local success, err = pcall(destructor, obj)
			if not success then LogErrorNonFatal("unhandledError", true, {"destructor", err}) end
		end
		
		objectCleaner(objectTbl)
	end
	
	function objectTbl.Public.super(obj: objectData, ...)
		local objectType = Type.type(obj)
		local objectClassType = Type.typeof(obj)
		
		if objectType ~= "Object" then LogError("invalidSuperCall", true) end
		if objectClassType ~= classType then LogError("classTypeMismatch", true, {objectType, classType}) end
		if inheritedClassNum > 1 or not inheritedClass then LogError("invalidInheritation", true) end
		if not inheritedClassData then return end
		
		local method, currentMethod = Util.getMethodContext(5)
		if method == destructor then LogError("cannotCallFunctionFrom", true, {"super", currentMethod}) end
		
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

-- Returns the access specifier of an index.
local function returnAccessSpecifier(index: string, objectData: defaultClassData | objectData): string?
	if objectData.Public and objectData.Public[index] ~= nil then return "Public" end
	if objectData.Private and objectData.Private[index] ~= nil then return "Private" end
	if objectData.Protected and objectData.Protected[index] ~= nil then return "Protected" end
	if objectData.Internal and (objectData.Internal :: any)[index] ~= nil then return "Internal" end
	
	return nil
end

-- Finds the property that's been set to the given index. If given an access specifier string, it will try to find the property inside that access specifier.
local function findPropertyFromIndex(classData: defaultClassData | objectData, index: string, accessSpecifier: string?): any?
	local fAccessSpecifier = accessSpecifier or returnAccessSpecifier(index, classData)
	if not fAccessSpecifier then return end
	
	local attributesData = classData[fAccessSpecifier]
	return attributesData[index]
end

-- Checks if the given string is a valid access specifier.
local function checkValidAccessSpecifier(specifierString: string): (boolean, string?)
	local isFound = Util.binarySearch(accessSpecifiers, specifierString)
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
	for index, _ in classData do
		if typeof(index) ~= "string" then return true end
		if not checkValidAccessSpecifier(index) and index ~= "constructor" and index ~= "destructor" then return true end
	end

	return false
end

-- Checks if the given classData is valid and can be used.
local function checkValidClassData(classData: defaultClassData, className: string)
	if typeof(classData) ~= "table" then LogError("classDataNotTable", false, {className}) end
	if getmetatable(classData) or not select(1, pcall(setmetatable, classData, {})) then LogError("classDataContainsMetatable", false, {className}) end

	local isAPropertyRedeclared: boolean, redeclaredIndex: any? = checkRedeclaration(classData)
	if isAPropertyRedeclared then LogError("classPropertyRedeclaration", false, redeclaredIndex) end

	if findPropertyFromIndex(classData, "Destroy") then LogError("invalidPropertyDecleration", false, {"Destroy"}) end
	if findPropertyFromIndex(classData, "super") then LogError("invalidPropertyDecleration", false, {"super"}) end
	if checkOutsideAccessSpecifierDecleration(classData) then LogError("invalidAccessSpecifierInClassData", false, {className}) end
end

-- Calls an operator function from the given name.
local function callOperator(functionName: string, obj: anyTable, obj2: anyTable?, silenceError: boolean?): boolean | any
	if typeof(obj) == "userdata" then
		local objFunction = obj[functionName]
		if objFunction then
			return objFunction(obj, obj2)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, {functionName})
		end
	elseif typeof(obj2) == "userdata" then
		local objFunction = obj2[functionName]
		if objFunction then
			return objFunction(obj2, obj)
		elseif not silenceError then
			LogError("classNoMatchingFunctionError", true, {functionName})
		end
	end

	return false
end

-- Sets the metamethods of an object.
local function setMetamethods(class: internalClass, objectData: objectData, methods: anyTable)
	local Internal = objectData.Internal
	methods.__metatable = 'The metatable is locked.'
	
	function methods:__index(index: string)
		if Internal.__locked == true then LogError("classObjectLocked", true) end

		local accessSpecifier = returnAccessSpecifier(index, objectData)
		local rprop = findPropertyFromIndex(objectData, index, accessSpecifier)
		local isOperatorCall = string.find(index, "operator")
		
		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, true, false) then
				LogError("classPropertyIsProtected", true, {index})
			elseif accessSpecifier == "Internal" and Util.getMethodContext(7) ~= Type.type and Util.getMethodContext(7) ~= Type.typeof then
				LogError("classPropertyIsInternal", true, {index})
			end
		end
		
		if isOperatorCall then
			local isFound = Util.binarySearch(overloadableOperators, index)
			if isFound and Util.getMethodContext(5) ~= callOperator then
				LogError("nonNativeOperatorCall", true, {index})
			end
		end
		
		if rprop ~= nil then return rprop elseif index ~= "constructor" and index ~= "destructor" and index ~= "__tostring" and not isOperatorCall then LogError("classMemberNotFound", true, {index}) end		
		return
	end

	function methods:__newindex(index: string, value: any)
		if Internal.__locked == true then LogError("classObjectLocked", true) end
		if value == nil then LogError("classMemberCannotSetToNil", true) end

		local accessSpecifier = returnAccessSpecifier(index, objectData)
		if accessSpecifier ~= "Public" then
			if accessSpecifier == "Private" and not Util.inClassScope(class, false, true, classes) then
				LogError("classPropertyIsPrivate", true, {index})
			elseif accessSpecifier == "Internal" then
				LogError("classPropertyIsInternal", true, {index})
			elseif accessSpecifier == "Protected" and not Util.inClassScope(class, false, false) then
				LogError("classPropertyIsProtected", true, {index})
			end
		end
		
		local attributesData = objectData[accessSpecifier]
		local foundAttribute = attributesData[index]
		if foundAttribute == nil then LogError("classMemberNotFound", true, {index}) elseif foundAttribute == value then return end
		
		attributesData[index] = value
	end

	function methods:__tostring()
		if Internal.__locked == true then LogError("classObjectLocked", true) end

		local result = callOperator("__tostring", self, nil, true)
		if result then
			return result
		else
			return class.Name
		end
	end

	for _, operatorFuncName in overloadableOperators do
		if not objectData.Public[operatorFuncName] then continue end

		methods[string.gsub(operatorFuncName, "operator", "_")] = function(obj, obj2)
			if Internal.__locked == true then LogError("classObjectLocked", true) end
			return callOperator(operatorFuncName, obj, obj2)
		end
	end
end

local returnClassFunction: (className: string, ...any) -> any

local function createClassObject(newClassData: defaultClassData, className: string, inheritedClasses: {internalClass}?)
	local staticFunction = nil
	local overloadedFunctions: {(...any) -> (...any?)} = {}
	local class: internalClass = {
		Inherits = setmetatable(inheritedClasses or {}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= createClassObject then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end, __metatable = {} }),
		Friends = setmetatable(newClassData.Friend or {}, { __tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= createClassObject then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end, __metatable = {} }),
		Statics = setmetatable({}, {__tostring = function() return '{}' end, __newindex = function(t, i, v) local f = Util.getMethodContext(5); if f ~= staticFunction then LogError("attemptToModifyReadOnlyTable", false) end; rawset(t, i, v) end, __metatable = {} }),
		Name = className,
		new = function() end,
		overload = function() end,
		static = function() end
	}
	
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
		local methodContext = Util.getMethodContext(5)
		local isNotInClassScope = methodContext ~= Util.inClassScope
		local isNotCheckFriendShip = methodContext ~= Util.checkFriendship 
		
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
					LogError("classPropertyIsInternal", true, {"classData"})
				end
			end
		else
			if i == "overloadlist" then
				return overloadedFunctions
			end
		end

		local result = newClassData[i] or findPropertyFromIndex(newClassData, i)
		if not result then return class.Statics[i] end
		
		local resultType = typeof(result)
		if resultType == "function" and isNotInClassScope and isNotCheckFriendShip then 
			LogError("cannotCallFunctionError", true, {i}) 
		elseif resultType == "table" then 
			local metatable = getmetatable(result :: any)
			if metatable["__call"] and isNotInClassScope then
				LogError("cannotCallFunctionError", true, {i}) 
			end
		end

		return result
	end

	function methods.__newindex(t: internalClass, i: string, v: any)
		local methodContext = Util.getMethodContext(5)
		
		if i == "__type" then return end
		if i == "__abstract" then 
			if classpp.abstract == methodContext and v == true then
				methods.__abstract = true
				class.new = function()
					LogError("attemptToCreateObjectFromAbstractClass", true)
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
			LogError("invalidClassNewIndex", true, {className})
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
			if Type.type(class) ~= "Class" then continue end
			if class["__final"] then LogError("attemptToExtendAFinalClass", true) end

			table.insert(classDataTable, class.classData)
			table.insert(classTable, class)
		end

		return function(classDataArg: defaultClassData)
			return constructClass(classDataArg, className, classDataTable, classTable)
		end
	elseif count == 1 and Type.type(firstArg) == "Class" then
		local class: internalClass = firstArg
		if class["__final"] then LogError("attemptToExtendAFinalClass", true) end
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
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class in classTable do
		if Type.type(class) ~= "Class" then LogError("typeofObjectIsNotClass", false) end
		if class["__final"] then LogError("illegalModifierCombination", true, {`abstract and final`}) end 

		class["__abstract"] = true
	end

	return classTable[1]
end

function classpp.final(classTable: {internalClass}): any
	if typeof(classTable) ~= "table" then LogError("invalidModifierArgument", true) end

	for _, class in classTable do
		if Type.type(class) ~= "Class" then LogError("typeofObjectIsNotClass", false) end
		if class["__abstract"] then LogError("illegalModifierCombination", true, {`final and abstract`}) end 

		class["__final"] = true
	end

	return classTable[1]
end

function classpp.getClass(className: string): any
	if typeof(className) ~= "string" then LogError("classNameNotString", false) end
	if not classes[className] then LogError("classNotFound", false) end
	return classes[className]
end

classpp.Type = Type
classpp.Util = Util

return classpp