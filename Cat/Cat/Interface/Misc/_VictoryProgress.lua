----------------------------------------------------------------
----------------------------------------------------------------
include("IconSupport");
include("SupportFunctions");
include("InstanceManager");

-- Domination Variables
local g_DominationRowsIM = InstanceManager:new( "DominationRow", "RowStack", Controls.DominationStack );
local g_DominationRowList = {};
local g_DominationItemIMList = {};
local g_DominationItemList = {};

MAX_DOMINATION_ICONS_PER_ROW = 10;

-- Tech Variables
local g_TechPreReqList = {};
local g_PreReqsAcquired = 0;

-- Cultural Variables
local g_CultureIM = InstanceManager:new( "CultureItem", "Item", Controls.CultureStack );
local g_CultureList = {};

-- Tech Details Variables
local g_TechIM = InstanceManager:new( "TechCiv", "Civ", Controls.TechStack );
local g_TechList = {};

-- Diplo Details Variables
local g_DiploIM = InstanceManager:new( "DiploCiv", "Civ", Controls.DiploStack );
local g_DiploList = {};

-- Cultural Details Variables
local g_CultureRowsIM = InstanceManager:new( "CultureCiv", "Civ", Controls.CultureCivs );
local g_CultureRowList = {};
local g_CultureItemIMList = {};
local g_CultureItemList = {};

-- Score Details Variables
local g_ScoreIM = InstanceManager:new( "ScoreCiv", "Civ", Controls.ScoreStack );
local g_ScoreList = {};

----------------------------------------------------------------
----------------------------------------------------------------
function OnBack()
	Controls.YourDetails:SetHide(false);
	Controls.ScoreScreen:SetHide(true);
	Controls.SpaceRaceScreen:SetHide(true);
	Controls.DiploScreen:SetHide(true);
	Controls.CultureScreen:SetHide(true);
		
	
	-- Delete instanced screens
	DeleteSpaceRaceScreen();
	DeleteDiploScreen();
	DeleteCultureScreen();
	DeleteScoreScreen();
	
	UIManager:DequeuePopup( ContextPtr );
end
Controls.BackButton:RegisterCallback( Mouse.eLClick, OnBack );

----------------------------------------------------------------
----------------------------------------------------------------
function OnSpaceRaceDetails()
	Controls.YourDetails:SetHide(true);
	Controls.SpaceRaceScreen:SetHide(false);
	Controls.BackButton:SetHide(true);
	Controls.SpaceRaceClose:SetHide(false);
	
	-- Populate Detail Screens
	PopulateSpaceRaceScreen();
end
Controls.SpaceRaceDetails:RegisterCallback( Mouse.eLClick, OnSpaceRaceDetails );

----------------------------------------------------------------
----------------------------------------------------------------
function OnDiploDetails()
	Controls.YourDetails:SetHide(true);
	Controls.DiploScreen:SetHide(false);
	Controls.BackButton:SetHide(true);
	Controls.DiploClose:SetHide(false);
	
	-- Populate Detail Screens
	PopulateDiploScreen();
	
end
Controls.DiploDetails:RegisterCallback( Mouse.eLClick, OnDiploDetails );

----------------------------------------------------------------
----------------------------------------------------------------
function OnCultureDetails()
	Controls.YourDetails:SetHide(true);
	Controls.CultureScreen:SetHide(false);
	Controls.BackButton:SetHide(true);
	Controls.CultureClose:SetHide(false);
	
	-- Populate Detail Screens
	PopulateCultureScreen();
end
Controls.CultureDetails:RegisterCallback( Mouse.eLClick, OnCultureDetails );

----------------------------------------------------------------
----------------------------------------------------------------
function OnScoreDetails()
	Controls.YourDetails:SetHide(true);
	Controls.ScoreScreen:SetHide(true);
	Controls.SpaceRaceScreen:SetHide(true);
	Controls.DiploScreen:SetHide(true);
	Controls.CultureScreen:SetHide(true);
	Controls.ScoreScreen:SetHide(false);
	Controls.BackButton:SetHide(true);
	
	Controls.ScoreClose:SetHide(false);
	Controls.CultureClose:SetHide(true);
	Controls.DiploClose:SetHide(true);
	Controls.SpaceRaceClose:SetHide(true);
	
	-- Populate Detail Screens
	PopulateScoreScreen();
end
Controls.ScoreDetails:RegisterCallback( Mouse.eLClick, OnScoreDetails );

----------------------------------------------------------------
----------------------------------------------------------------
function OnSpaceRaceClose()
	Controls.YourDetails:SetHide(false);
	Controls.SpaceRaceScreen:SetHide(true);
	Controls.BackButton:SetHide(false);
	Controls.SpaceRaceClose:SetHide(true);
	
	-- Delete instanced parts of culture screen
	DeleteSpaceRaceScreen();
end
Controls.SpaceRaceClose:RegisterCallback( Mouse.eLClick, OnSpaceRaceClose );

----------------------------------------------------------------
----------------------------------------------------------------
function OnDiploClose()
	Controls.YourDetails:SetHide(false);
	Controls.DiploScreen:SetHide(true);
	Controls.BackButton:SetHide(false);
	Controls.DiploClose:SetHide(true);
	
	-- Delete instanced parts of culture screen
	DeleteDiploScreen();
end
Controls.DiploClose:RegisterCallback( Mouse.eLClick, OnDiploClose );

----------------------------------------------------------------
----------------------------------------------------------------
function OnCultureClose()
	Controls.YourDetails:SetHide(false);
	Controls.CultureScreen:SetHide(true);
	Controls.BackButton:SetHide(false);
	Controls.CultureClose:SetHide(true);
	
	-- Delete instanced parts of culture screen
	DeleteCultureScreen();
end
Controls.CultureClose:RegisterCallback( Mouse.eLClick, OnCultureClose );

----------------------------------------------------------------
----------------------------------------------------------------
function OnScoreClose()
	Controls.YourDetails:SetHide(false);
	Controls.ScoreScreen:SetHide(true);
	Controls.BackButton:SetHide(false);
	Controls.ScoreClose:SetHide(true);
	
	-- Delete instanced parts of culture screen
	DeleteScoreScreen();
