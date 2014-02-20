-- 
CREATE TABLE CepWorlds AS SELECT * FROM Worlds;
CREATE TABLE CepGameSpeeds AS SELECT * FROM GameSpeeds;
CREATE TABLE CepHandicapInfos AS SELECT * FROM HandicapInfos;

UPDATE LoadedFile SET Value=1 WHERE Type='CAT_End.sql';