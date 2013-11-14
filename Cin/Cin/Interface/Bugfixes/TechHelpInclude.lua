-------------------------------------------------
-- Help text for techs
-------------------------------------------------

function GetHelpTextForTech( iTechID )
	local pTechInfo = GameInfo.Technologies[iTechID];
	
	local pActiveTeam = Teams[Game.GetActiveTeam()];
	local pActivePlayer = Players[Game.GetActivePlayer()];
	local pTeamTechs = pActiveTeam:GetTeamTechs();
	local iTechCost = pActivePlayer:GetResearchCost(iTechID);
	
	local strHelpText = "";

	-- Name
	strHelpText = strHelpText .. Locale.ToUpper(Locale.ConvertTextKey( pTechInfo.Description ));

	-- Do we have this tech?
	if (pTeamTechs:HasTech(iTechID)) then
		strHelpText = strHelpText .. " [COLOR_POSITIVE_TEXT](" .. Locale.ConvertTextKey("TXT_KEY_RESEARCHED") .. ")[ENDCOLOR]";
	end
	
	-- Power
	if Cep.SHOW_GOOD_FOR_TECHS == 1 then
		strHelpText = strHelpText .. "[NEWLINE]----------------";
		if Cep.SHOW_GOOD_FOR_AI_NUMBERS == 1 then
			strHelpText = strHelpText .. Game.GetFlavors("Technology_Flavors", "TechType", pTechInfo.Type, 4)
		else
			strHelpText = strHelpText .. Game.GetFlavors("Technology_Flavors_Human", "TechType", pTechInfo.Type, 4)
		end
	end
	strHelpText = strHelpText .. "[NEWLINE]-------------------------";
	strHelpText = strHelpText .. "[NEWLINE]";

	-- Cost/Progress
	
	local iProgress = pActivePlayer:GetResearchProgress(iTechID);
	local bShowProgress = true;
	
	-- Don't show progres if we have 0 or we're done with the tech
	if (iProgress == 0 or pTeamTechs:HasTech(iTechID)) then
		bShowProgress = false;
	end
	
	if (bShowProgress) then
		strHelpText = strHelpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_COST_WITH_PROGRESS", iProgress, iTechCost);
	else
		strHelpText = strHelpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_COST", iTechCost);
	end
	
	-- Leads to...
	local strLeadsTo = "";
	local bFirstLeadsTo = true;
	for row in GameInfo.Technology_PrereqTechs() do
		local pPrereqTech = GameInfo.Technologies[row.PrereqTech];
		local pLeadsToTech = GameInfo.Technologies[row.TechType];
		
		if (pPrereqTech and pLeadsToTech) then
			if (pTechInfo.ID == pPrereqTech.ID) then
				
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
		strHelpText = strHelpText .. "[NEWLINE]";
		strHelpText = strHelpText .. Locale.ConvertTextKey("TXT_KEY_TECH_HELP_LEADS_TO", strLeadsTo);
	end

	-- Pre-written help text
	if pTechInfo.Help and pTechInfo.Help ~= "" then
		strHelpText = strHelpText .. "[NEWLINE]-------------------------[NEWLINE]";
		strHelpText = strHelpText .. Locale.ConvertTextKey( pTechInfo.Help );
	end
	
	return strHelpText;
end