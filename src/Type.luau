--!native
--!strict

--[[
	Written by @TenebrisNoctua.
	Types for Class++ classes and objects.
--]]

--// Variables

local Logger = require('./Log/Logger')
local LogError = Logger.logError

local Type = {}

--// Types and Type Functions

export type version = {
	major: number,
	minor: number,
	patch: number,
	beta: boolean
}

export type classPP<Utility, Type> = {
	version: version,
	autoObjectDestruction: boolean,
	Util: Utility,
	Type: Type,
	class: (className: string) -> (ovloadFT) & (ovloadST),
	getClass: (className: string) -> classShort<defaultClassData>,
	abstract: <T>(arg: {T}, ...any) -> T,
	final: <T>(arg: {T}, ...any) -> T,
}

export type accessSpecifiers = {
	"Public" | "Private" | "Protected" | "Friend" | "Static" | "Internal"
}

export type overloadableOperators = {
	"operator_add" | "operator_sub" | "operator_mul" | "operator_div" | "operator_idiv" |
	"operator_mod" | "operator_pow" | "operator_unm" | "operator_eq"
}

export type class<classData, nClassData> = setmetatable<{
	new: getConstructorType<classData, convertToObjectData<classData>>,
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (...any?)}) -> (),
	static: (accessSpecifier: string, name: string, property: any) -> (),
	read classData: nClassData,
	read Name: string
}, {
	__index: ({any}, any) -> (any),
	__newindex: ({any}, any, any) -> (),
	__type: string,
	__classtype: string,
	__abstract: boolean,
	__final: boolean
}>

export type internalClass = {
	new: (...any) -> (),
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (...any?)}) -> (),
	static: (accessSpecifier: string, name: string, property: any) -> (),
	Inherits: readOnlyTable,
	Friends: readOnlyTable,
	Statics: readOnlyTable,
	classData: defaultClassData?,
	Name: string,
	[any]: any
}

export type objectData = {
	Public: anyTable,
	Private: anyTable,
	Protected: anyTable,
	Internal: {
		__type: string?,
		__locked: boolean?,
		constructor: (any, ...any) -> ()?,
		destructor: (any) -> ()?,
	},
	[any]: any
}

export type anyTable = {[any]: any}
export type deepAnyTable = {[any]: anyTable}
export type readOnlyTable = setmetatable<anyTable, {__newindex: (...any) -> any, __metatable: {}, __tostring: () -> any}>

export type ovloadFT = <T>(arg1: T) -> classShort<classData<T>>
export type ovloadST = <T1, T2>(arg1: T1, arg2: T2, ...any) -> <T>(classDataArg: T) -> classShort<combineClassData<T, T1, T2>>

export type classData<T> = constructClassData<T>
export type defaultClassData = classData<{Public: {}, Private: {}, Protected: {}, Friend: {[any]: any}, constructor: (...any) -> (), destructor: (any) -> ()}>

type classShort<T> = class<T, T>

type function isClass(t: type)
	if not t:is("table") then return false end

	local classArgCheck = {
		new = "function",
		overload = "function",
		static = "function",
		classData = "table",
		Name = "string"
	}

	local properties = t:properties()
	local passedCount = 0

	for k, v in properties do
		local key = k:value()
		local value = v.read
		if not value then return false end

		local argValue = classArgCheck[key]
		if not argValue or argValue ~= value.tag then return false end

		passedCount += 1
	end

	return passedCount > 0
end

export type function getConstructorType(classData: type, objectData: type)
	local properties = classData:properties()
	local constructorParams

	for k, v in properties do
		local key = k:value()
		local value = v.read

		if key == "constructor" and value then
			constructorParams = value:parameters()
		end
	end

	local newHead: {type} = {}
	local allowedTags = {"string", "any", "singleton", "boolean", "number", "class", "buffer", "nil", "table", "function", "union"}

	if constructorParams and constructorParams.head then
		for i, type in constructorParams.head do
			if i == 1 then continue end
			if not table.find(allowedTags, type.tag) then
				table.insert(newHead, types.any)
			else
				table.insert(newHead, type)
			end
		end
	end

	return types.newfunction({head = newHead, tail = types.any}, {head = {objectData}})
