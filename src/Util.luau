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

local ctypeof = Type.typeof

--////// Util Functions

function Util.getMethodContext(level: number): ((...any) -> (any), string)
	local _, f, n = pcall(function() 
		local f = debug.info(level, 'f')
		local n = debug.info(level, 'n')

		return f, n
	end)

	return f, n
end

function Util.checkInheritance(class: any, classOrMethod: any | () -> ()): boolean
	for inherited, _ in class.Inherits do
		if typeof(classOrMethod) == "table" and inherited == classOrMethod or inherited[classOrMethod] then
			return true
		end
	end

	return false
end

function Util.checkFriendship(class: any, methodName: string, method: (any) -> (any), classes: {[string]: any}): boolean
	for friend, _ in class.Friends do
		if ctypeof(friend) == "Class" and friend[methodName] then
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

function Util.inClassScope(class: any, includeInherited: boolean, includeFriend: boolean, classes: {[string]: any}?): boolean
	if not classes then return false end
	
	local level: number = 4
	
	while true do
		level += 1
				
		local method, methodName = Util.getMethodContext(level)
		if not method then break end
		
		if method == Type.typeof then return true end
		
		if class[methodName] == method then
			return true
		end
		
		local result = if includeInherited then Util.checkInheritance(class, method) else false or if includeFriend then Util.checkFriendship(class, methodName, method, classes) else false
		if result then return true end
	end

	return false
end

return Util