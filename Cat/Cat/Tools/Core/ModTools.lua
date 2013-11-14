-- ModTools.lua
-- Author: Thalassicus
-- DateCreated: 2/6/2011 5:17:42 AM
--------------------------------------------------------------

if Game == nil then
	--print("WARN  Game is nil")
	return
end

--include("SaveUtils.lua")
MY_MOD_NAME = "Communitas"

--print("Init ModTools.lua")
--MapModData.Cep_ = {}
saveDB = Modding.OpenSaveData()

Cep = {}
for row in GameInfo.Cep() do
	Cep[row.Type] = row.Value
end


-- temporary
function Plot_ChangeYield(plot, yieldID, yield)
	Game.SetPlotExtraYield( plot:GetX(), plot:GetY(), yieldID, yield)
end

--include("MT_Events.lua")

include("MT_Enums.lua")
include("CEAI_FixTables.lua")
include("MT_ErrorHandler.lua")
include("MT_LuaLogger.lua")
include("MT_LoadSave.lua")
include("MT_Utils.lua")
include("MT_City.lua")
include("MT_Player.lua")
include("MT_Plot.lua")
include("MT_Unit.lua")
include("MT_Misc.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")


MapModData.Cep_EverAtWarWithHuman = {}
--startClockTime = os.clock()
if UI:IsLoadedGame() then
	for playerID, player in pairs(Players) do
		MapModData.Cep_EverAtWarWithHuman[playerID] = LoadValue("MapModData.Cep_EverAtWarWithHuman[%s]", playerID)
	end
end
if UI:IsLoadedGame() then
	--log:Warn("%-10s seconds loading EverAtWarWithHuman", Game.Round(os.clock() - startClockTime, 8))
end