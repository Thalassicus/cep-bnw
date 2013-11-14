-- CAPTURE CITY POPUP
-- This popup occurs when a city is capture and must be annexed or puppeted.
include("ModTools.lua")

PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_CITY_CAPTURED] = function(popupInfo)
	local cityID				= popupInfo.Data1;
	local iCaptureGold			= popupInfo.Data2;
	local iCaptureCulture		= popupInfo.Data3;
	local iCaptureGreatWorks    = popupInfo.Data4;
	local iLiberatedPlayer		= popupInfo.Data5;
	local bMinorCivBuyout		= popupInfo.Option1;
	
	local activePlayer	= Players[Game.GetActivePlayer()];
	local newCity		= activePlayer:GetCityByID(cityID);
	
	if newCity == nil then
		return false;
	end

	--if (0 ~= GameDefines["PLAYER_ALWAYS_RAZES_CITIES"]) then
	--
		--activePlayer:Raze(newCity);
		--return false;
	--end
	
	-- Initialize popup text.	
	local cityNameKey = newCity:GetNameKey();
	if (iCaptureCulture > 0 or iCaptureGold > 0 or iCaptureGreatWorks > 0) then
	    if (iCaptureCulture > 0 or iCaptureGreatWorks > 0) then
			popupText = Locale.ConvertTextKey("TXT_KEY_POPUP_GOLD_AND_CULTURE_CITY_CAPTURE", iCaptureGold, iCaptureCulture, iCaptureGreatWorks, cityNameKey);
	    else
			popupText = Locale.ConvertTextKey("TXT_KEY_POPUP_GOLD_CITY_CAPTURE", iCaptureGold, cityNameKey);
		end
	else
		popupText = Locale.ConvertTextKey("TXT_KEY_POPUP_NO_GOLD_CITY_CAPTURE", cityNameKey);
	end
		
	-- Ask the player what he wants to do with this City
	popupText = popupText .. "  " .. Locale.ConvertTextKey("TXT_KEY_POPUP_CITY_CAPTURE_INFO");
	
	SetPopupText(popupText);
	
	-- Calculate Happiness info	
	local iUnhappinessForSacking = -1 * City_GetYieldChangeForAction(newCity, activePlayer, "CAPTURE_SACK")
	local iUnhappinessForPuppeting = -1 * City_GetYieldChangeForAction(newCity, activePlayer, "CAPTURE_PUPPET");
	
	-- Initialize 'Liberate' button.
	if (iLiberatedPlayer ~= -1) then
		local OnLiberateClicked = function()
			Network.SendLiberateMinor(iLiberatedPlayer, cityID);
		end
		
		local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_LIBERATE_CITY");
		local strToolTip = Locale.ConvertTextKey("TXT_KEY_POPUP_CITY_CAPTURE_INFO_LIBERATE", Players[iLiberatedPlayer]:GetNameKey());
		AddButton(buttonText, OnLiberateClicked, strToolTip);
	end
	
	-- Initialize 'Puppet' button.
	local OnPuppetClicked = function()
		Network.SendDoTask(cityID, TaskTypes.TASK_CREATE_PUPPET, -1, -1, false, false, false, false);
		City_Capture(newCity, activePlayer, "CAPTURE_PUPPET")
	end
	
	buttonText = Locale.ConvertTextKey("TXT_KEY_CAPTURE_PUPPET");
	strToolTip = Locale.ConvertTextKey("TXT_KEY_CAPTURE_PUPPET_HELP", iUnhappinessForPuppeting);
	AddButton(buttonText, OnPuppetClicked, strToolTip);
	
	-- Initialize 'Sack' button.
	local OnSackClicked = function()
		--Network.SendDoTask(cityID, TaskTypes.TASK_ANNEX_PUPPET, -1, -1, false, false, false, false);
		--newCity:ChooseProduction();
		Network.SendDoTask(cityID, TaskTypes.TASK_CREATE_PUPPET, -1, -1, false, false, false, false);
		City_Capture(newCity, activePlayer, "CAPTURE_SACK")
	end
	
	local buttonText = Locale.ConvertTextKey("TXT_KEY_CAPTURE_PILLAGE");
	local strToolTip = Locale.ConvertTextKey("TXT_KEY_CAPTURE_PILLAGE_HELP", iUnhappinessForSacking);
	AddButton(buttonText, OnSackClicked, strToolTip);
	
	-- Initialize 'Raze' button.
	local bRaze = activePlayer:CanRaze(newCity);
	if (bRaze) then
		local OnRazeClicked = function()
			Network.SendDoTask(cityID, TaskTypes.TASK_RAZE, -1, -1, false, false, false, false);
			City_Capture(newCity, activePlayer, "CAPTURE_RAZE")
		end
		
		buttonText = Locale.ConvertTextKey("TXT_KEY_CAPTURE_RAZE");
		strToolTip = Locale.ConvertTextKey("TXT_KEY_CAPTURE_RAZE_HELP", iUnhappinessForSacking);
		AddButton(buttonText, OnRazeClicked, strToolTip);
	end

	-- CITY SCREEN CLOSED - Don't look, Marc
	local CityScreenClosed = function()
		UIManager:DequeuePopup(Controls.EmptyPopup);
		Events.SerialEventExitCityScreen.Remove(CityScreenClosed);
	end
	
	-- Initialize 'View City' button.
	local OnViewCityClicked = function()
		
		-- Queue up an empty popup at a higher priority so that it prevents other cities from appearing while we're looking at this one!
		UIManager:QueuePopup(Controls.EmptyPopup, PopupPriority.GenericPopup+1);
		
		Events.SerialEventExitCityScreen.Add(CityScreenClosed);
		
		UI.SetCityScreenViewingMode(true);
		UI.DoSelectCityAtPlot( newCity:Plot() );
	end
	
	buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_VIEW_CITY");
	strToolTip = Locale.ConvertTextKey("TXT_KEY_POPUP_VIEW_CITY_DETAILS");
	AddButton(buttonText, OnViewCityClicked, strToolTip, true);	-- true is bPreventClose
end
