-- LuaLogger
-- Author: Thalassicus
-- DateCreated: 2/29/2012 7:31:02 AM
--------------------------------------------------------------

--[[ LuaLogger usage example:
include("ModTools")
local log = Events.LuaLogger:New()
log:SetLevel("WARN")
log:Info("Loading ModTools")
]]

LOG_TRACE	= "TRACE"
LOG_DEBUG	= "DEBUG"
LOG_INFO	= "INFO"
LOG_WARN	= "WARN"
LOG_ERROR	= "ERROR"
LOG_FATAL	= "FATAL"

local LEVEL = {
	[LOG_TRACE] = 1,
	[LOG_DEBUG] = 2,
	[LOG_INFO]  = 3,
	[LOG_WARN]  = 4,
	[LOG_ERROR] = 5,
	[LOG_FATAL] = 6,
}

Events.LuaLogger = Events.LuaLogger or {}
Events.LuaLogger.New = Events.LuaLogger.New or function(self)
	local logger = {}
	setmetatable(logger, self)
	self.__index = self

	logger.level = LEVEL.INFO

	logger.SetLevel = function (self, level)
		self.level = level
	end

	logger.Message = function (self, level, ...)
		local arg = {...}
		if LEVEL[level] < LEVEL[self.level] then
			return false
		end
		if type(arg[1]) == "string" then
			local _, numCommands = string.gsub(arg[1], "[%%]", "")
			for i = 2, numCommands+1 do
				if type(arg[i]) ~= "number" and type(arg[i]) ~= "string" then
					arg[i] = tostring(arg[i])
				end
			end
		else
			arg[1] = tostring(arg[1])
		end
		local message = string.format(unpack(arg))
		if level == LOG_FATAL then
			message = string.format("Turn %-3s %s", Game.GetGameTurn(), message)
			print(level .. string.rep(" ", 7-level:len()) .. message)
			if debug then print(debug.traceback()) end
		else
			if level >= LOG_INFO then
				message = string.format("Turn %-3s %s", Game.GetGameTurn(), message)
			end
			print(level .. string.rep(" ", 7-level:len()) .. message)
		end
		return true
	end
	

	if GameDefines.CEP_DEBUG_MODE == 1 then
		logger.Trace = function (logger, ...) return logger:Message(LOG_TRACE, unpack{...}) end
		logger.Debug = function (logger, ...) return logger:Message(LOG_DEBUG, unpack{...}) end
		logger.Info  = function (logger, ...) return logger:Message(LOG_INFO,  unpack{...}) end
	else
		logger.Trace = function () end
		logger.Debug = function () end
		logger.Info  = function () end
	end
	logger.Warn  = function (logger, ...) return logger:Message(LOG_WARN,  unpack{...}) end
	logger.Error = function (logger, ...) return logger:Message(LOG_ERROR, unpack{...}) end
	logger.Fatal = function (logger, ...) return logger:Message(LOG_FATAL, unpack{...}) end
	return logger
end