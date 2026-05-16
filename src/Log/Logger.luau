--!strict

--[[
	Written by @TenebrisNoctua.
	Handles logging messages to the output with different methods.
--]]

--// Variables

const MessageConstructor = require('./MessageConstructor')
const Messages = require('./Messages')

const Logger = {}

--/// Module Functions

--[[
	Errors and halts execution of the current thread.
]]
function Logger.logError(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...): never
	error(MessageConstructor(messageId, includeTraceback, formatTable, ...), 0)
end

--[[
	Errors without halting the current thread.
]]
function Logger.logErrorNonFatal(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...): ()
	task.spawn(error, MessageConstructor(messageId, includeTraceback, formatTable, ...), 0)
end

--[[
	Displays a warning message to the output.
]]
function Logger.logWarn(messageId: keyof<typeof(Messages)>, includeTraceback: boolean, formatTable: {any}?, ...)
	warn(MessageConstructor(messageId, includeTraceback, formatTable, ...))
end

return Logger