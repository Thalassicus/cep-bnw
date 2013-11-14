function GetTutorialPopupType (PopupType)
	if (PopupType == ButtonPopupTypes.BUTTONPOPUP_CHOOSETECH) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSETECH;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_CHOOSEPRODUCTION) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSEPRODUCTION;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_CHOOSEPOLICY) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSEPOLICY;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_ECONOMIC_OVERVIEW) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_ECONOMIC_OVERVIEW;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_MILITARY_OVERVIEW) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_MILITARY_OVERVIEW;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_DIPLOMATIC_OVERVIEW;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_GREETING) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CITY_STATE_GREETING;
	elseif (PopupType == ButtonPopupTypes.BUTTONPOPUP_TECH_TREE) then
		return TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_TECH_TREE;
	end

	return TutorialButtonPopupTypes.NUM_TUTORIALBUTTONPOPUP_TYPES;
end
 
function HasTutorialPopupBeenShown (TutorialPopupType)
	return Game.GetTutorialPopupShown(TutorialPopupType);
end

function SetTutorialPopupBeenShown (TutorialPopupType)
	Game.SetTutorialPopupShown(TutorialPopupType);
end

function OpenAdvisorTutorialPopup (TutorialPopupType)

	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_TUTORIAL)) then
		return;
	end
	
	if (Game.GetTutorialLevel() < 0 and not Game.IsStaticTutorialActive()) then
		return;
	end

	if (HasTutorialPopupBeenShown(TutorialPopupType)) then
		return;
	end

	local strIDName = "";
	local eAdvisor = AdvisorTypes.NO_ADVISOR;
	local strTitleTextUntranslated = "";
	local strBodyTextUntranslated = "";

	if (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CITYSCREEN) then
		strIDName = "CITY_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_ECONOMIC;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_CITY_SCREEN_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_CITY_SCREEN_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_DIPLOTRADE) then	
		strIDName = "DIPLO_TRADE_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_FOREIGN;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_LEADER_TRADE_DIALOG_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_LEADER_TRADE_DIALOG_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSETECH) then	
		strIDName = "CHOOSE_TECH_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_SCIENCE;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_TECH_CHOOSER_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_TECH_CHOOSER_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSEPRODUCTION) then	
		strIDName = "CHOOSE_PRODUCTION_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_ECONOMIC;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_PRODUCTION_CHOOSER_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_PRODUCTION_CHOOSER_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CHOOSEPOLICY) then	
		strIDName = "CHOOSE_POLICY_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_ECONOMIC;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_SOCIAL_POLICY_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_SOCIAL_POLICY_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_ECONOMIC_OVERVIEW) then	
		strIDName = "ECONOMIC_OVERVIEW_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_ECONOMIC;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_ECONOMIC_OVERVIEW_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_ECONOMIC_OVERVIEW_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_MILITARY_OVERVIEW) then	
		strIDName = "MILITARY_OVERVIEW_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_MILITARY;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_MILITARY_OVERVIEW_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_MILITARY_OVERVIEW_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_DIPLOMATIC_OVERVIEW) then	
		strIDName = "DIPLOMATIC_OVERVIEW_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_FOREIGN;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_DIPLOMACY_OVERVIEW_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_DIPLOMACY_OVERVIEW_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_CITY_STATE_GREETING) then	
		strIDName = "CITY_STATES_INTRO";
		eAdvisor = AdvisorTypes.ADVISOR_FOREIGN;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_CITY_STATES_INTRO_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_CITY_STATES_INTRO_BODY";
	elseif (TutorialPopupType == TutorialButtonPopupTypes.TUTORIALBUTTONPOPUP_TECH_TREE) then	
		strIDName = "TECH_TREE_SCREEN";
		eAdvisor = AdvisorTypes.ADVISOR_SCIENCE;
		strTitleTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_TECH_TREE_DISPLAY";
		strBodyTextUntranslated = "TXT_KEY_ADVISOR_SCREEN_TECH_TREE_BODY";
	end

	if (strIDName == "") then
		return;
	end

	local AdvisorDisplayShowData =
	{
		IDName = strIDName;
		Advisor = eAdvisor;
		TitleText = Locale.ConvertTextKey(strTitleTextUntranslated);
		BodyText = Locale.ConvertTextKey(strBodyTextUntranslated);
		ActivateButtonText = "";
		Modal = true;
	}
	Events.AdvisorDisplayShow(AdvisorDisplayShowData);
	SetTutorialPopupBeenShown(TutorialPopupType);

	--local pAdvisorControl = ContextPtr:LookUpControl( "/InGame/WorldView/Advisors" );
	
end

function CloseAdvisorTutorialPopup (TutorialPopupType)
    if (TutorialPopupType ~= TutorialButtonPopupTypes.NUM_TUTORIALBUTTONPOPUP_TYPES) then
        --@was: --pAdvisorControl = ContextPtr:LookUpControl( "/InGame/WorldView/Advisors" );
        pAdvisorControl = pAdvisorControl or ContextPtr:LookUpControl( "/InGame/WorldView/Advisors" );
        if (pAdvisorControl) then
            UIManager:PopModal(pAdvisorControl);    
            --print("Found AdvisorControl");            
        else
            print("AdvisorControl could not be found");
        end
        Events.AdvisorDisplayHide();
    end
end

function OpenAdvisorPopup (PopupType)
	OpenAdvisorTutorialPopup(GetTutorialPopupType(PopupType));
end

function CloseAdvisorPopup (PopupType)
	CloseAdvisorTutorialPopup(GetTutorialPopupType(PopupType));
end

local pAdvisorControl = ContextPtr:LookUpControl( "/InGame/WorldView/Advisors" );