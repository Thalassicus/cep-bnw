/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Kino', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Ein Film, auch ein Film oder ein Film genannt, ist eine Reihe von Fotos auf einem Kunststoffstreifen, die, wenn durch einen Projektor laufen und auf einem Bildschirm gezeigt wird, schafft die Illusion von bewegten Bildern. Ein Film wird durch Fotografieren tatsächlichen Szenen mit einer Laufbildkamera geschaffen, die durch Fotografieren Zeichnungen oder Miniaturmodelle mit traditionellen Animationstechniken, mittels CGI und Computeranimation, oder durch eine Kombination einiger oder aller dieser Techniken und andere visuelle Effekte. Der Prozess des Filmemachens ist eine Kunst und eine Industrie.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Tyria Lila', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Tyria lila, auch als Königs lila, violett oder kaiserlichen Reichs Farbstoff bekannt, ist eine rötlich-violett natürlicher Farbstoff. Der Farbstoff ist ein Sekret durch die räuberischen Meeresschnecken wie Murex bekannt ist. Dieser Farbstoff wurde möglicherweise von den alten Phöniziern schon 1600 v. Chr. verwendet. Der Farbstoff wurde stark in der Antike geschätzt, weil die Farbe nicht leicht verblassen, sondern wurde heller mit Witterungs-und Sonneneinstrahlung.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Es wird die [ICON_STRENGTH] Defense jeder Militäreinheit in diesem Spielstein stationiert zu verbessern, und verursacht 20 Schaden zu benachbarten Feinde.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] Kosten [ENDCOLOR] 3 [ICON_GOLD] Gold pro Runde zu pflegen. [NEWLINE] [NEWLINE] 50% [ICON_STRENGTH] Verteidigungsstärke für jede Einheit in diesem Tile stationiert, und verursacht 20 Schaden zu benachbarten Feinde.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] Kosten [ENDCOLOR] 3 [ICON_GOLD] Gold pro Runde zu pflegen. [NEWLINE] [NEWLINE] Eine Festung ist eine besondere Verbesserung, die Verteidigungsbonus eines hex verbessert und verursacht 20 Schaden zu benachbarten Feinde. Allerdings sind diese Effekte nicht in Feindesland gelten.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Gewährt 100 [ICON_GOLD] Gold für den ersten Spieler, es zu entdecken.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Isles', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Isles', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Eine Insel ist ein Stück Unter kontinentales Land, das von Wasser umgeben ist. Sehr kleine Inseln können aufgerufen werden Inseln, Inselchen oder Schlüssel.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] +100% [COLOR_POSITIVE_TEXT] Defense [ENDCOLOR] auf dieser Fliese. [NEWLINE] [ICON_RANGE_STRENGTH] Angebote 30 [COLOR_POSITIVE_TEXT] Damage [ENDCOLOR] pro Runde an nahen Gegnern. [NEWLINE] [ICON_CULTURE] erweitert die Grenzen zu den umliegenden Fliesen. [NEWLINE] [ICON_LOCKED] Benötigt freundlich Territorium.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Nahrung: 2 [NEWLINE] [ICON_LOCKED] Benötigt: Küstenland', '', '');





UPDATE Loaded File SET Value=1, DE_DE=1 Where Type='Terrain.sql';


