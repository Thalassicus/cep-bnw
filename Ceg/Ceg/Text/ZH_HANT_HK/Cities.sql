/* The sql commands and text below were formulated in the Cities tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=2135453389
If you make any changes be sure to update the spreadsheet also.*/

/* 一般 */
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CEP_VERSION', 'CEP的第三版。{1}', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLDEN_AGE_EFFECT', '在[ICON_GOLDEN_AGE]黃金時代的城市產生20％的產量。[NEWLINE] [ICON_FOOD] +20％的剩餘食品[NEWLINE] [ICON_PRODUCTION] +20％生產[NEWLINE] [ICON_GOLD] +20％黃金[NEWLINE] [ICON_RESEARCH] 20％科學[NEWLINE] [ICON_CULTURE] +20％文化[NEWLINE] [ICON_PEACE] +20％信仰[NEWLINE] [NEWLINE]幸福盈餘繼續增加的黃金時期計數器，而在一個黃金時代。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRADE_ROUTE_INCOME_INFO', '{1}基礎[ICON_GOLD]每路黃金[NEWLINE] {2}黃金每[ICON_CITIZEN]公民在資本[ICON_GOLD] [NEWLINE] {3} [ICON_GOLD]黃金每[ICON_CITIZEN]公民', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_MISSION_HURRY_PRODUCTION_HELP', '給出了（200 + 30 * [ICON_CITIZEN]人口）[ICON_PRODUCTION]生產城市的目前的努力。它消耗的偉大的人。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODUCTION_BUILDING_ALLOWS_WATER_ROUTES_EXTRA', '到京城[ICON_CONNECTED]公路，鐵路，或水的路由提供[ICON_GOLD]黃金[NEWLINE] [NEWLINE]到京城[ICON_CONNECTED_RAILROAD]鐵路或水路由提供25％[ICON_PRODUCTION]生產（[ COLOR_POSITIVE_TEXT]鐵路[ENDCOLOR]技術）。[NEWLINE] [NEWLINE] [COLOR_POSITIVE_TEXT]燈塔[ENDCOLOR]提供水和土地的貿易路線之間的安全連接。', '', '');
/* 建築 */
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_AMPHITHEATER', '劇院', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_AMPHITHEATER_HELP', '[ICON_CULTURE]文化：+1 [ICON_RES_SILK] [ICON_RES_COTTON] [ICON_RES_FUR] [ICON_RES_DYE] [NEWLINE] [NEWLINE]增強服裝的資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_AMPHITHEATER_PEDIA', '希臘人發明了戲劇，因為它是在西方目前已知。原來的劇院往往建在一個山坡上的露天圓形劇場。觀眾坐在長凳上切入山，而表演者在山腳下曾在一個開放的舞台。隨著時間的推移階段移動室內（特別是在與大量的惡劣天氣下的風險位置）。現代戲劇仍具有舞台和觀眾席的椅子，但它也包括先進的音響和燈光設備，樂池，以及廣泛的後台區域的道具和佈景。儘管如此，一個古老的劇場而去不會被任何東西在一個現代劇場發現（除了中場休息期間出售的食物和飲料的可能的成本）完全感到驚訝。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_AQUEDUCT_HELP', '[ICON_FOOD]食物儲存：40％[NEWLINE] [ICON_FOOD]食物：1 [ICON_RES_CITRUS] [ICON_RES_TRUFFLES] [ICON_RES_SALT] [ICON_RES_BANANA] [NEWLINE] [NEWLINE]增強異國食品。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_ARENA', '舞台', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_ARENA_PEDIA', '競技場是一個封閉的區域，通常為圓形或橢圓形，常旨在展示體育賽事。源自拉丁語harena，用來吸收血液在古競技場就像在羅馬鬥獸場特別精細/水清沙幼的派生詞[NEWLINE] [NEWLINE]阿里納斯組成的一大片空地包圍的大部分或全部由雙方分層座位觀眾。舞台的主要特點是，事件空間是最低點，從而最大限度的可見性。一個舞台通常設計為容納相當多的觀眾。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_ARMORY_HELP', '[ICON_WAR]經驗：20 [NEWLINE] [ICON_PRODUCTION]製作：10％的土地單位', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_ARSENAL_STRATEGY', '阿森納是一款中端遊戲的軍事建築，增加了城市的防禦力和生命值，使城市更加難以捕捉。城市必須擁有一個城堡，才能構建一個阿森納。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_BABYLON_WALLS_STRATEGY', '巴比倫的城牆是巴比倫獨特的建築，取代了標準的城牆。巴比倫的城牆增加了城市的防禦力和生命值（均顯著超過標準的牆。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_BARRACKS_HELP', '[ICON_WAR]經驗：10 [NEWLINE] [ICON_PRODUCTION]製作：1戰略資源', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_BAZAAR_HELP', '[ICON_TRADE]雙打奢侈品供應附近[NEWLINE] [ICON_GOLD]黃金：+2綠洲[NEWLINE] [ICON_GOLD]黃金：+2 [ICON_RES_OIL] [NEWLINE] [ICON_GOLD]黃金：2元貿易路線從這裡[NL ] [ICON_GOLD]黃金：1對奢侈品資源[NEWLINE] [NEWLINE]提高奢侈品的資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CAPITAL_BUILDING', '資本', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CAPITAL_BUILDING_PEDIA', '政府所在地是建築，建築或城市的複雜，它的一個政府行使其權力。政府所在地，通常位於首都。在一些國家，政府所在地不同於資本，如在荷蘭，其中海牙是政府所在地和阿姆斯特丹是法律上的資本荷蘭。在大多數的是同一個城市，例如莫斯科作為俄羅斯政府的首都和座位。在英國，政府所在地是倫敦，資本，或者更具體的威斯敏斯特市。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CARAVANSARY_HELP', '[ICON_TRADE]大篷車範圍：+50％[NEWLINE] [ICON_GOLD]黃金：2元大篷車從這裡[NEWLINE] [ICON_GOLD]黃金：1對奢侈品資源[NEWLINE] [NEWLINE]增強奢侈品資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CASTLE_STRATEGY', '該城堡是中世紀時代的建築從而增加了城市的防禦力和生命值。城市必須具備的牆壁前，城堡可以構造。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CINEMA', '電影院', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CINEMA_PEDIA', '電影院（或電影院在北美）是一個場地觀看電影。[NEWLINE] [NEWLINE]大多數但不是所有的電影院都是商業運作迎合普羅大眾，誰通過購買門票參加。這部電影預計與電影放映機到一個大型投影屏幕在觀眾席的前面。大多數電影院現在裝備的數字電影放映，無需創建和傳輸的物理膠片打印。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_FACTORY_HELP', '[ICON_CULTURE] 3號樓解鎖意識形態[NEWLINE] [ICON_LOCKED]需要：1 [ICON_RES_COAL]中煤', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_FLOATING_GARDENS_DESC', 'Chinampa', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_FOATING_GARDENS_STRATEGY', '該Chinampa是阿茲台克人獨特的建築，取代了水車。它增加了城市的糧食產量，如果這個城市是靠近湖泊或河流應該建。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_FLOATING_GARDENS_PEDIA', '一個Chinampa是為了增加可用於農業的土地上建造一個淡水湖一個小人工島。該湖灌溉島和為其提供新鮮的有機物質，從而導致異常肥沃的生長環境。阿茲台克人的這種形式的農業的主人，今天的“水上花園霍奇米爾科的”保持聞名。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_FORGE_HELP', '[ICON_PRODUCTION]製作：15％土地單位[NEWLINE] [ICON_PRODUCTION]製作：1 [ICON_RES_IRON] [ICON_RES_COAL] [ICON_RES_COPPER] [NEWLINE] [NEWLINE]增強礦產資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_GARDEN_STRATEGY', '該園以增加它們在城市的產生[ICON_GREAT_PEOPLE]大人們的速度。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_GRANARY_HELP', '[ICON_FOOD]城市可以買賣食品[NEWLINE] [ICON_FOOD]食物：1 [ICON_RES_WHEAT] [ICON_RES_SPICES] [ICON_RES_SUGAR] [NEWLINE] [NEWLINE]增強糧源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_GREAT_HALL', '人民大會堂', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_GREAT_HALL_PEDIA', '市政府是一個城市的行政大樓，城鎮或其他直轄市。它通常安置在城市或鎮議會，其相關的部門和員工。它也常作為市，鎮，區，縣的市長的基礎。[NEWLINE] [NEWLINE]當地政府可能會努力使用的市政廳大樓，以促進和提高社會生活質量。在許多情況下，“''市政廳''不僅作為政府職能建築，但也有各種民間文化活動設施，其中可能包括藝術展覽，舞台演出，展覽和節慶活動。作為當地政府，城市和符號市政廳有獨特的建築，以及建築可能有重大的歷史意義。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_LABORATORY_HELP', '[ICON_RESEARCH]科學：1從叢林[NEWLINE] [ICON_LOCKED]需要：公立學校', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MARKET_HELP', '[ICON_GOLD]黃金：2元貿易路線從這裡。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MILITARY_ACADEMY_HELP', '[ICON_WAR]經驗：30 [NEWLINE] [ICON_PRODUCTION]製作：20％的土地單位', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MILITARY_BASE_HELP', '[ICON_AIR]空氣傷害：-25％[NEWLINE] [ICON_URANIUM]核損害：-50％[NEWLINE] [ICON_LOCKED]需要：阿森納', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MILITARY_BASE_STRATEGY', '軍事基地是遊戲中期的建築，增加了城市的防禦力和生命值。城市必須具備一個阿森納的一個軍事基地可以構造之前。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MINT_HELP', '[ICON_GOLD]黃金：1在[ICON_RES_COPPER] [ICON_RES_SILVER] [ICON_RES_GOLD] [ICON_RES_GEMS] [NEWLINE] [NEWLINE]增強貨幣資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MUGHAL_FORT_STRATEGY', '莫臥爾堡是中世紀時代的建築，增加城市的防禦力，生命值，並提供了一些[ICON_CULTURE]文化動不動。它是印度獨特的建築，取代了城堡。飛行了解後，它提供了一個[ICON_GOLD]黃金獎金以城市為好。建築幕牆是建立莫臥兒堡的先決條件。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_PALACE', '宮', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_PALACE_PEDIA', '宮殿是一座宏偉的住所，尤其是皇家住所國家元首或其他一些高級權貴或家庭，如主教或大主教。[NEWLINE] [NEWLINE]這個詞來自拉丁語名稱Palatium派生的，用於帕拉蒂尼山，七山在羅馬的一個。在歐洲的許多地方，這個詞也適用於貴族的雄心勃勃的私人豪宅。許多歷史悠久的宮殿，現在改作其他用途，如議會，博物館，酒店或寫字樓。這個詞有時也用來描述用於公共娛樂場所或展覽一個華麗的華麗建築。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SANITATION_SYSTEM', '衛生系統', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SANITATION_SYSTEM_PEDIA', '衛生是通過預防與廢物的危害人體接觸的促進健康的衛生手段。[NEWLINE] [NEWLINE]危害可以是物理，微生物，生物或疾病的化學藥劑。預防的衛生手段可以是通過工程解決方案（如污水和廢水處理），簡單的技術（廁所，化糞池），或什至個人的衛生習慣（簡單的用肥皂洗手）。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SEAPORT_HELP', '[ICON_PRODUCTION]製作：+50％的海軍單位[NEWLINE] [ICON_PRODUCTION]製作：+1海上資源[NEWLINE] [ICON_GOLD]黃金：+1海上資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_STABLE_HELP', '[ICON_PRODUCTION]製作：為安裝單位15％[NEWLINE] [ICON_PRODUCTION]製作：1 [ICON_RES_HORSE] [ICON_RES_SHEEP] [ICON_RES_COW] [ICON_RES_DEER] [ICON_RES_IVORY] [NEWLINE] [NEWLINE]增強畜牧業資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_STABLE_STRATEGY', '的穩定增加了生產裝單元的速度，並增加了對某些資源的生產。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_STONE_WORKS_STRATEGY', '石材廠只能在附近的一個改進[ICON_RES_STONE]石或[ICON_RES_MARBLE]大理石資源城市建造。石材廠增加一個城市的[ICON_PRODUCTION]生產。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SUPERMAX_PRISON_HELP', '[ICON_SPY]間諜竊取率：-25％，在所有城市', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SUPERMAX_PRISON', '無敵監獄', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_SUPERMAX_PRISON_PEDIA', '無敵（簡稱“超設防”）是用來描述監獄，它代表保管在某些國家的監獄系統中最安全的水平內，“控制單元”的監獄，或單位名稱。我們的目標是提供長期的，獨立的住房分類為監獄系統的最高安全風險的囚犯 - “最差最差”的罪犯，如果誰對國家和國際安全構成威脅。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_TEMPLE_HELP', '[ICON_PEACE]信仰：+2 [ICON_RES_WINE] [ICON_RES_INCENSE] [NEWLINE] [NEWLINE]增強宗教資源。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_VACCINATIONS', '接種疫苗', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_VACCINATIONS_PEDIA', '疫苗是一種生物製劑，提高免疫力某種疾病。該疫苗刺激機體的免疫系統來識別病原體，破壞它，“記住”它，從而使免疫系統能更容易地識別和摧毀任何這些微生物，它後來遇到的。接種疫苗是預防傳染病的最有效的方法。[NEWLINE] [NEWLINE]人類的全球預防接種努力根除天花，並限制其他致命的疾病，如脊髓灰質炎，麻疹和破傷風。天花在16世紀與歐亞大陸接觸後殺害了估計90％美國本地人。當終於消滅於1979年，天花已經在剛剛過去的一個世紀世界範圍內殺死約300-500萬人，超過所有20世紀的戰爭相結合。天花是，有關的疫苗生產在1796年的第一個疾病。免疫接種被稱為接種疫苗，因為它影響牛（拉丁語：VACCA  - 牛）病毒衍生的。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_WALLS_STRATEGY', '牆壁增加城市的防禦力量和生命值，使城市更加難以捕捉。牆壁是位於沿文明前沿城市相當有用。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_WAREHOUSE', '倉庫', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_WAREHOUSE_PEDIA', '倉庫是一座商業大廈的儲存貨物。倉庫所使用的製造商，進口商，出口商，批發商，運輸企業，海關等存儲貨物可以包括任何原料，包裝材料，零部件，元器件，或成品與農業，製造業，或商業相關的。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_UNIVERSITY_HELP', '[ICON_RESEARCH]科學：1從叢林[NEWLINE] [ICON_RES_ARTIFACTS]能否建立考古學家[NEWLINE] [ICON_LOCKED]需要：圖書館', '', '');
/* 國家奇蹟 */
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HEROIC_EPIC_HELP', '在這個城市​​的所有新培訓單位收到[COLOR_POSITIVE_TEXT]士氣[ENDCOLOR]促銷，15％提高[ICON_STRENGTH]戰鬥力。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_OXFORD_UNIVERSITY', '海德堡大學', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HOLY_PALACE', '神聖的宮殿', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HOLY_PALACE_HELP', '提供在它的構造所在的城市+8和25％信仰', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HOLY_PALACE_STRATEGY', '神聖的宮殿提供顯著的信仰對一個城市。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HOLY_PALACE_PEDIA', '待辦事項', '', '');
/* 奇蹟：重命名或添加 */
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_GREATWALL_DESC', '中國的長城是世界上最大和最有名的人造建築在整個世界中的一個。中國統治者修築長城，從游牧部族生活在現代滿蒙抵禦攻擊。有趣的是，長城是不是設計來保持游牧民族出來 - 在中國知道這是幾乎不可能捍衛這麼長的邊界 - 它的目的是使人們難以對入侵者帶走戰利品，從而使襲擊遠不如賺錢因而較少價值所涉及的風險。[NEWLINE] [NEWLINE]有其實一直五種不同的“長城”由不同的中國朝代建造。幾個牆壁正在興建早在公元前7世紀。這些，後來連在一起，並提出做大，做強，統一，現在統稱為長城。大多數現有的牆壁的明朝時期被重建了1368和AD 1640之間。這道牆被修建了一個宏大的規模，使用更多的永磁材料（如石頭）。明牆綿延3948英里從山海關在渤海灣，東到羅布泊在新疆維吾爾族自治區西部的東南部分。這是那裡的絲綢之路最早進入中國，以及一系列瞭望塔可通過狼煙溝通的目的是要傳遞消息迅速沿著牆壁廣大長度的區域。[NEWLINE] [NEWLINE]在純軍事方面，長城轉身出有什麼東西出現故障。滿族能夠賄賂一位中國將軍，讓他們穿牆，所以它竟然是沒有什麼價值的停止主要野蠻人的攻擊。後滿族征服中國，國家的邊界延伸遙遠的北方，渲染牆無關。牆上的純粹的金錢成本也令人咋舌，而且成本人命，據說已超過一百萬的靈魂。長城是有時被稱為“長墓地。”[NEWLINE] [NEWLINE]今天大部分的長城是在一個年久失修的狀態 - 雖然旅遊區是保存完好的，多結構的其餘部分正在崩潰，也許只有20％的牆體處於良好狀態。儘管它的衰變，長城仍然是中國的一個最熱門的旅遊景點和世界的真實奇蹟。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_PENTAGON_HELP', '所有單位醫治動不動。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_LEANING_TOWER', '大教堂（Duomo）', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_LEANING_TOWER_QUOTE', '[NEWLINE] [TAB] [TAB]“十五世紀的文藝復興是，在許多事情上，偉大而由它通過什麼來實現設計的呢。”[NEWLINE] [TAB] [TAB]  - 瓦爾特·佩特[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_LEANING_TOWER_DESC', '大教堂（聖母百花大教堂）是一家大型教堂位於意大利佛羅倫薩的心臟。花了140年興建，於1436年完成。在施工期間，佛羅倫薩是一個共和國，許多城邦在意大利的一部分期間的時間。大教堂在共和國發揮了核心部分，據說已經開始了復興之路。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HUBBLE', '貝爾實驗室', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HUBBLE_QUOTE', '[NEWLINE] [TAB] [TAB]“創意技術學院，需要人才的臨界質量，以樹立一個繁忙的思想交流。”[NEWLINE] [TAB] [TAB]  - 默文凱利，貝爾實驗室的總裁[NL ] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HUBBLE_DESC', '晶體管：這個研究機構通過發明現代計算機的基本組成部分，其中包括20世紀最重要的工程奇蹟徹底改變了世界。這些設備使計算機從房子的大小縮小到口袋大小的同時急劇地增加他們的權力。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MAUSOLEUM_HALICARNASSUS', '鬥獸場', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_MAUSOLEUM_HALICARNASSUS_DESC', '俗稱的鬥獸場，弗拉維安露天劇場在羅馬城的中心是有史以來建造的羅馬帝國最大的。它被認為是古羅馬建築和羅馬工程的最偉大的作品之一。[NEWLINE] [NEWLINE]佔地網站只是東羅馬廣場，其建築始於公元72下皇帝維斯帕先和於公元80年提圖斯下完成，在與多米提安的統治時期（公元81-96）正在進行進一步的修改。這個名字Amphitheatrum Flavium來源於兩個維斯帕先的和提圖斯的姓（弗拉菲烏斯，從氏族弗拉維亞）。[NEWLINE] [NEWLINE]能夠休息的50,000名觀眾，鬥獸場用於角斗競賽和公眾眼鏡，例如模擬海戰，動物狩獵，執行，再制定著名戰役，和戲劇基於古典神話。該建築不再在早期中世紀時代被用於娛樂。它後來被重新用於多種用途，如住房，廠房，宿舍為一個宗教秩序，一個堡壘，一個採石場，和基督教聖地。[NEWLINE] [NEWLINE]這個名字​​鬥獸場一直被認為是從一個巨大的雕像衍生附近尼祿。這座雕像後來被尼祿的繼承人改造成太陽神阿波羅或者，太陽神的形像，通過添加適當的太陽能冠。 Nero的頭部也被更換數次成功皇帝的頭上。巨像並最終下降，可能被推倒重新使用它的銅牌。到了1000年的名義鬥獸場已經創造是指圓形劇場。這座雕像本身在很大程度上被遺忘，只有它的生存基地，位於羅馬鬥獸場和維納斯和羅馬附近的寺廟之間。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_MAUSOLEUM_HALICARNASSUS_QUOTE', '[NEWLINE] [TAB] [TAB]“我是說關於那個可怕的地方，露天劇場連偽證無法面對它因它是專門為更多的名字，而且更可怕的名字，比國會大廈本身;。它是萬魔殿有許多污穢的靈，聚集在那裡，因為它可容納的人“[NEWLINE] [TAB] [TAB]  - 戴爾都良（德Spectaculis，十二）[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_ITAIPU_DAM', '伊泰普大壩', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_ITAIPU_DAM_HELP', '提供了生產的每一個城市。 [NEWLINE]提供一個免費的工程師專家。 [NEWLINE]提供免費水電站在城市。 [NEWLINE]必須建在河邊。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_ITAIPU_DAM_QUOTE', '[NEWLINE] [TAB] [TAB]“女性認為工程師是在臀部靴子建設水壩的人，他們不知道，95％的工程在一個不錯的空調的辦公室就完成了。”[NEWLINE] [ TAB] [TAB]  - 比阿特麗斯愛麗絲·希克斯，第一位女性工程師，西電[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_ITAIPU_DAM_DESC', '這在巴拉那河大壩巨型產生的任何經營水電設施在世界上最每年的電費，提供90％的巴拉圭所消耗的電力以及由巴西消耗的20％。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_LARGE_HADRON_COLLIDER', '大型強子對撞機', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_LARGE_HADRON_COLLIDER_HELP', '2免費技術。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_LARGE_HADRON_COLLIDER_QUOTE', '[NEWLINE] [TAB] [TAB]“我認為這是不明智的過分強調，希格斯玻色子被檢為LHC的賣點。物理學家知道有這麼多機器是要幹什麼。如果他們沒有找到玻色子，誰去為錢為別的“[NEWLINE] [TAB] [TAB]  - 彼得·希格斯潔具[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_LARGE_HADRON_COLLIDER_DESC', '大型強子對撞機（LHC）是世界上最大，能量最高的粒子加速器。物理學家希望LHC將有助於回答一些基本的開放性問題在物理學中，有關規管中的基本對象的交互和力量的基本規律，空間和時間的深層結構，以及量子力學和廣義相對論的特別的交集，在那裡目前的理論和知識是不明確或分解完全。數據，也需要從高能粒子實驗，以指示它們是科學模型的版本更可能是正確的，並驗證其預測和允許進一步的理論發展[NEWLINE] [NEWLINE]在LHC在於隧道27公里周長，高達175米瑞士日內瓦附近的法國和瑞士邊境之下。此同步加速器的目的是反對碰撞或者質子粒子束在7 teraelectronvolts（TeV能區）每個粒子，或者鉛原子核以每核574 TeV的能量的能量。這個詞強子是指粒子夸克組成的。大型強子對撞機是由歐洲核研究組織（CERN它始建於合作，擁有超過10000名科學家和工程師來自全球100多個國家，以及數百所大學和實驗室的建設。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_CHURCHES_LALIBELA', '拉利貝拉教堂', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_CHURCHES_LALIBELA_HELP', '提供了25％以上的信仰帝國寬。 [NEWLINE]提供信心在附近的山上。邊界擴大到附近的山上。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_CHURCHES_LALIBELA_QUOTE', '[NEWLINE] [TAB] [TAB]“我們已經完成了這項工作，我們該怎麼辦的工具？”[NEWLINE] [TAB] [TAB]  -  Halie塞拉西[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_CHURCHES_LALIBELA_DESC', '拉利貝拉的教堂是教會從堅硬的岩石雕刻拉利貝拉附近的小鎮，在現代埃塞俄比亞的集合。該地區很可能是一個宗教網站阿克蘇姆王國，羅馬和印度洋之間的佔主導地位的貿易夥伴，這存在800年從100到940 CE中。該Aksumites是世界第一大文明信奉基督教。宗教成為南亞次大陸最大的信仰，以及Aksumites很可能在其整個非洲蔓延的一個因素。[NEWLINE] [NEWLINE]幾個教會在這樣一種方式，很多人認為他們是聖潔的比喻佈局耶路撒冷城。這導致了在耶路撒冷約在1197征服了薩拉丁一些建築估計。因此，許多建築物都與耶路撒冷的名字。鎮，原名ROHA，Abysinnia的國王在12世紀，它提供了更多的crediability以名誰統治後改名。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_BANAUE_RICE_TERRACES', '巴納韋水稻梯田', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_BANAUE_RICE_TERRACES_HELP', '提供附近的山上食物。邊界擴大到附近的山上。 [NEWLINE]必須建在山上的城市。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_BANAUE_RICE_TERRACES_QUOTE', '[NEWLINE] [TAB] [TAB]“水稻是偉大的，如果你真的餓了，想要吃兩千年的東西。”[NEWLINE] [TAB] [TAB]  - 米奇赫貝格[NEWLINE] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_BANAUE_RICE_TERRACES_DESC', '梯田在巴納韋是雕刻成伊富高的山，在菲律賓2000年歷史的階梯式露台。人們普遍認為的階地均建有最少的設備，主要由手。梯田佔地約4000平方英里山腰。他們是由從上面的梯田熱帶雨林古老的灌溉系統供電。如果把端到端的步驟，他們將環繞半個地球。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_PANAMA_CANAL', '巴拿馬運河', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_PANAMA_CANAL_HELP', '提供了增強的貿易路線的獎金。 [NEWLINE]提供+1船舶運動', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_PANAMA_CANAL_QUOTE', '[NEWLINE] [TAB] [TAB]“男人更精細的身體從來沒有被收集的不是誰做建築巴拿馬運河工作的人任何一個國家。”[NEWLINE] [TAB] [TAB]  - 西奧多·羅斯福[ NL] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_PANAMA_CANAL_DESC', '巴拿馬運河快捷方式使人們有可能對船舶在以前的一半所需要的時間的大西洋和太平洋之間的旅行。越短，更快，更安全的美國西海岸，並在國家和沿太平洋航線允許那些地方，成為與世界經濟更加一體化。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_HOLLYWOOD', '好萊塢', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HOLLYWOOD_HELP', '提供4個可交易的免費電影，豪華的資源。 [NEWLINE]提供一個[ICON_TEAM_7]免費偉大的藝術家。[NEWLINE]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HOLLYWOOD_QUOTE', '[NEWLINE] [TAB] [TAB]“好萊塢是一個地方，他們會付給你一個吻和五毛你的靈魂上千元。”[NEWLINE] [TAB] [TAB]  - 瑪麗蓮夢露[NEWLINE] [ TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HOLLYWOOD_PEDIA', '好萊塢是洛杉磯市的美國一區。由於它的名氣和文化認同的電影製片廠和電影明星的歷史中心，守信用“好萊塢”經常被用來代表美國電影業作為一個整體。[NEWLINE] [NEWLINE]區域開始作為一個理想主義“美國郊區“，但它很快從1909年的成長，當電影製作人開始到達，而現在是同義與美國電影業。如今，好萊塢glamourised為是富人和名人，其中是由夢想和願望成真之地。它是家庭對幾個標誌性的建築，包括Hollywood Bowl以及Grauman的中國劇院。然而，當大多數人認為好萊塢，他們認為大招牌之上的好萊塢山丘。這個標誌開始作為一個廣告牌的郊區定居，當時名為“好萊塢莊園”。 1949年，“土地”被移除的裝修合同的一部分。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_WAT_PHRA_KAEW', '玉佛寺', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_WAT_PHRA_KAEW_HELP', ' +10％黃金及文化活動從每個神社和寺廟。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_WAT_PHRA_KAEW_QUOTE', '[NEWLINE] [TAB] [TAB]“如果你是尊重了習慣，不斷地歌頌有價值的，四件事情增加：壽命長，美麗，幸福，力量。”[NEWLINE] [TAB] [TAB]  - 釋迦牟尼佛[ NL] [TAB]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_WAT_PHRA_KAEW_DESC', '這個宏偉的寺廟在泰國被視為最神聖的佛寺（WAT）。主樓設有翡翠佛雕像。這個佛像的傳奇歷史上溯到印度，五百年之後，佛陀涅槃，直到它最終被供奉在曼谷的玉佛寺廟宇於1782年。[NEWLINE] [NEWLINE]位於曼谷的歷史中心，大皇宮的場地內，它供奉玉佛寺莫拉克（玉佛），高度尊敬的佛像從玉單塊精心雕刻。玉佛（帕Putta摩訶瑪尼叻Patimakorn）是在北方，建於公元15世紀的蘭納學校的風格沉思位置的佛像。[NEWLINE] [NEWLINE]高高舉起了一系列的平台，任何人都不得靠近佛除了國王。季節性斗篷，每年更換三次對應夏季，冬季和雨季涵蓋了雕像。一個非常重要的儀式，長袍的變化時，才執行由國王帶來好運到全國每一個季節。[NEWLINE] [NEWLINE]寺廟的建造工程開始時，國王佛Yodfa Chulaloke（拉瑪一世）的移動資本從吞武裡到曼谷在1785年。不像其他的寺廟，它不包含生活區的僧侶，而是只精心裝飾神聖的建築，雕像，和寶塔。主體建築是中央“ubosot''（協調廳），裡面的玉佛。', '', '');
/* 奇蹟：修改 */
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_CHICHEN_ITZA_HELP', '1免費定居附近出現了生成它的城市。工人改進速度提高25％。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_COLOSSUS_HELP', '[ICON_TEAM_2]貨船：1 [NEWLINE] [ICON_TRADE]萬昌路線：1 [NEWLINE] [ICON_GOLD]黃金：2元貿易路線從這裡[NEWLINE] [ICON_LOCKED]需要：海岸城', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_HAGIA_SOPHIA_HELP', '添加cathderal獎金給它的構造所在的城市', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILDING_MACHU_PICHU_HELP', '附近的城市漲幅一座山：[NEWLINE] [ICON_FOOD]食物：5 [NEWLINE] [ICON_GOLD]黃金：5 [NEWLINE] [ICON_CULTURE]文化：5 [NEWLINE] [ICON_PEACE]信仰：5', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_STONEHENGE_HELP', '[ICON_PEACE]每+5信仰轉身[ICON_PEACE] 20信仰瞬間。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WONDER_TERRA_COTTA_ARMY_HELP', '瞬間+3邊界擴張的城市，它是建立。', '', '');








UPDATE LoadedFile SET Value=1, ZH_HANT_HK=1 Where Type='Cities.sql';




