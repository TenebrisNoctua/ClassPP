--!native
--!strict

--[[
	Written by @TenebrisNoctua.
	Utilities for Class++.
--]]

--// Variables


const Type = require('./Type')

const type = Type.type
const typeof = Type.typeof

--// Types

type internalClass = Type.internalClass
type objectData = Type.objectData
type defaultClassData = Type.defaultClassData

--// Local Functions

-- Returns the access specifier of an index.
local function returnAccessSpecifier(index: string, objectData: defaultClassData | objectData): (string?, any?)
	if objectData.Public then
		local value = objectData.Public[index]
		if value ~= nil then return "Public", value end
	end

	if objectData.Private then
		local value = objectData.Private[index]
		if value ~= nil then return "Private", value end
	end

	if objectData.Protected then
		local value = objectData.Protected[index]
		if value ~= nil then return "Protected", value end
	end

	if objectData.Internal then
		local value = objectData.Internal[index]
		if value ~= nil then return "Internal", value end
	end
	return nil
end

-- Finds the property that's been set to the given index. If given an access specifier string, it will try to find the property inside that access specifier.
local function findPropertyFromIndex(classData: defaultClassData | objectData, index: string, accessSpecifier: string?): any?
	local fAccessSpecifier = accessSpecifier or returnAccessSpecifier(index, classData)
	if not fAccessSpecifier then return end

	local attributesData = classData[fAccessSpecifier]
	return attributesData[index]
end

-- Retrieves information about the current thread context.
local function getMethodContext(level: number): ((any) -> (any), string)
	local f: (any) -> (any)
	local n: string

	pcall(function() 
		f = debug.info(level, 'f') 
		n = debug.info(level, 'n')
	end)

	return f, n
end

-- Checks whether or not classOrMethod inherits from the class.
local function checkInheritance(class: internalClass, classOrMethod: internalClass | (any) -> (any)): boolean
	for _, inherited: internalClass in class.Inherits do
		if inherited == classOrMethod or inherited[classOrMethod] then
			return true
		end
	end
	return false
end

-- Checks if the method or class has been set as a friend of the target class.
local function checkFriendship(class: internalClass, methodName: string, method: (any) -> (any), classes: {[string]: internalClass}): boolean
	for _, friend in class.Friends do
		if type(friend) == "Class" and friend[methodName] then
			return true
		elseif typeof(friend) == "string" then
			if classes[friend] and classes[friend][methodName] then
				return true
			else
				continue
			end
		elseif typeof(friend) == "function" and friend == method then
			return true
		end
	end

	return false
end

-- Checks if the current thread can access certain class properties.
local function inClassScope(class: internalClass, objectData: objectData, overloadedFunctions: {(...any) -> (...any?)}, includeInherited: boolean, includeFriend: boolean, classes: {[string]: internalClass}?, defaultLevel: number?): boolean
	local level: number = defaultLevel or 5
	
	while true do
		local method, methodName = getMethodContext(level)
		if not method then return false end

		if findPropertyFromIndex(objectData, methodName) == method then return true end
		if includeInherited and checkInheritance(class, method) or includeFriend and classes and checkFriendship(class, methodName, method, classes) then return true end
		if method == typeof or methodName == "overloadHandler" and table.find(overloadedFunctions, method) then return true end

		level += 1
	end

	return false
end

-- Does a binary search within the given array to find the value.
local function binarySearch(array: {any}, value: any): any
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

--// Return Utility

return table.freeze({
	returnAccessSpecifier = returnAccessSpecifier,
	findPropertyFromIndex = findPropertyFromIndex,
	getMethodContext = getMethodContext,
	checkInheritance = checkInheritance,
	checkFriendship = checkFriendship,
	inClassScope = inClassScope,
	binarySearch = binarySearch
})