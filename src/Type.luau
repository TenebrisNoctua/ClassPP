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

--////// Local Functions

--////// Module Functions

function Type.typeof(object: any): string?
	if typeof(object) ~= "table" and typeof(object) ~= "userdata" then return typeof(object) end
	
	local metatable = getmetatable(object)
	if not metatable then LogError("typeofMetatableError") end
	if metatable["__type"] then return metatable["__type"] end
	
	if typeof(object) == "userdata" then 
		local _, rType = select(1, pcall(function() return object.__type end))
		if rType then return rType end
	end 
	
	return LogError("typeofObjectNotFound")
end

function Type.typeofClass(classObj: any): string?
	if Type.typeof(classObj) ~= "Class" then LogError("typeofObjectIsNotClass") end
	
	local metatable = getmetatable(classObj)
	if metatable["__classtype"] then return metatable["__classtype"] end
	
	return LogError("typeofObjectNotFound")
end

return Type