end

export type function constructClassData(tbl: type)
	if not tbl:is("table") then error("Given argument is not a table.") end

	local foundConstructorType = tbl:readproperty(types.singleton("constructor"))
	local constructorType = if foundConstructorType and foundConstructorType:is("function") then foundConstructorType else types.newfunction({ head = {} }, {}, {})

	local foundDestructorType = tbl:readproperty(types.singleton("destructor"))
	local destructorType = if foundDestructorType and foundDestructorType:is("function") then foundDestructorType else types.newfunction({ head = {} }, {}, {})

	local nT = types.newtable({
		[types.singleton("constructor")] = constructorType,
		[types.singleton("destructor")] = destructorType,
		[types.singleton("Public")] = types.newtable({}),
		[types.singleton("Private")] = types.newtable({}),
		[types.singleton("Protected")] = types.newtable({}),
		[types.singleton("Friend")] = types.newtable({})
	})

	nT:setindexer(types.string, types.any)

	for k: type, v in tbl:properties() do
		local key = k:value()
		local value = v.read

		if value and value:is("function") then
			if key ~= "constructor" and key ~= "destructor" then continue end
			nT:setproperty(types.singleton(key), value)
		elseif value and value:is("table") then
			if key ~= "Public" and key ~= "Private" and key ~= "Protected" and key ~= "Friend" then continue end
			nT:setproperty(types.singleton(key), value)
			value:setindexer(types.any, types.any)
		end
	end

	return nT
end

-- This is pretty ugly because variadics don't exist at the time of writing this. 
-- If this is accepted: https://github.com/luau-lang/rfcs/pull/117, it will be updated.
export type function combineClassData(nt: type, t1: type, t2: type)
	if not isClass(t1) then error("Argument t1 must be a table.") end

	-- Create new empty classData
	local newClassData = types.newtable({
		[types.singleton("Public")] = types.newtable({}),
		[types.singleton("Protected")] = types.newtable({}),
		[types.singleton("Private")] = types.newtable({})
	})

	-- Define the merge local function
	local function merge(classData: type, finalize: boolean?)
		local PublicAccessSpecifier = classData:readproperty(types.singleton("Public"))
		local ProtectedAccessSpecifier = classData:readproperty(types.singleton("Protected"))
		local PrivateAccessSpecifier = if finalize then classData:readproperty(types.singleton("Private")) else nil
		local constructor = if finalize then classData:readproperty(types.singleton("constructor")) else nil

		if PublicAccessSpecifier and PublicAccessSpecifier:is("table") then
			local PublicTable = newClassData:readproperty(types.singleton("Public"))
			if not PublicTable then error("Unknown error occured.") end

			for k, v in PublicAccessSpecifier:properties() do
				local key = k:value()
				local value = v.read

				PublicTable:setproperty(types.singleton(key), value)
			end

			newClassData:setproperty(types.singleton("Public"), PublicTable)
		end

		if ProtectedAccessSpecifier and ProtectedAccessSpecifier:is("table") then
			local ProtectedTable = newClassData:readproperty(types.singleton("Protected"))
			if not ProtectedTable then error("Unknown error occured.") end

			for k, v in ProtectedAccessSpecifier:properties() do
				local key = k:value()
				local value = v.read

				ProtectedTable:setproperty(types.singleton(key), value)
			end

			newClassData:setproperty(types.singleton("Protected"), ProtectedTable)
		end

		if finalize then
			if PrivateAccessSpecifier and PrivateAccessSpecifier:is("table") then
				local PrivateTable = newClassData:readproperty(types.singleton("Private"))
				if not PrivateTable then error("Unknown error occured.") end

				for k, v in PrivateAccessSpecifier:properties() do
					local key = k:value()
					local value = v.read

					PrivateTable:setproperty(types.singleton(key), value)
				end

				newClassData:setproperty(types.singleton("Private"), PrivateTable)
			end

			if constructor and constructor:is("function") then
				newClassData:setproperty(types.singleton("constructor"), constructor)
			end
		end
	end

	-- Get classDatas and merge

	local t1ClassData = t1:readproperty(types.singleton("classData"))
	if not t1ClassData then error("classData type for argument t1 cannot be found.") end

	if isClass(t2) then
		local t2ClassData = t2:readproperty(types.singleton("classData"))
		if not t2ClassData then error("classData type for argument t2 cannot be found.") end

		merge(t2ClassData)
	end

	merge(t1ClassData)
	merge(nt, true)

	return newClassData
