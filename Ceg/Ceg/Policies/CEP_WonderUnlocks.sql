-- CEP_WonderUnlocks.sql created by Wonder_Unlocks tab of Wonders spreadsheet:
-- https://drive.google.com/folderview?id=0B58Ehya83q19eVlvWXdmLXZ6UUE

UPDATE Buildings SET PolicyBranchType='POLICY_REPUBLIC'                 WHERE BuildingClass='BUILDINGCLASS_GREAT_WALL';
UPDATE Buildings SET PolicyBranchType='NULL'                         WHERE BuildingClass='BUILDINGCLASS_HANGING_GARDENS';