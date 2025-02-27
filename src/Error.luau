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

local function logMessage(messageType: string, includeTraceback: boolean?, tracebackString: string?, logType: string, ...)
	local formatString: string
	local messageString: string

	if LogMessages[messageType] ~= nil then
		formatString = LogMessages[messageType]
	else
		formatString = LogMessages["unknownError"]
	end

	if ... and includeTraceback then
		formatString = string.format(formatString, ...)
		messageString = `\{Class++}: {formatString}\n--- Stack Trace ---\n{tracebackString or debug.traceback(nil, 4)}`
	elseif ... and not includeTraceback then
		formatString = string.format(formatString, ...)
		messageString = `\{Class++}: {formatString}`
	elseif not ... and includeTraceback then
		messageString = `\{Class++}: {formatString}\n--- Stack Trace ---\n{tracebackString or debug.traceback(nil, 4)}`
	else
		messageString = `\{Class++}: {formatString}`
	end
	
	if logType == "Error" then
		error(messageString, 0)
	elseif logType == "Warning" then
		warn(messageString)
	end
end

--////// Module Functions

function classError.logError(messageType: string, includeTraceback: boolean?, ...)
	return logMessage(messageType, includeTraceback, nil, "Error", ...)
end

function classError.logErrorNonFatal(messageType: string, includeTraceback: boolean?, ...)
	local tracebackString: string = debug.traceback(nil, 4)
	
	task.spawn(function(...)
		return logMessage(messageType, includeTraceback, tracebackString, "Error", ...)
	end, ...)
end

function classError.logWarning(messageType: string, includeTraceback: boolean?, ...)
	return logMessage(messageType, includeTraceback, nil, "Warning", ...)
end

return classError