end
Controls.ScoreClose:RegisterCallback( Mouse.eLClick, OnScoreClose );


function PopulateScoreBreakdown()
	local pPlayer = Players[Game.GetActivePlayer()];

	if(PreGame.IsVictory(GameInfo.Victories["VICTORY_TIME"].ID))then
		Controls.Cities:SetText(pPlayer:GetScoreFromCities());
		Controls.Population:SetText(pPlayer:GetScoreFromPopulation());
		Controls.Land:SetText(pPlayer:GetScoreFromLand());
		Controls.Wonders:SetText(pPlayer:GetScoreFromWonders());
		Controls.Tech:SetText(pPlayer:GetScoreFromTechs());
		Controls.FutureTech:SetText(pPlayer:GetScoreFromFutureTech());
		Controls.Score:SetText(pPlayer:GetScore());
	else
		Controls.ScoreDetails:SetHide(true);
		Controls.TimeStack:SetHide(true);
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateDomination()
		
	for i, v in pairs(g_DominationItemIMList) do
		v:ResetInstances();
	end
	g_DominationRowsIM:ResetInstances();
	
	g_DominationRowList = {};
	g_DominationItemList = {};
	g_DominationItemIMList = {};
	
	local curRow = nil;
	local numRows = 0;
	local curItemIM = nil;
	local numItemIM = 0;
	local curCol = 0;
	local numItems = 0;
	local numCapitals = 0;
	
	-- Loop through all the civs the active player knows
	for iPlayerLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do

		local pPlayer = Players[iPlayerLoop];
		
		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			-- Create new row if one does not alread exist.
			if(curRow == nil) then
				numRows = numRows + 1;
				curRow = g_DominationRowsIM:GetInstance();
				g_DominationRowList[numRows] = curRow;
				
				numItemIM = numItemIM + 1;
				curItemIM = InstanceManager:new( "DominationItem", "IconFrame", curRow.RowStack );
				g_DominationItemIMList[numItemIM] = curItemIM;
				
			end
			
			local newNumItems = AddDominationCiv(pPlayer, numItems, curItemIM);
			
			if(newNumItems ~= numItems) then
				numItems = newNumItems;
				
				if(not pPlayer:IsHasLostCapital()) then
					numCapitals = numCapitals + 1;
				end
				
				curCol = curCol + 1;
				if(curCol >= MAX_DOMINATION_ICONS_PER_ROW) then
					curRow = nil;
					curCol = 0;
				end
			end
		end
	end
	
	Controls.DominationLabel:SetText(Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_CAPITALS_REMAINING",  numCapitals));
		
	Controls.DominationStack:CalculateSize();
	Controls.DominationStack:ReprocessAnchoring();
	--Controls.DominationScrollPanel:CalculateInternalSize();
end

----------------------------------------------------------------
----------------------------------------------------------------
function AddDominationCiv(pPlayer, numItems, civMgr)
	
	if(pPlayer:IsEverAlive()) then
		local item = civMgr:GetInstance();
		g_DominationItemList[numItems] = item;
		numItems = numItems + 1;
		
		local iPlayer = pPlayer:GetID();
		-- Set Civ Icon
		SetCivIcon(pPlayer, 64, item.Icon, item.IconFrame, item.IconOut, 
				   pPlayer:IsHasLostCapital() or not pPlayer:IsAlive(),
				   item.CivIconBG, item.CivIconShadow); 

        local pTeam = Teams[ pPlayer:GetTeam() ];
        if( pTeam:GetNumMembers() > 1 ) then
    	    item.TeamID:LocalizeAndSetText( "TXT_KEY_MULTIPLAYER_DEFAULT_TEAM_NAME", pTeam:GetID() + 1 );
    	    item.TeamID:SetHide( false );
	    else
    	    item.TeamID:SetHide( true );
	    end
	end
	return numItems;
end 

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateSpaceRace()
	if(PreGame.IsVictory(GameInfo.Victories["VICTORY_SPACE_RACE"].ID))then
		local apolloProj = GameInfoTypes["PROJECT_APOLLO_PROGRAM"];
		local strPlayer = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY");
		if(apolloProj ~= -1) then
			local white = {x = 1, y = 1, z = 1, w = 1};
			local iTeam = Game.GetActiveTeam();
			if(Teams[iTeam]:GetProjectCount(apolloProj) == 1) then
				Controls.TechProgress:SetHide(true);
				Controls.ApolloProject:SetHide(false);
				Controls.BubblesAnim:SetHide(true);
				Controls.ApolloIcon:SetColor(white);
				
				SetProjectValue("PROJECT_SS_BOOSTER", iTeam, Controls, "Booster");
				SetProjectValue("PROJECT_SS_COCKPIT", iTeam, Controls, "Cockpit");
				SetProjectValue("PROJECT_SS_STASIS_CHAMBER", iTeam, Controls, "Chamber");
				SetProjectValue("PROJECT_SS_ENGINE", iTeam, Controls, "Engine");
			else
				local totalPreReqs = #g_TechPreReqList;
				
				-- Prevent a divide by 0.
				if(totalPreReqs == 0) then
					totalPreReqs = 1;
				end

				Controls.TechProgress:SetHide(false);
				Controls.BubblesAnim:SetHide(false);
				Controls.TechProgress:SetPercent(g_PreReqsAcquired / totalPreReqs);
				
				if(g_PreReqsAcquired >= totalPreReqs) then
					Controls.TechIconAnim:SetHide(false);
					Controls.BubblesAnim:SetHide(true);
				end
			end
			
			local numApollo = 0;
			for i, v in pairs(Teams) do
				if(v:GetProjectCount(apolloProj) == 1) then
					numApollo = numApollo + 1;
				end
			end
			Controls.SpaceInfo:LocalizeAndSetText("TXT_KEY_VP_DIPLO_PROJECT_PLAYERS_COMPLETE", numApollo, Locale.ConvertTextKey("TXT_KEY_PROJECT_APOLLO_PROGRAM"));
		end
	else
		Controls.TechBox:SetHide(true);
	end
end


----------------------------------------------------------------
----------------------------------------------------------------
function SetProjectValue( sProject, iTeam, controlTable, controlTag )

	local white = {x = 1, y = 1, z = 1, w = 1};
	local proj = GameInfoTypes[sProject];
	local vProj = GameInfo.Project_VictoryThresholds( "ProjectType = '" .. sProject .. "'" )();
	
	if( proj ~= -1 and vProj ~= -1 ) then
		local numBuilt = Teams[ iTeam ]:GetProjectCount( proj );
		local count = math.min( vProj.Threshold, numBuilt );
		
		if( count > 0 ) then
			for i = 1, count do
				local control = controlTag .. tostring( i );
				controlTable[ control ]:SetColor( white );
			end
		end
	end
end 


----------------------------------------------------------------
----------------------------------------------------------------
function PopulateDiplomatic()

	if(PreGame.IsVictory(GameInfo.Victories["VICTORY_DIPLOMATIC"].ID))then
		local UNHome = nil;
		for i, v in pairs(Teams) do
			if(v:IsHomeOfUnitedNations()) then
				UNHome = v;
				break;
			end
		end

		if(UNHome ~= nil) then
			Controls.UNIcon:SetHide(false);
			Controls.UNCivFrame:SetHide(false);
			
			local pPlayer = Players[UNHome:GetLeaderID()];
			-- Set Civ Icon
			SetCivIcon(pPlayer, 45, Controls.UNCiv, Controls.UNCivFrame, Controls.UNCivOut,
					   not pPlayer:IsAlive() or Teams[pPlayer:GetTeam()]:GetLiberatedByTeam() ~= -1,
					   Controls.UNIconBG, Controls.UNIconShadow);
			
			local strPlayer = "";
			local pPlayer = Players[UNHome:GetLeaderID()];
			local myCivType = pPlayer:GetCivilizationType(); 
			local myCivInfo = GameInfo.Civilizations[myCivType];

			if(pPlayer:GetNickName() ~= "" and Game:IsNetworkMultiPlayer()) then
				strPlayer = pPlayer:GetNickName();
			elseif(pPlayer:GetID() == Game.GetActivePlayer()) then
				if(PreGame.GetCivilizationShortDescription(pPlayer:GetID()) ~= "") then
					strPlayer = PreGame.GetCivilizationShortDescription(pPlayer:GetID());
				else
					strPlayer = Locale.ConvertTextKey(myCivInfo.ShortDescription);
				end
			else
				strPlayer = Locale.ConvertTextKey(myCivInfo.ShortDescription);
			end
			
			TruncateString(Controls.UNInfo, 200, strPlayer); 
			strPlayer = Controls.UNInfo:GetText();
			Controls.UNInfo:LocalizeAndSetText("TXT_KEY_VP_DIPLO_PROJECT_BUILT_BY", strPlayer, Locale.ConvertTextKey("TXT_KEY_BUILDING_UNITED_NATIONS"));
		else
			local tintColor = {x = 1, y = 1, z = 1, w = 0.25};
			Controls.UNIcon:SetHide(true);
			--Controls.UNIcon:SetColor(tintColor);
			--Controls.UNIconFrame:SetColor(tintColor);
			Controls.UNCivFrame:SetHide(true);
			Controls.UNInfo:LocalizeAndSetText("TXT_KEY_VP_DIPLO_PROJECT_BUILT_BY", Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY"), Locale.ConvertTextKey("TXT_KEY_BUILDING_UNITED_NATIONS"));
		end
		
		-- Set Votes
		local totalVotes = 0;
		local curTeam = Game.GetActiveTeam()
		for i, v in pairs(Teams) do
			if(v:IsAlive() and not v:IsBarbarian()) then
				totalVotes = totalVotes + 1;
			end
		end		
		
		if(UNHome ~= nil) then
			totalVotes = totalVotes + 1;
		end
				
		Controls.VotesHave:SetText(Teams[curTeam]:GetTotalProjectedVotes());
		Controls.VotesTotal:SetText(totalVotes);
		Controls.VotesNeeded:SetText(Game.GetVotesNeededForDiploVictory());
	else
		Controls.DiploBox:SetHide(true);
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateCultural()
	g_CultureIM:ResetInstances();
	g_CultureList = {};	

	if(PreGame.IsVictory(GameInfo.Victories["VICTORY_CULTURAL"].ID))then
		local pPlayer = Players[Game.GetActivePlayer()];
		local numBranchesRequiredForUtopia = GameInfo.Projects["PROJECT_UTOPIA_PROJECT"].CultureBranchesRequired;

		g_CultureList = PopulateCivsCulture(pPlayer, g_CultureList, g_CultureIM);
	
		local proj = GameInfoTypes["PROJECT_UTOPIA_PROJECT"];
		if(Teams[pPlayer:GetTeam()]:GetProjectCount(proj) > 0)then
			Controls.Utopia:SetColor( {x=1, y=1, z=1, w=1 } );
		end
		
		local maxPolicies = 0;
		local leadAI = nil;
		for i, v in pairs(Players) do
			if(not v:IsMinorCiv() and v:IsAlive() and (leadAI == nil or v:GetNumPolicyBranchesFinished() > maxPolicies) and i ~= Game.GetActivePlayer()) then
				leadAI = v;
				maxPolicies = v:GetNumPolicyBranchesFinished();
			end
		end
		
		local strCiv = "";
		local myCivType = leadAI:GetCivilizationType(); 
		local myCivInfo = GameInfo.Civilizations[myCivType];

		if (Teams[leadAI:GetTeam()]:IsHasMet(Game.GetActiveTeam()) or Game:IsNetworkMultiPlayer()) then
			if(leadAI:GetNickName() ~= "" and Game:IsNetworkMultiPlayer()) then
				strCiv = pPlayer:GetNickName();
			else
				strCiv = Locale.ConvertTextKey(myCivInfo.ShortDescription);
			end
		else
			strCiv = Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN");
		end
		
		TruncateString(Controls.CultureLabel, 200, strCiv); 
		strCiv = Controls.CultureLabel:GetText();
		Controls.CultureLabel:SetText(Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_SOCIAL_POLICIES", strCiv, leadAI:GetNumPolicyBranchesFinished(), numBranchesRequiredForUtopia));
	else
		Controls.CultureBox:SetHide(true);
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function SetupScreen()	
	-- Title Icon
	SimpleCivIconHookup( Game.GetActivePlayer(), 64, Controls.Icon ); 
	
	-- Set Remaining Turns
	local remainingTurns = Game.GetMaxTurns() - Game.GetElapsedGameTurns();
	if remainingTurns < 0 then
		remainingTurns = 0;
	end
	Controls.RemainingTurns:SetText(remainingTurns);
	
	-- Set Player Score
	PopulateScoreBreakdown();
	
	-- Populate Victories
	PopulateDomination();
	PopulateSpaceRace();
	PopulateDiplomatic();
	PopulateCultural();
	
	-- Hide Details Screens
	Controls.CultureScreen:SetHide(true);
	
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateScoreScreen()
	g_ScoreIM:ResetInstances();
	g_ScoreList = {};
	
	local sortedPlayerList = {};
	-- Loop through all the civs the active player knows
	for iPlayerLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pPlayer = Players[iPlayerLoop];
		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			table.insert(sortedPlayerList, iPlayerLoop);			
		end
	end
	
	table.sort(sortedPlayerList, function(a, b) return Players[b]:GetScore() < Players[a]:GetScore() end);
	
	for i, v in ipairs(sortedPlayerList) do	
		local pPlayer = Players[v];
		
		-- Create Instance
		local controlTable = g_ScoreIM:GetInstance();
		g_ScoreList[i] = controlTable;
		
		-- Set Leader Icon
		SetCivLeader(pPlayer, 64, controlTable.Portrait);
	
		-- Set Civ Name
		SetCivName(pPlayer, i, controlTable.Score, PreGame.IsMultiplayerGame(), 730);
		controlTable.Name:SetText(controlTable.Score:GetText());
		
		-- Set Civ Icon
		SetCivIcon(pPlayer, 64, controlTable.Icon, nil, controlTable.IconOut, not pPlayer:IsAlive(), 
				   controlTable.CivIconBG, controlTable.CivIconShadow);
		
		-- Set Civ Score
		controlTable.Score:SetText(pPlayer:GetScore());
	end	
	
	Controls.ScoreStack:CalculateSize();
	Controls.ScoreStack:ReprocessAnchoring();
	Controls.ScoreScrollPanel:CalculateInternalSize();
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateSpaceRaceScreen()
	g_TechIM:ResetInstances();
	g_TechList = {};
	
	local numTechs = 0;
	local white = {x = 1, y = 1, z = 1, w = 1};
	
	local apolloProj = GameInfoTypes["PROJECT_APOLLO_PROGRAM"];
	if(apolloProj ~= -1) then
		local sortedPlayerList = {};
		-- Loop through all the civs the active player knows
		for iPlayerLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
			local pPlayer = Players[iPlayerLoop];
			if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
				table.insert(sortedPlayerList, iPlayerLoop);			
			end
		end
		
		table.sort(sortedPlayerList, CompareSpaceRace);
	
		for i, v in ipairs(sortedPlayerList) do	
			local pPlayer = Players[v];
			local pTeam = pPlayer:GetTeam();
			
			-- Create Instance
			local controlTable = g_TechIM:GetInstance();
			g_TechList[i] = controlTable;
	
			-- Set Civ Name
			SetCivName(pPlayer, i, controlTable.Name, true, controlTable.Civ:GetSizeX() - controlTable.CivIconBG:GetSizeX());
			
			-- Set Civ Icon
			SetCivIcon(pPlayer, 45, controlTable.Icon, nil, controlTable.IconOut, not pPlayer:IsAlive(),
					   controlTable.CivIconBG, controlTable.CivIconShadow);
			
			-- Fill in Apollo Project
			if(Teams[pTeam]:GetProjectCount(apolloProj) == 1) then
				controlTable.ApolloIcon:SetColor(white);
				
				SetProjectValue("PROJECT_SS_BOOSTER", pTeam, controlTable, "Booster");
				SetProjectValue("PROJECT_SS_COCKPIT", pTeam, controlTable, "Cockpit");
				SetProjectValue("PROJECT_SS_STASIS_CHAMBER", pTeam, controlTable, "Chamber");
				SetProjectValue("PROJECT_SS_ENGINE", pTeam, controlTable, "Engine");
			end
		end	
	end
	
	Controls.ScrollPanel:CalculateInternalSize();
end

----------------------------------------------------------------
----------------------------------------------------------------
function CompareSpaceRace(a, b)
	local playerA = Players[a];
	local playerB = Players[b];
	local pTeamA = Teams[ playerA:GetTeam() ];
	local pTeamB = Teams[ playerB:GetTeam() ];
	local apolloA = pTeamA:GetProjectCount(apolloProj) == 1;
	local apolloB = pTeamB:GetProjectCount(apolloProj) == 1;
	
	if(apolloA) then
		if(apolloB)then
			--Add up parts
			local partsA = 0;
			local partsB = 0;
			local proj = GameInfoTypes["PROJECT_SS_BOOSTER"];
			if(proj ~= -1) then
				partsA = partsA + pTeamA:GetProjectCount(proj);
				partsB = partsB + pTeamB:GetProjectCount(proj);
			end
			
			proj = GameInfoTypes["PROJECT_SS_COCKPIT"];
			if(proj ~= -1) then
				partsA = partsA + pTeamA:GetProjectCount(proj);
				partsB = partsB + pTeamB:GetProjectCount(proj);
			end
			
			proj = GameInfoTypes["PROJECT_SS_STASIS_CHAMBER"];
			if(proj ~= -1) then
				partsA = partsA + pTeamA:GetProjectCount(proj);
				partsB = partsB + pTeamB:GetProjectCount(proj);
			end
			
			proj = GameInfoTypes["PROJECT_SS_ENGINE"];
			if(proj ~= -1) then
				partsA = partsA + pTeamA:GetProjectCount(proj);
				partsB = partsB + pTeamB:GetProjectCount(proj);
			end
			
			return partsB < partsA;
		else
			return true;
		end
	elseif(apolloB)then
		return false;
	else
		return false;
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateDiploScreen()
	g_DiploIM:ResetInstances();
	g_DiploList = {};
	
	local numDiplo = 0;
	local tintColor = {x = 1, y = 1, z = 1, w = 0.25};
	
	local iActivePlayer = Game.GetActivePlayer();
	local iActiveTeam = Players[iActivePlayer]:GetTeam();
	
	local sortedPlayerList = {};
	-- Loop through all the civs the active player knows
	for iPlayerLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pPlayer = Players[iPlayerLoop];
		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			table.insert(sortedPlayerList, iPlayerLoop);			
		end
	end
	
	table.sort(sortedPlayerList, function(a, b) return Teams[Players[b]:GetTeam()]:GetTotalProjectedVotes() < 
													   Teams[Players[a]:GetTeam()]:GetTotalProjectedVotes() end );

	for i, v in ipairs(sortedPlayerList) do	
		local pPlayer = Players[v];
		local iTeam = pPlayer:GetTeam();
		local pTeam = Teams[iTeam];
		local iPlayerLoop = pPlayer:GetID();
		local iLeader = pTeam:GetLeaderID();
		local pLeader = Players[iLeader];

		-- Create Instance
		numDiplo = numDiplo + 1;
		local controlTable = g_DiploIM:GetInstance();
		g_DiploList[numDiplo] = controlTable;

		-- Set Civ Number
		controlTable.Name:SetText( Locale.ConvertTextKey("TXT_KEY_NUMBERING_FORMAT", numDiplo) );
		
		-- Set Civ Icon
		SetCivIcon(pPlayer, 45, controlTable.Icon, controlTable.IconFrame, controlTable.IconOut,
				    not pPlayer:IsAlive() or Teams[iTeam]:GetLiberatedByTeam() ~= -1,
				    controlTable.CivIconBG, controlTable.CivIconShadow);
		
		-- Alternate Colors
		if(numDiplo % 2 == 0) then
			controlTable.Civ:SetColor(tintColor);
		end
		
		-- UN Icon
		controlTable.UNIcon:SetHide(not pTeam:IsHomeOfUnitedNations());		
		
		-- Show the team leader's name instead of this player's name to make the voting more clear.
		-- Usually the leader will be the same anyways.
		local strLeaderShortDesc = pLeader:GetCivilizationShortDescriptionKey();
		
		-- Populate name lists for tooltips for the active player
		local strCivVotesList = " ";
		local strMinorVotesList = " ";
		local strLibCityStateVotesList = " ";
		for iTeamLoop = 0, GameDefines.MAX_CIV_TEAMS - 1 do
			local pTeamLoop = Teams[iTeamLoop];
			if (iTeamLoop ~= iTeam and pTeamLoop:IsAlive() and not pTeamLoop:IsBarbarian()) then
				-- Only include the names of players which the active player has met
				if (Teams[iActiveTeam] ~= nil and Teams[iActiveTeam]:IsHasMet(iTeamLoop)) then
					local iLeaderLoop = pTeamLoop:GetLeaderID();
					if (Players[iLeaderLoop] ~= nil) then
						local pLeaderLoop = Players[iLeaderLoop];
						local strLeaderLoopShortDesc = Locale.ConvertTextKey(pLeaderLoop:GetCivilizationShortDescriptionKey());
						
						-- Minor that will vote for us
						if (pLeaderLoop:IsMinorCiv() and pTeamLoop:GetTeamVotingForInDiplo() == iTeam) then
							-- Liberated
							if (pTeamLoop:GetLiberatedByTeam() == iTeam) then
								if (strLibCityStateVotesList ~= " ") then
									strLibCityStateVotesList = strLibCityStateVotesList .. ", ";
								end
								strLibCityStateVotesList = strLibCityStateVotesList .. strLeaderLoopShortDesc;
							-- Ally
							else
								if (strMinorVotesList ~= " ") then
									strMinorVotesList = strMinorVotesList .. ", ";
								end
								strMinorVotesList = strMinorVotesList .. strLeaderLoopShortDesc;
							end
						-- Major civ that voted for us last time
						elseif (not pLeaderLoop:IsMinorCiv() and Game.GetPreviousVoteCast(iTeamLoop) == iTeam) then
							if (strCivVotesList ~= " ") then
								strCivVotesList = strCivVotesList .. ", ";
							end
							strCivVotesList = strCivVotesList .. strLeaderLoopShortDesc;
						end
					end
				end
			end
		end				
		
		local bShowToolTips = (Teams[iActiveTeam]:IsHasMet(iTeam) and pTeam:IsAlive());
		
		-- Other Civ Votes
		local iCivVotes = pTeam:GetProjectedVotesFromCivs();
		controlTable.CivVotes:SetText(iCivVotes);
		controlTable.CivVotes:EnableToolTip(false);
		if (iCivVotes > 0 and strCivVotesList ~= " " and bShowToolTips) then
			local strTT = Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_SELF_VOTES_TT_ALT", strLeaderShortDesc) .. strCivVotesList;
			controlTable.CivVotes:EnableToolTip(true);
			controlTable.CivVotes:SetToolTipString(strTT);
		end
		
		-- CS Ally Votes
		local iMinorVotes = pTeam:GetProjectedVotesFromMinorAllies();
		controlTable.MinorVotes:SetText(iMinorVotes);
		controlTable.MinorVotes:EnableToolTip(false);
		if (iMinorVotes > 0 and strMinorVotesList ~= " " and bShowToolTips) then
			local strTT = Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_CS_VOTES_TT_ALT", strLeaderShortDesc) .. strMinorVotesList;
			controlTable.MinorVotes:EnableToolTip(true);
			controlTable.MinorVotes:SetToolTipString(strTT);
		end
		
		-- Liberated CS Votes
		local iLibCityStateVotes = pTeam:GetProjectedVotesFromLiberatedMinors();
		controlTable.LiberatedCSVotes:SetText(iLibCityStateVotes);
		controlTable.LiberatedCSVotes:EnableToolTip(false);
		if (iLibCityStateVotes > 0 and strLibCityStateVotesList ~= " " and bShowToolTips) then	
			local strTT = Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_LIBERATED_VOTES_TT_ALT", strLeaderShortDesc) .. strLibCityStateVotesList;
			controlTable.LiberatedCSVotes:EnableToolTip(true);
			controlTable.LiberatedCSVotes:SetToolTipString(strTT);
		end
		
		-- Last Vote
		local kiNoTeam = -1;
		local kiNoPlayer = -1;
		local iPreviousVoteCast = Game.GetPreviousVoteCast(iTeam);
		controlTable.LastVoteCiv:SetHide(true);
		if (iPreviousVoteCast ~= kiNoTeam and Teams[iPreviousVoteCast] ~= nil) then
			local iLastVoteLeader = Teams[iPreviousVoteCast]:GetLeaderID();
			if (iLastVoteLeader ~= kiNoPlayer) then
				controlTable.LastVoteCiv:SetHide(false);
				CivIconHookup(iLastVoteLeader, 32, controlTable.LastVoteCivIcon, controlTable.LastVoteCivIconBG, controlTable.LastVoteCivIconShadow, false, true);
				local pLastVoteLeader = Players[iLastVoteLeader];
				local strLastVoteLeader = pLastVoteLeader:GetCivilizationShortDescriptionKey();
				
				-- Tooltip
				controlTable.LastVoteCivIcon:EnableToolTip(false);
				controlTable.LastVoteCivIconBG:EnableToolTip(false);
				controlTable.LastVoteCivIconShadow:EnableToolTip(false);
				if (not pTeam:IsHuman() and bShowToolTips) then
					local iApproach = Players[iActivePlayer]:GetApproachTowardsUsGuess(iLeader);
					local strMoodText = "TXT_KEY_EMOTIONLESS";
					if (Teams[iActiveTeam]:IsAtWar(iTeam)) then
						strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_WAR";
					elseif (Players[iLeader]:IsDenouncingPlayer(iActivePlayer)) then
						strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_DENOUNCING";	
					else
						if( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_WAR ) then
							strMoodText = "TXT_KEY_WAR_CAPS";
						elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_HOSTILE ) then
							strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_HOSTILE";
						elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_GUARDED ) then
							strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_GUARDED";
						elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_AFRAID ) then
							strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_AFRAID";
						elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY ) then
							strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_FRIENDLY";
						elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_NEUTRAL ) then
							strMoodText = "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_NEUTRAL";
						end
					end
					
					controlTable.LastVoteCivIcon:EnableToolTip(true);
					controlTable.LastVoteCivIconBG:EnableToolTip(true);
					controlTable.LastVoteCivIconShadow:EnableToolTip(true);
					controlTable.LastVoteCivIcon:LocalizeAndSetToolTip("TXT_KEY_VP_DIPLO_LIBERATED_CIV_TT_ALT", strLeaderShortDesc, strLastVoteLeader, strMoodText);
					controlTable.LastVoteCivIconBG:LocalizeAndSetToolTip("TXT_KEY_VP_DIPLO_LIBERATED_CIV_TT_ALT", strLeaderShortDesc, strLastVoteLeader, strMoodText);
					controlTable.LastVoteCivIconShadow:LocalizeAndSetToolTip("TXT_KEY_VP_DIPLO_LIBERATED_CIV_TT_ALT", strLeaderShortDesc, strLastVoteLeader, strMoodText);
				end
			end
		end
		
		-- Total Projected Votes
		local iProjectedVotes = pTeam:GetTotalProjectedVotes();
		controlTable.ProjectedVotes:SetText(iProjectedVotes);
		controlTable.ProjectedVotes:EnableToolTip(false);
		if (bShowToolTips) then
			local strProjVotesTT = "";
			strProjVotesTT = strProjVotesTT .. Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_MY_VOTES_TT_SUMMARY_ALT", strLeaderShortDesc, iProjectedVotes);
			strProjVotesTT = strProjVotesTT .. "[NEWLINE][NEWLINE]";
			strProjVotesTT = strProjVotesTT .. Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_MY_VOTES_TT_CIVS_ALT", strLeaderShortDesc, iCivVotes);
			strProjVotesTT = strProjVotesTT .. "[NEWLINE][NEWLINE]";
			strProjVotesTT = strProjVotesTT .. Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_MY_VOTES_TT_CITYSTATES_ALT", strLeaderShortDesc, iMinorVotes + iLibCityStateVotes);
			if (pTeam:IsHomeOfUnitedNations()) then
				strProjVotesTT = strProjVotesTT .. "[NEWLINE][NEWLINE]";
				strProjVotesTT = strProjVotesTT .. Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_MY_VOTES_TT_UN_ALT", strLeaderShortDesc);
			end
			controlTable.ProjectedVotes:EnableToolTip(true);
			controlTable.ProjectedVotes:LocalizeAndSetToolTip(strProjVotesTT);
		end
	end
	
	local totalVotes = 0;
	for i, v in pairs(Teams) do
	    local iLeader = v:GetLeaderID();
	    if( iLeader ~= -1 ) then
			local curPlayer = Players[v:GetLeaderID()];
			if(v:IsAlive() and not v:IsBarbarian()) then
				totalVotes = totalVotes + 1;				
				if(v:IsHomeOfUnitedNations()) then
					totalVotes = totalVotes + 1;
				end
			end
		end
	end
		
	Controls.TotalDiploVotes:SetText(Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_VOTES").." "..totalVotes);
	Controls.NeededVotes:SetText(Locale.ConvertTextKey("TXT_KEY_VP_DIPLO_VOTES_NEEDED").." "..Game.GetVotesNeededForDiploVictory());
	Controls.DiploScrollPanel:CalculateInternalSize();
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateCultureScreen()
	for i, v in pairs(g_CultureItemIMList) do
		v:ResetInstances();
	end
	g_CultureRowsIM:ResetInstances();
	
	g_CultureRowList = {};
	g_CultureItemList = {};
	g_CultureItemIMList = {};
	
	local curRow = nil;
	local numRows = 0;
	local curItemIM = nil;
	local numItemIM = 0;
	local numBranchesRequiredForUtopia = GameInfo.Projects["PROJECT_UTOPIA_PROJECT"].CultureBranchesRequired;

	local sortedPlayerList = {};
	-- Loop through all the civs the active player knows
	for iPlayerLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pPlayer = Players[iPlayerLoop];
		if(not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive()) then
			table.insert(sortedPlayerList, iPlayerLoop);			
		end
	end
	
	table.sort(sortedPlayerList, function(a, b) return Players[b]:GetNumPolicyBranchesFinished() < 
													   Players[a]:GetNumPolicyBranchesFinished() end );

	for i, v in ipairs(sortedPlayerList) do	
		local pPlayer = Players[v];
	
		-- Populate Cultrue Icons
		local controlTable = g_CultureRowsIM:GetInstance();
		g_CultureRowList[i] = controlTable;
		
		numItemIM = numItemIM + 1;
		curItemIM = InstanceManager:new( "CultureItem", "Item", controlTable.CultureStack );
		g_CultureItemIMList[numItemIM] = curItemIM;
		
		g_CultureItemList = PopulateCivsCulture(pPlayer, g_CultureItemList, curItemIM);
		curItemIM = nil;
		
		local proj = GameInfoTypes["PROJECT_UTOPIA_PROJECT"];
		if(Teams[pPlayer:GetTeam()]:GetProjectCount(proj) > 0)then
			controlTable.Utopia:SetColor( {x=1, y=1, z=1, w=1 } );
		end
		
		-- Set Civ Icon
		SetCivIcon(pPlayer, 45, controlTable.Icon, nil, controlTable.IconOut,  not pPlayer:IsAlive(),
				   controlTable.CivIconBG, controlTable.CivIconShadow);
		
		-- Set Civ Name
		SetCivName(pPlayer, i, controlTable.Name, true, controlTable.Civ:GetSizeX() - controlTable.CivIconBG:GetSizeX());
	end
	
	Controls.CultureCivs:CalculateSize();
	Controls.CultureCivs:ReprocessAnchoring();
	Controls.CultureScrollPanel:CalculateInternalSize();
end

----------------------------------------------------------------
----------------------------------------------------------------
function PopulateCivsCulture(pPlayer, list, cultureMgr) 
	local numPoliciesFinished = pPlayer:GetNumPolicyBranchesFinished();
	local numBranchesRequiredForUtopia = GameInfo.Projects["PROJECT_UTOPIA_PROJECT"].CultureBranchesRequired;
	for i = 1, numBranchesRequiredForUtopia do
		local controlTable = cultureMgr:GetInstance();
		list[i] = controlTable;
		
		if(i <= numPoliciesFinished) then
			controlTable.Active:SetHide(false);
		end
	end
	
	local policiesFound = 1;
	for row in GameInfo.PolicyBranchTypes() do
		if(pPlayer:IsPolicyBranchFinished(row.ID)) then
			list[policiesFound].Item:SetToolTipString( Locale.ConvertTextKey(row.Description));
			policiesFound = policiesFound + 1;
		end
	end
	
	return list;
end

function SetCivLeader(pPlayer, iconSize, controlTable)
	-- Use the Civilization_Leaders table to cross reference from this civ to the Leaders table
	local pTeam = Teams[pPlayer:GetTeam()];
	if (pTeam:IsHasMet(Game.GetActiveTeam()) or Game:IsNetworkMultiPlayer()) then
		local leader = GameInfo.Leaders[pPlayer:GetLeaderType()];
		local leaderDescription = leader.Description;

		IconHookup( leader.PortraitIndex, iconSize, leader.IconAtlas, controlTable );
	else
		IconHookup( 22, iconSize, "LEADER_ATLAS", controlTable );
	end
end
----------------------------------------------------------------
----------------------------------------------------------------
function SetCivName(pPlayer, number, controlTable, truncate, controlSize)
	if(truncate == nil)then
		truncate = false;
	end
	
	-- Set Text
	local strPlayer = "";
	local strCiv = "";
	local myCivType = pPlayer:GetCivilizationType(); 
	local myCivInfo = GameInfo.Civilizations[myCivType];

	if(pPlayer:GetNickName() ~= "" and Game:IsNetworkMultiPlayer()) then
		strPlayer = pPlayer:GetNickName();
		strCiv = myCivInfo.ShortDescription;
	elseif(pPlayer:GetID() == Game.GetActivePlayer()) then
		if(PreGame.GetCivilizationShortDescription(pPlayer:GetID()) ~= "") then
			strPlayer = "TXT_KEY_POP_VOTE_RESULTS_YOU";
			strCiv = PreGame.GetCivilizationShortDescription(pPlayer:GetID());
		else
			strPlayer = "TXT_KEY_POP_VOTE_RESULTS_YOU";
			strCiv = myCivInfo.ShortDescription;
		end
	else
		strPlayer = pPlayer:GetNameKey();
		strCiv = myCivInfo.ShortDescription;
	end
	
	local pTeam = Teams[pPlayer:GetTeam()];
	if (pTeam:IsHasMet(Game.GetActiveTeam()) or Game:IsNetworkMultiPlayer()) then
		if(truncate)then
			local displayText = Locale.ConvertTextKey("TXT_KEY_NUMBERING_FORMAT", number) .. " " .. Locale.ConvertTextKey( "TXT_KEY_RANDOM_LEADER_CIV", strPlayer, strCiv );
			TruncateString(controlTable, controlSize, displayText);
		else
			controlTable:SetText( Locale.ConvertTextKey("TXT_KEY_NUMBERING_FORMAT", number) .. " " .. Locale.ConvertTextKey( "TXT_KEY_RANDOM_LEADER_CIV", strPlayer, strCiv ) );
		end
	else
		if(truncate)then
			local displayText = Locale.ConvertTextKey("TXT_KEY_NUMBERING_FORMAT", number) .. " " .. Locale.ConvertTextKey( "TXT_KEY_MISC_UNKNOWN");
			TruncateString(controlTable, controlSize, displayText);
		else
			controlTable:SetText( Locale.ConvertTextKey("TXT_KEY_NUMBERING_FORMAT", number) .. " " .. Locale.ConvertTextKey( "TXT_KEY_MISC_UNKNOWN"));
		end
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function SetCivIcon(pPlayer, iconSize, controlTable, controlTableTT, controlLost, lostCondition, controlBG, controlShadow)
	local iPlayer = pPlayer:GetID();
	-- Set Civ Icon
	local pTeam = Teams[pPlayer:GetTeam()];
	if (pTeam:IsHasMet(Game.GetActiveTeam()) or Game:IsNetworkMultiPlayer()) then
		CivIconHookup( iPlayer, iconSize, controlTable, controlBG, controlShadow, false, true );
		if(controlTableTT ~= nil) then
			if(Game:IsNetworkMultiPlayer() and pPlayer:GetNickName() ~= "") then
				controlTableTT:SetToolTipString(pPlayer:GetNickName());
			elseif(iPlayer == Game.GetActivePlayer()) then
				controlTableTT:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_POP_VOTE_RESULTS_YOU" ));
			else
				local myCivType = pPlayer:GetCivilizationType();
				local myCivInfo = GameInfo.Civilizations[myCivType];
				controlTableTT:SetToolTipString(Locale.ConvertTextKey(myCivInfo.ShortDescription));
			end
		end
	else
		CivIconHookup(-1, iconSize, controlTable, controlBG, controlShadow, false, true );
		if(controlTableTT ~= nil) then
			controlTableTT:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_MISC_UNKNOWN"));
		end
	end
	
	-- X out and gray any icons of civs who have lost capitals
	if(lostCondition and controlLost ~= nil) then
		local darken = {x = 1, y = 1, z = 1, w = 0.25};
		controlLost:SetHide(false);
		controlTable:SetColor(darken);
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function DeleteScoreScreen()
	g_ScoreIM:ResetInstances();
	g_ScoreList = {};
end

----------------------------------------------------------------
----------------------------------------------------------------
function DeleteSpaceRaceScreen()
	g_TechIM:ResetInstances();
	g_TechList = {};
end

----------------------------------------------------------------
----------------------------------------------------------------
function DeleteDiploScreen()
	g_DiploIM:ResetInstances();
	g_DiploList = {};
end

----------------------------------------------------------------
----------------------------------------------------------------
function DeleteCultureScreen()
	for i, v in pairs(g_CultureItemIMList) do
		v:ResetInstances();
	end
	g_CultureRowsIM:ResetInstances();
	
	g_CultureRowList = {};
	g_CultureItemList = {};
	g_CultureItemIMList = {};
end

--------------------------------------------
--------------------------------------------
function GetPreReqs(techID)
	
	local found = false;
	for i,v in ipairs(g_TechPreReqList) do
		if(v == techID)then
			found = true;
			break;
		end
	end
	
	if(not found)then
		table.insert(g_TechPreReqList, techID);
	end
	
	for row in GameInfo.Technology_PrereqTechs{TechType = techID} do
		GetPreReqs(row.PrereqTech);
	end
end

--------------------------------------------
--------------------------------------------
function CountPreReqsAcquired()
	g_PreReqsAcquired = 0;
	local pTeam = Teams[Game.GetActiveTeam()];
	
	for i, v in pairs(g_TechPreReqList) do
		local tech = GameInfo.Technologies[v];
		if (tech ~= nil) then
			local techID = tech.ID;
		
			if(pTeam:IsHasTech(techID)) then
				g_PreReqsAcquired = g_PreReqsAcquired + 1;
			end
		end
	end
end
Events.TechAcquired.Add( CountPreReqsAcquired );

--------------------------------------------
--------------------------------------------
-- Find Tech Pre-Reqs Once
--------------------------------------------
local ApolloTech = GameInfo.Projects["PROJECT_APOLLO_PROGRAM"].TechPrereq;

GetPreReqs(ApolloTech);
CountPreReqsAcquired();


-------------------------------------------------
-- On Popup
-------------------------------------------------
function OnPopup( popupInfo )

	if( popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_VICTORY_INFO ) then
		m_PopupInfo = popupInfo;
		if( m_PopupInfo.Data1 == 1 ) then
		
        	if( ContextPtr:IsHidden() == false ) then
        	    OnBack();
            else
            	UIManager:QueuePopup( ContextPtr, PopupPriority.eUtmost );
        	end
    	else
        	UIManager:QueuePopup( ContextPtr, PopupPriority.VictoryProgress );
    	end
	end
end
Events.SerialEventGameMessagePopup.Add( OnPopup );

----------------------------------------------------------------
-- Key Down Processing
----------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if( uiMsg == KeyEvents.KeyDown )
    then
        if( wParam == Keys.VK_RETURN or wParam == Keys.VK_ESCAPE ) then
			OnBack();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );


----------------------------------------------------------------
----------------------------------------------------------------
--function OnDisplay( type, player )
	--UIManager:QueuePopup( ContextPtr, PopupPriority.VictoryProgress );
--end


----------------------------------------------------------------        
----------------------------------------------------------------        
function ShowHideHandler( bIsHide, bIsInit )
    
    if( not bIsInit ) then
        if( not bIsHide ) then
			SetupScreen();
            UI.incTurnTimerSemaphore();
        else
            UI.decTurnTimerSemaphore();
        end
    end

end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnBack);
