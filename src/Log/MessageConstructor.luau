--!strict

--[[
	Written by @TenebrisNoctua.
	A message that can be displayed in the output panel.
]]

--// Variables

local RunService = game:GetService("RunService")

local Messages = require('./Messages')
local INFO_URL = "https://tenebrisnoctua.github.io/ClassPP/2.0/apiReference/errors#"

--// Return Message Object Constructor

return function(messageId: string, includeTraceback: boolean, formatTable: {any}?, ...): string
	local expandedMessage: string = (Messages :: any)[messageId]
	if not expandedMessage then expandedMessage = Messages["unknownError"] messageId = "unknownError" end
	
	local formattedMessage: string = (string.format :: any)(expandedMessage, table.unpack(formatTable or {""}))
	local fullMessage: string = `\{Class++}: {formattedMessage} \{ID: {messageId}}`
	
	if RunService:IsStudio() then
		fullMessage ..= `\nLearn more at: {INFO_URL}{messageId:lower()}`
	end
	
	if includeTraceback then
		local traceback = debug.traceback(nil, 4)
		fullMessage ..= `\n--- Stack Trace ---\n{traceback}`
	end
	
	if ... then fullMessage ..= ... end
	
	return fullMessage
end
