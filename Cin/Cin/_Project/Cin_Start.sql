-- 


INSERT INTO LoadedFile(Type, Value) VALUES ('Cin_End.sql'	, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cin_Options.sql'		, 0);
INSERT INTO LoadedFile(Type, Value) VALUES ('Cin_AlterTables.sql'	, 0);


UPDATE LoadedFile SET Value=1 WHERE Type='Cin_Start.sql';