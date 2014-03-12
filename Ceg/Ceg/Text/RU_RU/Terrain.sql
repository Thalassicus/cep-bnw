/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Кино', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Фильм, также называется фильм или кинофильм, представляет собой серию фотографий на полосе пластика, который, при запуске через проектор и показано на экране, создает иллюзию движущихся изображений. Фильм создан путем фотографирования фактические сцены с кинокамеры; путем фотографирования рисунки или миниатюрных моделей с использованием традиционных методов анимации; с помощью CGI и компьютерной анимации, или сочетанием некоторых или всех из этих методов и других визуальных эффектов. Процесс кинопроизводства и искусство и промышленность.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Tyrian Фиолетовый', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Tyrian фиолетовый, также известный как королевский пурпур, имперской фиолетовый или имперской красителя, является красновато-фиолетовый натуральный краситель. Краситель секреции производства хищных морских улиток, известных как Murex. Этот краситель был, возможно, использовали древние финикийцы еще в 1600 г. до н.э.. Краситель очень ценили в древности, потому что цвет не так легко исчезают, а вместо этого стал ярче с выветривания и солнечного света.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Это улучшит [ICON_STRENGTH] Оборона любой военной части, расположенной в этой плитки, и наносит 20 повреждений соседних врагов.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] Затраты [ENDCOLOR] 3 [ICON_GOLD] Золото за ход в обслуживании. [NEWLINE] [NEWLINE] +50% [ICON_STRENGTH] Оборонительная Сила для любого подразделения дислоцированной в этой плитки, и наносит 20 повреждений соседних врагов.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] Затраты [ENDCOLOR] 3 [ICON_GOLD] Золото за ход в обслуживании. [NEWLINE] [NEWLINE] форт особого улучшения, что улучшает защитную премию шестнадцатеричном, и наносит 20 повреждений соседних врагов. Тем не менее, эти эффекты не применяются на территории противника.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Гранты 100 [ICON_GOLD] Золото для первого игрока, чтобы обнаружить его.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Острова', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Острова', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Остров любой кусок суб-материковой суши, окруженной водой. Очень небольшие острова можно назвать островов, рифов или ключи.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] +100% [COLOR_POSITIVE_TEXT] обороны [ENDCOLOR] на этой плитки. [NEWLINE] [ICON_RANGE_STRENGTH] Наносит 30 [COLOR_POSITIVE_TEXT] Нанесенный [ENDCOLOR] за ход ближайшим противникам [NEWLINE] [ICON_CULTURE] расширяет границы. В близлежащие плитки. [NEWLINE] [ICON_LOCKED] Требуется дружественной территории.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Еда: +2 [NEWLINE] [ICON_LOCKED] Требуется: прибрежной земли', '', '');





UPDATE Loaded File SET Value=1, RU_RU=1 Where Type='Terrain.sql';


