-- 


CREATE TABLE IF NOT EXISTS Cep(Type text NOT NULL UNIQUE, Value);

-- The addition of the language columns is to assist tracking down translation errors causing non-loading files.
-- Each "UPDATE LoadedFile SET" command now includes a command to set the language for that specific file to 1.
-- This will mean, although each filename is the same in each language folder,
-- the correct file for each will trigger the SET command.


CREATE TABLE IF NOT EXISTS
	LoadedFile(
	Type text,
	Value,
	en_US DEFAULT 0,
	DE_DE DEFAULT 0,
	ES_ES DEFAULT 0,
	FR_FR DEFAULT 0,
	IT_IT DEFAULT 0,
	JA_JP DEFAULT 0,
	KO_KR DEFAULT 0,
	PL_PL DEFAULT 0,
	RU_RU DEFAULT 0,
	ZH_HANT_HK DEFAULT 0
	);

INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Data.xml'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_Misc.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Options.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Promotions.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_PromotionOrder.sql'	, 0);
<<<<<<< HEAD
INSERT INTO LoadedFile(Type, Value) VALUES ('Ceg_Options.sql'		, 0);
=======
INSERT INTO LoadedFile(Type, Value) VALUES ('CEG_Options.sql'		, 0);
>>>>>>> 2137844e315b3a7a9dfd8a4a0b33d85d09fe3bf4
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_AlterTables.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('YL_Data.xml'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_End.sql'			, 0);

INSERT INTO LoadedFile(Type, Value) VALUES ('TW_BuildingStats.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('TW_PromoStats.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Text_TW_BuildingStats.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Text_TW_PromotionStats.sql'	, 0);

INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI_LeaderPersonalities.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI_LeaderFlavors.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_AI_Flavors_CEAI_Start.sql'				, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_AI_Flavors_CEAI_Units.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_AI_Flavors_CEAI_Techs.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Core.sql'						, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Flavors.sql'						, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Framework.sql'						, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Villages.sql'						, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('YieldLibrary.sql'						, 0);




UPDATE LoadedFile SET Value=1 WHERE Type='CAT_Start.sql';
