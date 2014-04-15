/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Films', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Un film, également appelé un film ou de cinéma, est une série d''images fixes sur une bande de plastique qui, lorsqu''il est exécuté par un projecteur et montré sur un écran, crée l''illusion d''images en mouvement. Un film est réalisé par photographier des scènes réelles avec une caméra de cinéma; en photographiant des dessins ou modèles miniatures en utilisant des techniques d''animation traditionnelles, par le biais de CGI et animation par ordinateur; ou par une combinaison de tout ou partie de ces techniques et d''autres effets visuels. Le processus du cinéma est à la fois un art et une industrie.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Tyrian pourpre', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Pourpre de Tyr, aussi connu comme colorant pourpre royal, pourpre impériale ou impériale, est un colorant naturel violet rougeâtre. Le colorant est une sécrétion produite par les escargots de mer prédateurs connus comme Murex. Ce colorant a été peut-être utilisé par les Phéniciens dès 1600 av. Le colorant a été grandement apprécié dans les temps anciens, parce que la couleur ne se fanent pas facilement, mais est devenu plus lumineux avec les intempéries et la lumière du soleil.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Il permettra d''améliorer la Défense [ICON_STRENGTH] d''une unité militaire stationnée dans cette tuile, et traite 20 points de dégâts aux ennemis adjacents.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] coûts [ENDCOLOR] 3 [ICON_GOLD] or par tour à maintenir. [NEWLINE] [NEWLINE] 50% [ICON_STRENGTH] Force de défense de toute unité stationnée dans cette tuile, et traite 20 points de dégâts aux ennemis adjacents.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] coûts [ENDCOLOR] 3 [ICON_GOLD] or par tour à maintenir. [NEWLINE] [NEWLINE] Un fort est une amélioration particulière qui améliore bonus défensif d''un hexagone, et traite 20 points de dégâts aux ennemis adjacents. Cependant, ces effets ne sont pas applicables dans le territoire ennemi.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Accorde 100 [ICON_GOLD] or pour le premier joueur à découvrir.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Isles', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Isles', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Une île est une pièce de terre sous-continentale qui est entourée par l''eau. Très petites îles peuvent être appelées îles, îlots ou des clés.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] 100% [COLOR_POSITIVE_TEXT] Défense [ENDCOLOR] sur cette tuile. [NEWLINE] [ICON_RANGE_STRENGTH] Offres 30 [COLOR_POSITIVE_TEXT] Dommages [ENDCOLOR] par tour aux ennemis proches. [NEWLINE] [ICON_CULTURE] étend les frontières de tuiles voisines. [NEWLINE] [ICON_LOCKED] Nécessite territoire ami.', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Alimentation: 2 [NEWLINE] [ICON_LOCKED] Nécessite: terres côtières', '', '');





UPDATE LoadedFile SET Value=1, FR_FR=1 Where Type='Terrain.sql';


