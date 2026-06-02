--!strict

--[[
	Written by @TenebrisNoctua.
	Handles logging messages to the output with different methods.
--]]

--// Variables

const MessageConstructor = require('./MessageConstructor')
const Messages = require('./Messages')

--// Local Functions

-- Errors and halts execution of the current thread.
local function logError(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...): never
	error(MessageConstructor(messageId, includeTraceback, formatTable, ...), 0)
end

-- Errors without halting the current thread.
local function logErrorNonFatal(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...): ()
	if not task or not task.spawn then logError("nonProvidedGlobal", true, {"library task"}) end
	task.spawn(error :: any, MessageConstructor(messageId, includeTraceback, formatTable, ...), 0)
end

-- Displays a warning message to the output.
local function logWarn(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...)
	if not warn then logError("nonProvidedGlobal", true, {"function warn"}) end
	warn(MessageConstructor(messageId, includeTraceback, formatTable, ...))
end

--// Return Logger

return table.freeze({
	logError = logError,
	logErrorNonFatal = logErrorNonFatal,
	logWarn = logWarn
})