/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Village', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Un village est un établissement humain en cluster ou de la communauté avec une population allant de quelques centaines à quelques milliers. Ces petites colonies ajouter à l''économie de votre société.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Village', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'Le village de fournir de l''or?', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Construire une amélioration de village dans un carreau d''augmenter sa production d''or.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'Le village', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'Le Village augmente la production d''une tuile par 1 or. Il n''accède pas à une ressource [NEWLINE] Technologie requise:. Piégeage [NEWLINE] Durée des travaux: 5 tours [NEWLINE] peut être construit sur: Tous les carreaux de terre, mais la glace', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] Libre Pensée [ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH] la science sur les villages. [NEWLINE] 17% Science [ICON_RESEARCH] des universités.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Construire un [LINK = IMPROVEMENT_TRADING_POST] Village [\ LINK]', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Il permettra d''augmenter la quantité de [ICON_GOLD] or fourni par cette tuile, augmentant le montant d''argent que nous aurons à dépenser!', '', '');








UPDATE LoadedFile SET Value=1, FR_FR=1 Where Type='Villages.sql';