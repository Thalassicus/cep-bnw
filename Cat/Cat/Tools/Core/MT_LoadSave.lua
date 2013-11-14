-- MT_LoadSave.lua
-- Author: Thalassicus
-- DateCreated: 2/29/2012 7:33:59 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

---------------------------------------------------------------------
--[[  usage example:

]]

function LoadValue(...)
	local arg = {...}
	if arg == nil then
		log:Fatal("LoadValue arg=nil")
		return
	end
	return saveDB.GetValue("_"..string.format( unpack(arg) ))
end

function SaveValue(value, ...)
	local arg = {...}
	if arg == nil then
		log:Fatal("SaveValue arg=nil")
		return
	end
	return saveDB.SetValue("_"..string.format( unpack(arg) ), value)
end

function LoadPlayer(player, ...)
	local arg = {...}
	return saveDB.GetValue(string.format( "_player%s_%s", player:GetID(), string.format(unpack(arg)) ))
end

function SavePlayer(player, value, ...)
	local arg = {...}
	return saveDB.SetValue(string.format( "_player%s_%s", player:GetID(), string.format(unpack(arg)) ), value)
end

function LoadCity(city, ...)
	local arg = {...}
	if city == nil then
		log:Fatal("LoadCity city=nil key=%s value=%s", string.format(unpack(arg)), value)
		return
	end
	return saveDB.GetValue(string.format( "_city%s_%s", City_GetID(city), string.format(unpack(arg)) ))
end

function SaveCity(city, value, ...)
	local arg = {...}
	if city == nil then
		log:Fatal("SaveCity city=nil key=%s value=%s", string.format(unpack(arg)), value)
		return
	end
	return saveDB.SetValue(string.format( "_city%s_%s", City_GetID(city), string.format(unpack(arg)) ), value)
end

function LoadUnit(unit, ...)
	local arg = {...}
	return saveDB.GetValue(string.format( "_player%s_unit%s_%s", unit:GetOwner(), unit:GetID(), string.format(unpack(arg)) ))
end

function SaveUnit(unit, value, ...)
	local arg = {...}
	return saveDB.SetValue(string.format( "_player%s_unit%s_%s", unit:GetOwner(), unit:GetID(), string.format(unpack(arg)) ), value)
end

function LoadPlot(plot, ...)
	local arg = {...}
	return saveDB.GetValue(string.format( "_plot%s_%s", Plot_GetID(plot), string.format(unpack(arg)) ))
end

function SavePlot(plot, value, ...)
	local arg = {...}
	return saveDB.SetValue(string.format( "_plot%s_%s", Plot_GetID(plot), string.format(unpack(arg)) ), value)
end