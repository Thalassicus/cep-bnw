/*

You can change most options in this file at any time, unless indicated otherwise.
Changes take effect the next time you start or load a game with Communitas.

For example, if you wish to remove the human's combat bonus against barbarians on Prince difficulty,
change the lines that read:

	UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_PRINCE';

...change to...

	UPDATE HandicapInfos SET BarbarianBonus =   0 WHERE Type = 'HANDICAP_PRINCE';

Then start a new game.

*/



-------------
-- Options --
-------------


/*
Human-vs-barbarian combat bonus.
*/
UPDATE HandicapInfos SET BarbarianBonus = 150 WHERE Type = 'HANDICAP_SETTLER';
UPDATE HandicapInfos SET BarbarianBonus =  50 WHERE Type = 'HANDICAP_CHIEFTAIN';
UPDATE HandicapInfos SET BarbarianBonus =  20 WHERE Type = 'HANDICAP_WARLORD';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_PRINCE';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_KING';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_EMPEROR';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_IMMORTAL';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_DEITY';

UPDATE Defines SET Value = 90 WHERE Name = 'BARBARIAN_MAX_XP_VALUE'; -- default 90


/*
Minimum distance (in tiles) between cities.
*/
UPDATE Defines SET Value = 3 WHERE Name = 'MIN_CITY_RANGE'; -- default 3


/*
Adjust some values for game speeds.
*/
UPDATE GameSpeeds SET CulturePercent=150, ResearchPercent=150, FaithPercent=150 WHERE Type = 'GAMESPEED_EPIC';		-- defaults 150
UPDATE GameSpeeds SET CulturePercent=300, ResearchPercent=300, FaithPercent=300 WHERE Type = 'GAMESPEED_MARATHON';	-- defaults 300


/*
Add a higher number if you want more natural wonders, or subtract if you want fewer.
*/
UPDATE Worlds SET NumNaturalWonders = NumNaturalWonders + 1; -- default +1


/*
Ship Boarding
1 = land units can board military ships
0 = land units can not board military ships
*/
INSERT INTO Cep (Type, Value)
VALUES ('SHIP_BOARDING', 0); -- default 1

















--
-- Do not change items below

UPDATE LoadedFile SET Value=1 WHERE Type='Cep_Options.sql';
