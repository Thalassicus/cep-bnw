-- Interface_AutoSaveTimed
-- Author: Thalassicus
-- DateCreated: 2/4/2013 5:24:38 PM
--------------------------------------------------------------

local ModID					= "01127f62-3896-4897-b169-ecab445786cd"
local ModVersion			= Modding.GetActivatedModVersion(ModID) or 2
local ModUserData			= Modding.OpenUserData(ModID, ModVersion)
local saveIndex				= ModUserData.GetValue("Civup_AutoSaveIndex") or 0
local secElapsed			= 0
local txtSaving				= string.format("[COLOR_POSITIVE_TEXT]%s . . .[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_SAVING"))
local showedAlert			= false
local firstSave				= false

MapModData.AutosaveMinutes	= ModUserData.GetValue("Civup_AutoSaveMinutes")
MapModData.AutosaveTurns	= ModUserData.GetValue("Civup_AutoSaveTurns")
if not MapModData.AutosaveMinutes then
	MapModData.AutosaveMinutes = 15
	ModUserData.SetValue("Civup_AutoSaveMinutes", MapModData.AutosaveMinutes)
end
if not MapModData.AutosaveTurns then
	MapModData.AutosaveTurns = 10
	ModUserData.SetValue("Civup_AutoSaveTurns", MapModData.AutosaveTurns)
end


if (Game:IsNetworkMultiPlayer()
	or Modding.AnyActivatedModsContainPropertyValue( "DisableSaveMapOption", "1" )
	or Game.IsOption( GameOptionTypes.GAMEOPTION_LOCK_MODS )
	or OptionsManager.GetNumAutosavesKept_Cached() <= 0 
	) then
	return
end

function SaveGame(fileIndex)
	local fileName = string.format("auto/AutoSave %s %s  %s turn%s", fileIndex or saveIndex+1, os.date("%a"), Players[Game.GetActivePlayer()]:GetName(), Game.GetTimeString())
	fileName = string.gsub(fileName, "[ :%-]", "_")
	print("saving "..fileName)
	Game.CivupSaveGame(fileName)
	
	showedAlert = false
	secElapsed = 0
	if not fileIndex then
		saveIndex = (saveIndex + 1) % OptionsManager.GetNumAutosavesKept_Cached()
		ModUserData.SetValue("Civup_AutoSaveIndex", saveIndex)
	end
end

ContextPtr:SetUpdate(function (secSinceUpdate)
	if MapModData.AutosaveMinutes <= 0 then
		return
	end
	secElapsed = secElapsed + secSinceUpdate
	if secElapsed >= MapModData.AutosaveMinutes * 60 then
		SaveGame()
	end
	if secElapsed + 1 >= MapModData.AutosaveMinutes * 60 and not showedAlert then
		Events.GameplayAlertMessage(txtSaving)
		showedAlert = true
	end

	if not UI.IsLoadedGame() and not firstSave and secElapsed >= 0.25 then
		firstSave = true
		local fileName = string.format("auto/AutoSave_%s_%s", "Initial", Game.GetTimeString())
		print("saving "..fileName)
		Game.CivupSaveGame(fileName)
		--SaveGame()
	end
end)

Events.ActivePlayerTurnStart.Add(function()
	local turns = tonumber(MapModData.AutosaveTurns) or 0
	if turns > 0 and Game.GetGameTurn() % turns == 0 then
		Events.GameplayAlertMessage(txtSaving)
		SaveGame("StartTurn")
	end
end)

if not UI.IsLoadedGame() then
	saveIndex = 0
	ModUserData.SetValue("Civup_AutoSaveIndex", saveIndex)
end