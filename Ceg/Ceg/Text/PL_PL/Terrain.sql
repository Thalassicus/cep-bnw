/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Kino', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Film, zwany także filmu lub filmów, to seria nieruchomych obrazów na taśmie z tworzywa sztucznego, które po uruchomieniu przez projektor i pokazane na ekranie, tworzy iluzję ruchomych obrazów. Folia jest utworzony przez fotografowanie rzeczywiste sceny z kamery filmowej, fotografując rysunków lub wzorów miniaturowych przy użyciu tradycyjnych technik animacyjnych, za pomocą interfejsu CGI i komputer animacji; lub kombinacji niektórych lub wszystkich technik i innych efektów wizualnych. Proces filmu jest zarówno sztuka i przemysł.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Tyrian Fioletowy', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Tyrian fioletowy, znany również jako królewski purpurowy, fioletowy lub imperial imperial barwnika, jest czerwono-purpurowy barwnik naturalny. Barwnik jest wydzielina produkowana przez drapieżnych ślimaków morskich, znanych jako Murex. Ten barwnik prawdopodobnie używane przez starożytnych Fenicjan już w 1600 pne. Barwnik znacznie ceniona w starożytności, ponieważ kolor nie łatwo zanikać, lecz stał się jaśniejszy z atmosferycznych i promieni słonecznych.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Poprawi on [ICON_STRENGTH] obronie jakiejkolwiek jednostki wojskowej stacjonującej w tym płytki, i zadaje 20 uszkodzeń sąsiednich wrogów.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] Koszty [ENDCOLOR] 3 [ICON_GOLD] złota na turę do utrzymania. [NEWLINE] [NEWLINE] +50% [ICON_STRENGTH] Zbiórka Siła dla każdej jednostki stacjonującej w tym Płytka i zadaje 20 uszkodzeń sąsiednich wrogów.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] Koszty [ENDCOLOR] 3 [ICON_GOLD] złota na turę do utrzymania. [NEWLINE] [NEWLINE] fort jest poprawa, że ​​poprawia specjalną premię do obrony w HEX, a zajmuje 20 uszkodzenia sąsiadujących wrogów. Jednak działania te nie mają zastosowania na terytorium wroga.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Daje 100 [ICON_GOLD] Złoto dla pierwszego gracza, aby go odkryć.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Isles', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Isles', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Wyspa jest każdy kawałek ziemi pod-kontynentalnego, który jest otoczony przez wody. Bardzo małe wyspy można nazwać Isles, Cays lub klucze.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] +100% [COLOR_POSITIVE_TEXT] Defense [ENDCOLOR] na tej płytce. [NEWLINE] [ICON_RANGE_STRENGTH] oferty 30 [COLOR_POSITIVE_TEXT] Obrażenia [ENDCOLOR] na kolei do pobliskich wrogów. [NEWLINE] [ICON_CULTURE] rozszerza granice do pobliskich płytek. [NEWLINE] [ICON_LOCKED] Wymaga terytorium przyjazne.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Jedzenie: +2 [NEWLINE] [ICON_LOCKED] Wymaga: Coastal Ziemi', '', '');





UPDATE Loaded File SET Value=1, PL_PL=1 Where Type='Terrain.sql';


