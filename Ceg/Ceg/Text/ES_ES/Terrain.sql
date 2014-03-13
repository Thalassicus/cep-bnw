/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Cine', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Una película, también llamada una película o cinematográfica, es una serie de imágenes fijas en una tira de plástico que, cuando se ejecuta a través de un proyector y se muestra en una pantalla, crea la ilusión de imágenes en movimiento. Una película es creado por fotografiar escenas reales con una cámara de imágenes en movimiento; fotografiando dibujos o modelos en miniatura utilizando técnicas de animación tradicionales; por medio de CGI y animación por ordenador, o por una combinación de algunos o la totalidad de estas técnicas y otros efectos visuales. El proceso de hacer cine es un arte y una industria.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Púrpura de Tiro', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Púrpura de Tiro, también conocida como púrpura real imperial tinte púrpura o imperial, es un tinte natural de color rojizo-púrpura. El tinte es una secreción producida por los caracoles de mar depredadoras conocidas como Murex. Este colorante fue posiblemente utilizado por los antiguos fenicios ya en 1600 antes de Cristo. El colorante se valoraba en gran medida en los tiempos antiguos, porque el color no se desvanecen con facilidad, pero en cambio se hizo más brillante con la intemperie y los rayos solares.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Además, mejorará la [ICON_STRENGTH] Defensa de cualquier unidad militar destinado en esta baldosa, e inflige 20 puntos de daño a los enemigos adyacentes.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] Costos [ENDCOLOR] 3 [ICON_GOLD] Oro por turno para mantener. [NEWLINE] [NEWLINE] 50% [ICON_STRENGTH] Fuerza Defensiva para cualquier unidad estacionada en este azulejo, y reparte 20 daño a los enemigos adyacentes.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] Costos [ENDCOLOR] 3 [ICON_GOLD] Oro por turno para mantener. [NEWLINE] [NEWLINE] Una fortaleza es una mejora especial que mejora la bonificación defensiva de un hexágono, y reparte 20 daño a los enemigos adyacentes. Sin embargo, estos efectos no se aplican en el territorio enemigo.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Otorga 100 [ICON_GOLD] Oro para el primer jugador en descubrirlo.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Isles', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Isles', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Una isla es cualquier pedazo de tierra sub-continental que sea rodeada por el agua. Las islas muy pequeñas pueden ser llamados islas, cayos o llaves.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] 100% [COLOR_POSITIVE_TEXT] Defensa [ENDCOLOR] en esta baldosa. [NEWLINE] [ICON_RANGE_STRENGTH] Ofertas 30 [COLOR_POSITIVE_TEXT] Daños [ENDCOLOR] por turno a los enemigos cercanos. [NEWLINE] [ICON_CULTURE] Se expande las fronteras de baldosas cercanas. [NEWLINE] [ICON_LOCKED] Requiere territorio amigo.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Alimentación: 2 [NEWLINE] [ICON_LOCKED] Requiere: Tierras Costeras', '', '');





UPDATE LoadedFile SET Value=1, ES_ES=1 Where Type='Terrain.sql';


