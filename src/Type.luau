--!native
--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		Custom type system for Class++ classes and objects.
	////
--]]

--////// Variables

local Type = {}
local LogError = require(script.Parent.Error).logError

--////// Types

export type classData = {
	constructor: (self: any, ...any) -> ()?,
	destructor: (self: any) -> ()?,
	Public: {[any]: any}?,
	Private: {[any]: any}?,
	Protected: {[any]: any}?,
	Friend: {any}?
}

export type class<AccessSpecifier = any?> = typeof(setmetatable({} :: {
	new: (...any) -> AccessSpecifier,
	extends: (className: string) -> (classData: classData) -> class<AccessSpecifier>,
	overload: (accessSpecifier: string, name: string, functionTable: {(...any) -> (any)}) -> (),
	static: (accessSpecifier: string, name: string, property: any) -> (),
	Name: string
}, {
	__index = function(t, i) return end :: ({any}, any) -> (any),
	__newindex = function(t, i, v) end :: ({any}, any, any) -> (),
	__type = "",
	__classtype = "",
	__abstract = false,
	__final = false
}))

--////// Module Functions

function Type.typeof(object: any): string?
	local objType = typeof(object)
	if objType ~= "table" and objType ~= "userdata" then return objType end
	
	local metatable = getmetatable(object)
	if not metatable then LogError("typeofMetatableError") end
	if metatable["__type"] then return metatable["__type"] end
	
	if objType == "userdata" then 
		local _, rType = select(1, pcall(function() return object.__type end))
		if rType then return rType end
	end 
	
	return LogError("typeofObjectNotFound")
end

function Type.typeofClass(classObj: class): string?
	if Type.typeof(classObj) ~= "Class" then LogError("typeofObjectIsNotClass") end
	
	local metatable = getmetatable(classObj)
	if metatable["__classtype"] then return metatable["__classtype"] end
	
	return LogError("typeofObjectNotFound")
end

return Type
