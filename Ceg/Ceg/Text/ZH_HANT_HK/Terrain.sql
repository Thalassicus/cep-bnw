/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', '電影', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', '一部電影，也稱為薄膜或動態圖像，是一系列的塑料，它通過一台投影儀上運行，並在屏幕上顯示時，將創建運動圖像的錯覺條狀的靜止圖像。 A片是通過拍攝實際的場景與電影攝像機創造，利用傳統動畫技術拍攝的圖紙或微縮模型，借助於CGI和電腦動畫，或者通過一些技術及其他視覺效果或全部的組合。電影製作的過程既是一門藝術，一個行業。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', '泰爾紫', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', '泰爾紫，又稱藍紫色，紫色帝王或帝王染料，是一種紅紫色的天然染料。染料是由被稱為默克斯的掠奪性海蝸牛產生的分泌。此染料可能用古腓尼基人早在公元前1600年。染料大大珍貴的遠古時代，因為顏色不容易褪色，反而變得更加明亮與風化和陽光。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', '這將提高[ICON_STRENGTH]駐紮在這種瓷磚的任何軍事單位的防禦，並造成20點傷害到鄰近的敵人。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT]成本[ENDCOLOR] 3 [ICON_GOLD]每回合金來維持。[NEWLINE] [NEWLINE] +50％[ICON_STRENGTH]防守力量，持續駐紮在該瓷磚的任何單位，並造成20點傷害到鄰近的敵人。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT]成本[ENDCOLOR] 3 [ICON_GOLD]每回合金來維持。[NEWLINE] [NEWLINE]一個堡壘是一個特殊的改進，提高了一個十六進制的防禦加成，並造成20點傷害到鄰近的敵人。然而，這些影響並不適用於敵方領土。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', '授予100 [ICON_GOLD]黃金第一玩家去發現它。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', '群島', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', '群島', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', '一個島是任何一件是四面環水次大陸的土地。非常小的島嶼可以被稱為島嶼，珊瑚礁或鑰匙。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] 100％[COLOR_POSITIVE_TEXT]防禦ENDCOLOR]這個瓷磚[NEWLINE] [ICON_RANGE_STRENGTH]特價30 [COLOR_POSITIVE_TEXT]損傷[ENDCOLOR]每回合對附近的敵人。[NEWLINE] [ICON_CULTURE]擴展邊界附近的地磚。 [NEWLINE] [ICON_LOCKED]需要友好的疆土。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD]食物：2 [NEWLINE] [ICON_LOCKED]需要：沿海土地', '', '');





UPDATE Loaded File SET Value=1, ZH_HANT_HK=1 Where Type='Terrain.sql';