end

export type function convertToObjectData(t: type)
	if not t:is("table") then error("Given argument is not a table.") end

	local nT = types.newtable()
	nT:setindexer(types.any, types.any)

	for k: type, v in t:properties() do
		local key = k:value()
		local value = v.read
		if not value then continue end

		if key == "Public" and value:is("table") then
			for k: type, v in value:properties() do
				local key = k:value()
				local value = v.read
				if not value then continue end
				
				if value:is("function") then
					local params = value:parameters()
					local head = params.head or {}
					head[1] = nT
					
					value:setparameters(head, types.any)
				elseif value:is("boolean") then
					nT:setproperty(types.singleton(key), types.any)
					continue
				end
				
				nT:setproperty(types.singleton(key), value)
			end
		end

		if key == "Private" and value:is("table") then
			for k: type, v in value:properties() do
				local key = k:value()
				local value = v.read
				if not value then continue end

				if value:is("function") then
					local params = value:parameters()
					local head = params.head or {}
					head[1] = nT
					
					value:setparameters(head, types.any)
				elseif value:is("boolean") then
					nT:setproperty(types.singleton(key), types.any)
					continue
				end

				nT:setproperty(types.singleton(key), value)
			end
		end

		if key == "Protected" and value:is("table") then
			for k: type, v in value:properties() do
				local key = k:value()
				local value = v.read
				if not value then continue end

				if value:is("function") then
					local params = value:parameters()
					local head = params.head or {}
					head[1] = nT
					
					value:setparameters(head, types.any)
				elseif value:is("boolean") then
					nT:setproperty(types.singleton(key), types.any)
					continue
				end

				nT:setproperty(types.singleton(key), value)
			end
		end
	end

	nT:setproperty(types.singleton("super"), types.newfunction({head = {nT}, tail = types.any}, {head = {types.any}}))
	nT:setproperty(types.singleton("Destroy"), types.newfunction({head = {nT}, tail = types.any}, {head = {types.any}}))

	return nT
end

export type function object(t: type)
	if not t:is("table") then error("First argument is not compatible.") end
	
	local classDataProperty = t:readproperty(types.singleton("classData"))
	if not classDataProperty or not classDataProperty:is("table") then error("Given type is not a compatible class type.") end
	
	return convertToObjectData(classDataProperty)
end

--// Module Functions

--[[
	Returns the basic type of the provided object, with support for custom class types.
]]
function Type.type<T>(object: T): string
	local objType = type(object)

	if not objType then LogError("typeofObjectNotFound", false) end
	if objType ~= "table" and objType ~= "userdata" then return objType end

	local metatable = getmetatable(object) :: setmetatable<anyTable, anyTable>
	if not metatable then return objType end

	if metatable["__type"] then return metatable["__type"] end

	if objType == "userdata" then 
		local _, rType = select(1, pcall(function() return (object :: anyTable)["__type"] end))
		if rType then return rType end
	end 

	return objType
end

--[[
	Returns the type of the provided object, with support for custom class types.
]]
function Type.typeof<T>(object: T): string
	local objType = typeof(object)
	if not objType then LogError("typeofObjectNotFound", false) end

	if Type.type(object) == "Class" then
		local metatable = getmetatable(object) :: setmetatable<anyTable, anyTable>
		if not metatable["__classtype"] then return objType end 

		return metatable["__classtype"]
	elseif Type.type(object) == "Object" then
		local _, rType = select(1, pcall(function() return (object :: anyTable)["__objtype"] end))
		if rType then return rType end
	end

	return objType
end

return Type