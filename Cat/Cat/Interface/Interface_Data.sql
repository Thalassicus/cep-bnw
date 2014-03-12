--

--/*
UPDATE Technologies
SET Help = 'TXT_KEY_GENERIC';
--*/

--CivUP AM_General.sql
ALTER TABLE UnitClasses ADD Color text default ""; 
ALTER TABLE UnitClasses ADD IconString text default ""; 

UPDATE UnitClasses
SET Color = "255:0:255:255"
WHERE Type = "UNITCLASS_ARTIST";

UPDATE UnitClasses
SET Color = "33:190:247:255"
WHERE Type = "UNITCLASS_SCIENTIST";

UPDATE UnitClasses
SET Color = "255:235:0:255"
WHERE Type = "UNITCLASS_MERCHANT";

UPDATE UnitClasses
SET Color = "198:156:109:255"
WHERE Type = "UNITCLASS_ENGINEER";

UPDATE UnitClasses
SET Color = "255:255:255:255"
WHERE Type = "UNITCLASS_GREAT_GENERAL";

UPDATE UnitClasses
SET IconString = "[ICON_CULTURE]"
WHERE Type = "UNITCLASS_ARTIST";

UPDATE UnitClasses
SET IconString = "[ICON_RESEARCH]"
WHERE Type = "UNITCLASS_SCIENTIST";

UPDATE UnitClasses
SET IconString = "[ICON_GOLD]"
WHERE Type = "UNITCLASS_MERCHANT";

UPDATE UnitClasses
SET IconString = "[ICON_PRODUCTION]"
WHERE Type = "UNITCLASS_ENGINEER";

UPDATE UnitClasses
SET IconString = "[ICON_WAR]"
WHERE Type = "UNITCLASS_GREAT_GENERAL";