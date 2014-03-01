--
INSERT INTO CepWorlds SELECT * FROM Worlds;
INSERT INTO CepGameSpeeds SELECT * FROM Worlds;
INSERT INTO CepHandicapInfos SELECT * FROM Worlds;

UPDATE LoadedFile SET Value=1 WHERE Type='CAT_End.sql';