/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', '영화', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', '또한 영화 나 영화라는 영화는, 프로젝터를 통해 실행하고 화면에 표시 할 때, 움직이는 이미지의 환상을 만들어, 플라스틱 스트립에 일련의 스틸 이미지입니다. 영화는 영화 카메라로 실제 장면을 촬영하여 생성되며 전통적인 애니메이션 기술을 사용하여 도면 또는 소형 모델을 촬영하여, CGI 및 컴퓨터 애니메이션에 의해, 또는 이러한 기술 및 다른 시각적 효과의 일부 또는 전부의 조합에 의해 수행 될 수있다. 영화 제작의 과정은 예술과 산업 모두입니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', '티 리안 퍼플', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', '로얄 퍼플, 제국 자주색 또는 제국의 염료로 알려진 보라색 티 리안은 붉은 자주색 천연 염료입니다. 염료는 신입으로 알려진 약탈 바다 달팽이에 의해 생산 분비입니다. 이 염료는 아마도 빠르면 1600으로 BC 고대 페니키아 인에 의해 사용되었다. 염료는 색상이 쉽게 퇴색하지 않았기 때문에 크게 고대에 입상, 대신 풍화 햇빛 밝은되었다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', '그것은이 타일에 주둔하고있는 군부대의 [ICON_STRENGTH] 방어를 개선하고, 인접한 적에게 20 데미지를합니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] 비용 [ENDCOLOR] 3 [ICON_GOLD] 골드 턴에 유지합니다. [NEWLINE] [NEWLINE] 50퍼센트 [ICON_STRENGTH] 방어이 타일에 주둔하고있는 장치에 대한 강도, 인접한 적에게 20 데미지.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] 비용 [ENDCOLOR] 3 [ICON_GOLD] 골드 턴에 유지합니다. [NEWLINE] [NEWLINE] 요새 진수의 방어 보너스를 향상시키는 특별한 개선하고, 인접한 적에게 20 데미지. 그러나 이러한 효과는 적의 영토에 적용되지 않습니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', '그것을 발견하는 첫번째 선수로 [ICON_GOLD] 골드 (100)를 부여합니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', '제도', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', '제도', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', '섬은 바다로 둘러싸여 서브 대륙 땅의 조각이다. 아주 작은 섬은 섬, 암초 또는 키를 호출 할 수 있습니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] +100 % [COLOR_POSITIVE_TEXT] 방어 [ENDCOLOR]이 타일. [NEWLINE] [ICON_RANGE_STRENGTH] 30 [COLOR_POSITIVE_TEXT] 데미지 [ENDCOLOR] 근처의 적에게 차례 당. [NEWLINE] [ICON_CULTURE] 근처 타일 테두리를 확장보세요. [NEWLINE] [ICON_LOCKED] 친화적 인 영역이 필요합니다.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] 음식 : +2 [NEWLINE] [ICON_LOCKED] 요구 사항 : 해안의 땅', '', '');





UPDATE Loaded File SET Value=1, KO_KR=1 Where Type='Terrain.sql';


