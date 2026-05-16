--!strict

--[[
	Written by @TenebrisNoctua.
	A message that can be displayed in the output panel.
]]

--// Variables

local canPrintLink = true

-- Check whether or not we're on the Roblox runtime, and if we're in Roblox Studio.
if game and game.GetService and game:GetService("RunService") then
	canPrintLink = game:GetService("RunService"):IsStudio()
end

const Messages = require('./Messages')
const Info_Url = "https://tenebrisnoctua.github.io/ClassPP/2.0/api-reference/errors#"

--// Return Message Object Constructor

return function(messageId: keyof<typeof(Messages)> | string, includeTraceback: boolean, formatTable: {any}?, ...): string
	local expandedMessage: string = (Messages :: any)[messageId]
	if not expandedMessage then expandedMessage = Messages["unknownError"] messageId = "unknownError" end
	
	local formattedMessage: string = string.format(expandedMessage, table.unpack(formatTable or {""}))
	local fullMessage: string = `\{Class++}: {formattedMessage} \{ID: {messageId}}`
	
	if canPrintLink then
		fullMessage ..= `\nLearn more at: {Info_Url}{messageId:lower()}`
	end
	
	if includeTraceback then
		local traceback = debug.traceback(nil, 4)
		fullMessage ..= `\n--- Stack Trace ---\n{traceback}`
	end
	
	if ... then fullMessage ..= ... end
	
	return fullMessage
end