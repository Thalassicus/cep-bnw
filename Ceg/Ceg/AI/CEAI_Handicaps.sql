-- Insert SQL Rules Here 

UPDATE HandicapInfos SET HappinessDefault = HappinessDefault - 10;


UPDATE LoadedFile SET Value=1 WHERE Type='CEAI_Handicaps.sql';