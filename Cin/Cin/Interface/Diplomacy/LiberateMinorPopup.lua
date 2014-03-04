-- LIBERATE MINOR POPUP
-- This popup occurs when a player captures a City that was first founded by a Minor and can liberate that Minor
include("ModTools.lua")
PopupLayouts[ButtonPopupTypes.BUTTONPOPUP_LIBERATE_MINOR] = function(popupInfo)

	local eMinor		= popupInfo.Data1;
	local iCityID		= popupInfo.Data2;
	
	local pMinor				= Players[eMinor];
	local pActivePlayer	= Players[Game.GetActivePlayer()];
	local pNewCity			= pActivePlayer:GetCityByID(iCityID);
	
	-- Initialize popup text.	
	local cityNameKey = pNewCity:GetNameKey();
	popupText = Locale.ConvertTextKey("TXT_KEY_POPUP_CITY_CAPTURE_LIBERATE_MINOR", cityNameKey, pMinor:GetNameKey());
	
	SetPopupText(popupText);
	
	-- Initialize 'yes' button.
	local OnYesClicked = function()
		Network.SendLiberateMinor(eMinor, iCityID);
		Events.CityLiberated(pNewCity, pActivePlayer, "LIBERATE")
	end
	
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_YES");
	AddButton(buttonText, OnYesClicked);
	
	-- Initialize 'No, Puppet' button.
	local OnNoPuppetClicked = function()
		Network.SendDoTask(iCityID, TaskTypes.TASK_CREATE_PUPPET, -1, -1, false, false, false, false);
		Events.CityPuppeted(pNewCity, pActivePlayer, "PUPPET")
	end
	
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_NO_PUPPET");
	AddButton(buttonText, OnNoPuppetClicked);
	
	--[[ Initialize 'No, Annex' button.
	local OnNoAnnexClicked = function()
		--Events.CityOccupied(newCity, activePlayer, "OCCUPIED")
	end
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_ANNEX_CITY");
	AddButton(buttonText, OnNoAnnexClicked);
	--]]
end




