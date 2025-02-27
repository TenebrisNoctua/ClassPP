--!native
--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		Utilities for Class++.
	////
--]]

local Util = {}
local Type = require(script.Parent.Type)

--////// Types

type class = Type.class

--////// Util Functions

function Util.getMethodContext(level: number): ((...any) -> (any), string)
	local _, f, n = pcall(function() 
		local f = debug.info(level, 'f')
		local n = debug.info(level, 'n')

		return f, n
	end)

	return f, n
end

function Util.checkInheritance(class: class, classOrMethod: any | () -> ()): boolean
	for _, inherited in class.Inherits do
		if typeof(classOrMethod) == "table" and inherited == classOrMethod or inherited[classOrMethod] then
			return true
		end
	end

	return false
end

function Util.checkFriendship(class: class, methodName: string, method: (any) -> (any), classes: {[string]: any}): boolean
	for _, friend in class.Friends do
		if Type.typeof(friend) == "Class" and friend[methodName] then
			return true
		elseif typeof(friend) == "string" then
			if classes[friend] and classes[friend][methodName] then
				return true
			end
		elseif typeof(friend) == "function" and friend == method then
			return true
		end
	end

	return false
end

function Util.inClassScope(class: class, includeInherited: boolean, includeFriend: boolean, classes: {[string]: any}?, defaultLevel: number?): boolean
	local level: number = defaultLevel or 6
	
	while true do
		local method, methodName = Util.getMethodContext(level)
		if not method then return false end

		if class[methodName] == method then return true end
		if not methodName and table.find(class["__ovfunc"], method) then return true end

		local result = if includeInherited then Util.checkInheritance(class, method) else false or if includeFriend and classes then Util.checkFriendship(class, methodName, method, classes) else false
		if result then return true end
		
		if method == Type.typeof then return true end
		
		level += 1
	end

	return false
end

return Util