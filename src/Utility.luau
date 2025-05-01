--!native
--!strict

--[[
	Written by @TenebrisNoctua.
	Utilities for Class++.
--]]

--// Variables

local Util = {}
local Type = require('./Type')

--// Types

type internalClass = Type.internalClass

--// Module Functions

function Util.getMethodContext(level: number): ((any) -> (any), string)
	local _, f, n = pcall(function() 
		local f = debug.info(level, 'f') 
		local n = debug.info(level, 'n')

		return f, n
	end)

	return f, n
end

function Util.checkInheritance(class: internalClass, classOrMethod: any | () -> ()): boolean
	for _, inherited in class.Inherits do
		if inherited == classOrMethod or inherited[classOrMethod] then
			return true
		end
	end

	return false
end

function Util.checkFriendship(class: internalClass, methodName: string, method: (any) -> (any), classes: {[string]: internalClass}): boolean
	for _, friend in class.Friends do
		if Type.type(friend) == "Class" and friend[methodName] then
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

function Util.inClassScope(class: internalClass, includeInherited: boolean, includeFriend: boolean, classes: {[string]: internalClass}?, defaultLevel: number?): boolean
	local level: number = defaultLevel or 6
	
	while true do
		local method, methodName = Util.getMethodContext(level)
		if not method then return false end

		if class[methodName] == method then return true end

		local result = if includeInherited then Util.checkInheritance(class, method) else false or if includeFriend and classes then Util.checkFriendship(class, methodName, method, classes) else false
		if result then return true end
		
		if method == Type.typeof then return true end
		if methodName == "overloadHandler" and table.find(class.overloadlist, method) then return true end
		
		level += 1
	end

	return false
end

function Util.binarySearch(array: {any}, value: any): any
	local Low: number = 1
	local High: number = #array
	
	while Low <= High do
		local Middle: number = Low + math.floor((High - Low) / 2)
		local MiddleValue: number = array[Middle]
		
		if value < MiddleValue then
			High = Middle - 1
		elseif MiddleValue < value then
			Low = Middle + 1
		else
			while Middle >= 1 and not (array[Middle] < value or value < array[Middle]) do
				Middle -= 1
			end
			return Middle + 1
		end
	end
	return
end

return Util