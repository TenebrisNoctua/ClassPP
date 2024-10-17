--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		Handles logging Class++ specific errors.
	////
--]]

--////// Variables

local classError = {}
local LogMessages = require(script.Parent.LogMessages)

--////// Local Functions

local function logError(messageType: string, includeTraceback: boolean?, tracebackString: string?, ...)
	local formatString: string
	local errorString: string

	if LogMessages[messageType] ~= nil then
		formatString = LogMessages[messageType]
	else
		formatString = LogMessages["unknownError"]
	end

	if ... and includeTraceback then
		formatString = string.format(formatString, ...)
		errorString = `\{Class++}: {formatString}\n--- Stack Trace ---\n{tracebackString or debug.traceback(nil, 4)}`
	elseif ... and not includeTraceback then
		formatString = string.format(formatString, ...)
		errorString = `\{Class++}: {formatString}`
	elseif not ... and includeTraceback then
		errorString = `\{Class++}: {formatString}\n--- Stack Trace ---\n{tracebackString or debug.traceback(nil, 4)}`
	else
		errorString = `\{Class++}: {formatString}`
	end

	error(errorString, 0)
end

--////// Module Functions

function classError.logError(messageType: string, includeTraceback: boolean?, ...)
	return logError(messageType, includeTraceback, nil, ...)
end

function classError.logErrorNonFatal(messageType: string, includeTraceback: boolean?, ...)
	local tracebackString: string = debug.traceback(nil, 4)
	
	task.spawn(function(...)
		return logError(messageType, includeTraceback, tracebackString, ...)
	end, ...)
end

return classError
