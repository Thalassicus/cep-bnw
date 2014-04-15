-------------------------------------------------
-- Help text for techs
-------------------------------------------------

function GetHelpTextForTech( iTechID, bShowProgress )
	local techInfo = GameInfo.Technologies[iTechID];
	
	local pActiveTeam = Teams[Game.GetActiveTeam()];
	local pActivePlayer = Players[Game.GetActivePlayer()];
	local pTeamTechs = pActiveTeam:GetTeamTechs();
	local iTechCost = pActivePlayer:GetResearchCost(iTechID);
	
	local helpText = "";

	-- Name
	helpText = helpText .. Locale.ToUpper(Locale.ConvertTextKey( techInfo.Description ));

	-- Do we have this tech?
	if (pTeamTechs:HasTech(iTechID)) then
		helpText = helpText .. " [COLOR_POSITIVE_TEXT](" .. Locale.ConvertTextKey("TXT_KEY_RESEARCHED") .. ")[ENDCOLOR]";
	end
	
	-- Power
	if Civup.SHOW_GOOD_FOR_TECHS == 1 then
		helpText = helpText .. "[NEWLINE]----------------";
		if Civup.SHOW_GOOD_FOR_AI_NUMBERS == 1 then
			helpText = helpText .. Game.GetFlavors("Technology_Flavors", "TechType", techInfo.Type, 8)
		else
			helpText = helpText .. Game.GetFlavors("Technology_Flavors_Human", "TechType", techInfo.Type, 8)
		end
	end
	helpText = helpText .. "[NEWLINE]-------------------------";
	helpText = helpText .. "[NEWLINE]";

	-- Cost/Progress
	
	local iProgress = pActivePlayer:GetResearchProgress(iTechID);
	
	-- Don't show progres if we have 0 or we're done with the tech
	if (iProgress == 0 or pTeamTechs:HasTech(iTechID)) then
		bShowProgress = false;
	end
	
	if (bShowProgress) then
		helpText = helpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_COST_WITH_PROGRESS", iProgress, iTechCost);
	else
		helpText = helpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_COST", iTechCost);
	end
	
	-- Leads to...
	local strLeadsTo = "";
	local bFirstLeadsTo = true;
	for row in GameInfo.Technology_PrereqTechs() do
		local pPrereqTech = GameInfo.Technologies[row.PrereqTech];
		local pLeadsToTech = GameInfo.Technologies[row.TechType];
		
		if (pPrereqTech and pLeadsToTech) then
			if (techInfo.ID == pPrereqTech.ID) then
				
				-- If this isn't the first leads-to tech, then add a comma to separate
				if (bFirstLeadsTo) then
					bFirstLeadsTo = false;
				else
					strLeadsTo = strLeadsTo .. ", ";
				end
				
				strLeadsTo = strLeadsTo .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey( pLeadsToTech.Description ) .. "[ENDCOLOR]";
			end
		end
	end
	
	if (strLeadsTo ~= "") then
		helpText = helpText .. "[NEWLINE]";
		helpText = helpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_LEADS_TO", strLeadsTo);
	end

	-- Pre-written help text
	if techInfo.Help and techInfo.Help ~= "" then
		helpText = helpText .. "[NEWLINE]-------------------------";
		helpText = helpText .. Locale.ConvertTextKey( techInfo.Help );
	end
	
	return helpText;
end