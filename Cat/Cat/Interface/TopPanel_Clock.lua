-- Clock
-- Author: Attila
-- DateCreated: 2010-10-02 09:04:41 AM
--------------------------------------------------------------
--Clock from AgentofEvil

TimeFormats = {}
TimeFormats[12] = "%I:%M";
TimeFormats[24] = "%H:%M";


ModID		= "01127f62-3896-4897-b169-ecab445786cd";
ModVersion	= Modding.GetActivatedModVersion(ModID) or 2;
ModUserData = Modding.OpenUserData(ModID, ModVersion);

local CurrentTimeFormatIndex = ModUserData.GetValue("TimeFormat") or 12;

ContextPtr:SetUpdate(function ()
	local computersystime = os.date(TimeFormats[CurrentTimeFormatIndex]);
	Controls.TopPanelClock:SetText(computersystime);
end);

function ToggleTimeFormat()
	CurrentTimeFormatIndex = ((CurrentTimeFormatIndex + 11) % 24) + 1;
	ModUserData.SetValue("TimeFormat", CurrentTimeFormatIndex)
end;

Controls.TopPanelClock:RegisterCallback( Mouse.eLClick, ToggleTimeFormat );
