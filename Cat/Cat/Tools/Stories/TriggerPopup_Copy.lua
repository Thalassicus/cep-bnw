-- TriggerPopup.lua
-- Author: Thalassicus
-- Based on work by: Hipfot, Skodkim, Spatzimaus, and VeyDer
--------------------------------------------------------------

include("InstanceManager")
include("IconSupport")
include("FLuaVector")
include("GameplayUtilities")
include("TriggerUtils")
include("ThalsUtilities.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

--include("MythUtils")

--function BuildUserEventPopup(...)
function BuildUserEventPopup(event)
--    print(unpack({...}))
	if (event ~= nil) then
	log:Info("BuildUserEventPopup ", event.id)
	local playerID, cityID, unitID, plot_coords	= unpack(event._elem)

	if playerID == nil or plot_coords == nil then
		return
	end

	local activePlayerID	= Game.GetActivePlayer() -- TODO: handle AI players, using flavor option value to determine the preferred choice

	local player	= Players[playerID]	
	local tarCity	= player:GetCityByID(cityID)
	local tarUnit	= player:GetUnitByID(unitID)
	local tarPlot	= Map.GetPlot(plot_coords.x, plot_coords.y)
	local hex		= ToHexFromGrid(Vector2(plot_coords.x, plot_coords.y))
	local tipTitle	= "TXT_KEY_TRIGGER_" .. event.id
	local tipDesc	= "TXT_KEY_TRIGGER_" .. event.id .. "_DESC"
	local tipData	= {}
	local activeTeamID = Game.GetActiveTeam()
	local screenSizeX, screenSizeY = UIManager:GetScreenSizeVal() 

	if Teams[player:GetTeam()]:IsHasMet(activeTeamID) then
		tipData[1]	= player:GetName()
	else
		tipData[1]	= Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
	end

	if tarCity and tarCity:IsRevealed(activeTeamID) then
		tipData[2]	= tarCity:GetName()
	else
		tipData[1]	= Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
	end

	if tarUnit and not tarUnit:IsInvisible(activeTeamID) then
		tipData[3]	= Locale.ConvertTextKey(GameInfo.Units[tarUnit:GetUnitType()].Description)
	else
		tipData[1]	= Locale.ConvertTextKey("TXT_KEY_DISTANT_UNIT")
	end

	if (playerID == activePlayerID) then
		Events.SerialEventHexHighlight(hex, true, Vector4(1.0, 1.0, 0.0, 1))
		UI.LookAt(tarPlot)

		local controlTable	= {}
		
		Controls.EventTitle:LocalizeAndSetText(tipTitle, unpack(tipData))
		Controls.EventDescription:LocalizeAndSetText(tipDesc, unpack(tipData))
		CivIconHookup(playerID, 64, Controls.CivIcon, Controls.CivIconBG, Controls.CivIconShadow, false, true)

		Controls.EventOptionStack:DestroyAllChildren()
	end

	local event_options	= {}

	local ParamWrapper = function(callback)
		callback(player, tarCity, tarUnit, tarPlot)
	end

	local options = {}

	for outID, option in pairs(event.options) do
		option.__id	= outID
		table.insert(options, option)
	end
	table.sort(options, function(a, b) return a.order < b.order end)

	if (playerID == activePlayerID) then
		for o_i, option in pairs(options) do
			local outID	= option.__id
			local opt	= {}

			local option_i18n		= tipTitle .."_" .. outID
			local option_desc_i18n	= option.description or tipTitle .. "_OPTION_" .. o_i
			local option_tip_i18n	= option.tooltip or tipTitle .. "_TIP_" .. o_i

			ContextPtr:BuildInstanceForControl("EventOptionInstance", opt, Controls.EventOptionStack)

			opt.Name:LocalizeAndSetText(option_desc_i18n, unpack(tipData))
			local height = opt.Name:GetSizeY() + 20
			opt.Button:SetSizeY(height)

			if not option.is_valid then
				opt.MouseOverContainer:SetHide(true)
				opt.Button:SetAlpha(0.6)
			else
				opt.MouseOverContainer:SetHide(false)
				opt.MouseOverContainer:SetSizeY(height + 5)
				opt.MouseOverAnim:SetSizeY(height + 5)
				opt.MouseOverGrid:SetSizeY(height + 5)
				opt.Button:SetAlpha(1.0)
				opt.Button:RegisterCallback(
					Mouse.eLClick,
					function()
						option.effect(player, tarCity, tarUnit, tarPlot) 
						Events.GameplayFX(hex.x, hex.y, -1)
						Controls.BGBlock:SetHide(true)
					end
					)
			end

			opt.Button:LocalizeAndSetToolTip(option_tip_i18n, unpack(tipData))
		end
		Controls.EventOptionStack:CalculateSize()
		Controls.EventOptionStack:ReprocessAnchoring()
		Controls.EventStack:CalculateSize()
		Controls.EventStack:ReprocessAnchoring()
		Controls.MainGrid:SetSizeY(100 + Controls.EventStack:GetSizeY())
		Controls.MainGrid:SetOffsetY(0.5 * screenSizeY + 10)
		Controls.BGBlock:SetSizeY(Controls.MainGrid:GetSizeY())
		Controls.BGBlock:SetHide(false)
	else
		-- It's an AI, don't set up any windows, but just do the selection directly.
		local nValid = 0
		local outID = {}
		local optWeight = {}
		local totWeight = 0.0


--			local Fnum = DirCheck(playerID) -- 4-element array showing how many gods are available in each direction.
		local Fnum = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}
		local Ltype = GameInfo.Leaders[player:GetLeaderType()].Type

		for o_i, option in pairs(options) do
			if (option.is_valid) then
				nValid = nValid + 1
				outID[nValid] = option.__id
				optWeight[nValid] = Fnum[option.order]*1.0 -- Fnum+1?  So that it CAN pick a direction with zero?

				local flav1 = option.flavor1
				if (flav1 ~= nil) then
					local condition1 = "LeaderType = '" .. Ltype .. "' and FlavorType = '"..flav1.."'"
					for row in GameInfo.Leader_Flavors(condition1) do
						optWeight[nValid] = optWeight[nValid] * (0.5 + row.Flavor/10.0)
					end
				end
				
				local flav2 = option.flavor2
				if (flav2 ~= nil) then
					local condition2 = "LeaderType = '" .. Ltype .. "' and FlavorType = '"..flav2.."'"
					for row in GameInfo.Leader_Flavors(condition2) do
						optWeight[nValid] = optWeight[nValid] * (0.5 + row.Flavor/10.0)
					end
				end

				local flav3 = option.flavor3
				if (flav3 ~= nil) then
					local condition3 = "LeaderType = '" .. Ltype .. "' and FlavorType = '"..flav3.."'"
					for row in GameInfo.Leader_Flavors(condition3) do
						optWeight[nValid] = optWeight[nValid] * (0.5 + row.Flavor/10.0)
					end
				end

				totWeight = totWeight + optWeight[nValid]
			end
		end
		if (totWeight < 0.01) then
			-- No direction had any choices.
			optWeight = {1.0,1.0,1.0,1.0}
			totWeight = nValid*1.0
		end
		local diceroll = Map.Rand(totWeight*100,"AI event selection") / 100.0
		for ii = 1,nValid do
			if (diceroll >= 0.0 and diceroll < optWeight[ii]) then
				for o_i, option in pairs(options) do
					if (option.is_valid and option.__id == outID[ii]) then
						-- This is the right one.  Trigger the effect.
						--print(" AI triggering event: ", event.id, outID[ii], option.effect)
						option.effect(player, tarCity, tarUnit, tarPlot)
						diceroll = -999.0 -- prevents multiple options from triggering.
					end
				end
			else
				diceroll = diceroll - optWeight[ii]
			end
		end
	end
	end
end
LuaEvents.TriggerPopupBuild.Add(BuildUserEventPopup)