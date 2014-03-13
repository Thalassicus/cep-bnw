/* The sql commands and text below were formulated in the Trade tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheets/d/1JxVk5LTes7xbPz14S8uXfHVfzoEYEshk_SPRU5hiXbo/edit#gid=1651078938
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SORT_BY_TRAIT', 'Sort by Trait', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SORT_BY_CS_NAME', 'Sort by City State Name', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SORT_BY_CS_ALLY', 'Sort by City State Ally', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SORT_BY_INFLUENCE', 'Sort by Influence', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DIPLO_DISCUSS_MESSAGE_DEC_FRIENDSHIP_TT', 'Doubles income from [ICON_RESEARCH] Research Agreements with this leader.[NEWLINE][NEWLINE]An alliance promotes friendly diplomacy and deters outside aggressors. Allies may request diplomatic or economic assistance, and failure to support your ally may upset them.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DIPLO_OPEN_BORDERS_TT', 'With [COLOR_YIELD_GOLD]mutual open borders[/COLOR], both players can pass through the other''''s territory.[NEWLINE][NEWLINE](Lasts {1_Num} turns.)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DIPLO_RESCH_AGREEMENT_TT', '[ICON_GOLD] Cost: {1_cost}[NEWLINE][NEWLINE]4% of the combined research of both players adds to your [ICON_RESEARCH] Science at the end of the agreement (8% if Allied).[NEWLINE][NEWLINE](Lasts {2_turns} turns.)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_REFRESH', 'Refresh', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS', 'Trade', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_RESOURCE', '{1_iconstring} {2_resource}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_FROM', '{1_iconstring} Buy {2_resource}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_TO', '{1_iconstring} Sell {2_resource}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_DEMANDED_BY', 'Demanded By', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POSSIBLE_DEALS', '{1_iconstring} [COLOR_POSITIVE_TEXT]{2_num}[ENDCOLOR] possible {3_type}.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CIV_STATUS', '{1_status}[NEWLINE]{1_era}[NEWLINE]{2_Num} Score', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RATE', 'Rate', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CLICK_TO_TRADE', 'Click to Trade[COLOR_POSITIVE_TEXT][ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_LASTS_TURNS', 'Lasts {1_num} turns.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_EMBASSIES', 'embassies', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BORDER_DEALS', 'border deals', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESEARCH_DEALS', 'research deals', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEFENSE_PACTS', 'defense pacts', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_ALLIANCES', 'alliances', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_EMBASSY_AGREEMENT', '[COLOR_YIELD_GOLD]Embassy[ENDCOLOR][NEWLINE]Allows Open Borders, Research Agreements, and Defensive Pacts. Also reveals Capitals.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_EMBASSY_YES_TT', '[COLOR_YIELD_GOLD]Propose Embassies[ENDCOLOR][NEWLINE]Allows Open Borders, Research Agreements, and Defensive Pacts. Also reveals Capitals.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_EMBASSY_NO_TT', 'We both have embassies.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_EMBASSY_US_TT', 'We have an embassy in their capital.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_EMBASSY_THEM_TT', 'They have an embassy in our capital.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_BORDER_AGREEMENT', '[COLOR_YIELD_GOLD]Mutual Open Borders[ENDCOLOR][NEWLINE]Allows units to pass through each other''''s territory.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_BORDERS_YES_TT', '[COLOR_YIELD_GOLD]Propose mutual open borders[ENDCOLOR][NEWLINE]Allows units to pass through each other''''s territory.[NEWLINE][NEWLINE]Lasts {1_num} turns.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_BORDERS_NO_TT', 'Mutual open borders active.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_BORDERS_US_TT', 'They gave us open borders.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_BORDERS_THEM_TT', 'We gave them open borders.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_RESEARCH_AGREEMENT', '[COLOR_RESEARCH_STORED]Research Agreement[ENDCOLOR][NEWLINE]4% of the combined research of both players adds to your [ICON_RESEARCH] Science at the end of the agreement (8% if Allied).', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_RA_YES_TT', '[COLOR_RESEARCH_STORED]Propose Research Agreement[ENDCOLOR][NEWLINE]4% of the combined research of both players adds to your [ICON_RESEARCH] Science at the end of the agreement (8% if Allied).[NEWLINE][NEWLINE]Lasts {1_num} turns.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_RA_NO_TT', 'Research Agreement active.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_DEFENSIVE_PACT', '[COLOR_CITY_BROWN]Defensive Pact[ENDCOLOR][NEWLINE]If an outsider declares war on either player', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_DEFENSE_YES_TT', '[COLOR_CITY_BROWN]Propose Defensive Pact[ENDCOLOR][NEWLINE]If an outsider declares war on either player', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_DEFENSE_NO_TT', 'Defensive Pact active.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_GOLD_STORED', 'Gold Stored', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_GOLD_PROFIT', 'Gold Profit', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_ALLIANCE', '[COLOR_GREEN]Ally[ENDCOLOR][NEWLINE]Promotes friendly relations.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_ALLIANCE_YES_TT', '[COLOR_GREEN]Propose Alliance[ENDCOLOR][NEWLINE]Promotes friendly relations.[NEWLINE][NEWLINE]Lasts {1_num} turns.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_STATUS_ALLIANCE_NO_TT', 'We are allied.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_DENOUNCED_US', '[COLOR_ORANGE]They denounced us[ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_DENOUNCED_THEM', '[COLOR_ORANGE]We denounced them[ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_DENOUNCED_BOTH', '[COLOR_NEGATIVE_TEXT]We denounced them[NEWLINE]They denounced us[ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_AT_WAR_LARGE', '[COLOR_NEGATIVE_TEXT]- AT WAR -[ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DEAL_PEACE_TREATY', 'Peace Treaty', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS', 'City States', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_CITY_STATE', 'City State', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_ALLIED_WITH', 'Allied With', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_PROTECTED_BY', 'Protected By', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUESTS', 'Quest(s)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_INFLUENCE', 'Influence', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_WAR', 'War', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_GIFT_GOLD', 'Gift Gold', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_PROTECT_TT', '{1} is protected by[NEWLINE]{2}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_NO_PROTECT_TT', '{1} is protected by nobody', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_TT', '{1} has requested you to[NEWLINE]{2}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_NO_QUEST_TT', '{1} currently has no requests', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_WAR_WITH_PLAYERS', 'Fight {1_PlayerNames}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_BARBARIANS', 'Kill Barbarians', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_ROUTE', 'Construct Road', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_KILL_CAMP', 'Destroy Encampment', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_CONNECT_RESOURCE', 'Connect {1_ResourceName:textkey}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_CONSTRUCT_WONDER', 'Build {1_WonderName:textkey}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_GREAT_PERSON', 'Attract {1_UnitName:textkey}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_KILL_CITY_STATE', 'Destroy {1_CityStateName:textkey}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_FIND_PLAYER', 'Find {1_CivName:textkey}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_QUEST_FIND_NATURAL_WONDER', 'Find Natural Wonder', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_PEACE_TT', 'At war, may make peace', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_WAR_TT', 'At war, peace blocked', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DO_CS_STATUS_GIFT_INFLUENCE_TT', '{1_Num}[ICON_GOLD] for [COLOR_POSITIVE_TEXT]+{2_Num} Influence[ENDCOLOR]', '', '');






UPDATE LoadedFile SET Value=1, en_US=1 Where Type='Trade.sql';



