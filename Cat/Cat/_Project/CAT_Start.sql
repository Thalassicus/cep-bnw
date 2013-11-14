-- 


CREATE TABLE IF NOT EXISTS Cep(Type text NOT NULL UNIQUE, Value);

CREATE TABLE IF NOT EXISTS LoadedFile(Type text, Value);
INSERT INTO LoadedFile(Type, Value) VALUES ('MT_Data.xml'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CAT_Misc.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Options.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Promotions.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cep_Options.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('MT_AlterTables.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('YL_General.xml'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('TW_BuildingStats.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('TW_PromoStats.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Text_TW_BuildingStats.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Text_TW_PromotionStats.sql'	, 0);

INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI_LeaderPersonalities.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI_LeaderFlavors.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI__Start.sql'				, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI__End_Flavors.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('CEAI_Flavor_Techs.sql'			, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('AI.sql'						, 0);


INSERT INTO LoadedFile(Type, Value) VALUES ('Cat_Language_End.sql', 0);

UPDATE LoadedFile SET Value=1 WHERE Type='CAT_Start.sql';