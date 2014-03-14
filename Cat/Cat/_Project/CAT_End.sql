--
INSERT INTO CepWorlds SELECT * FROM Worlds;
INSERT INTO CepGameSpeeds SELECT * FROM GameSpeeds;
INSERT INTO CepHandicapInfos SELECT * FROM HandicapInfos;

UPDATE LoadedFile SET Value=1 WHERE Type='CAT_End.sql';