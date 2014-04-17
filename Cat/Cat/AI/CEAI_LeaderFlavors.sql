-- This CEAI_LeaderFlavors.sql data automatically created by:
-- Leader_Priorities tab of Leaders spreadsheet
-- https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dHlBVGdUV0doVGlVU3dGLWt3LS1YRHc&usp=drive_web#gid=4
-- Update the spreadsheet, then copy to this file.

DELETE FROM Leader_Flavors;


-- Personality Types
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MILITARY_TRAINING',        Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_OFFENSE',                  Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DEFENSE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CITY_DEFENSE',             Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SOLDIER',                  Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MOBILE',                   Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTI_MOBILE',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RECON',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HEALING',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PILLAGE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_VANGUARD',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RANGED',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SIEGE',                    Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_BOMBARDMENT',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_RECON',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_GROWTH',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_TILE_IMPROVEMENT',   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR',                      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTIAIR',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIRLIFT',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR_CARRIER',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_USE_NUKE',                 Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NUKE',                     Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GROWTH',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PRODUCTION',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLD',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SCIENCE',                  Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SPACESHIP',                Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ESPIONAGE',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CULTURE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TOURISM',                  Type, 0 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ARCHAEOLOGY',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RELIGION',                 Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GREAT_PEOPLE',             Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HAPPINESS',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLDEN_AGE',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_EXPANSION',                Type, 9 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TILE_IMPROVEMENT',         Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_INFRASTRUCTURE',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WATER_CONNECTION',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_LAND_TRADE_ROUTE',       Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_SEA_TRADE_ROUTE',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_ORIGIN',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_DESTINATION',      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WONDER',                   Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DIPLOMACY',                Type, 0 FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MILITARY_TRAINING',        Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_OFFENSE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DEFENSE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CITY_DEFENSE',             Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SOLDIER',                  Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MOBILE',                   Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTI_MOBILE',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RECON',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HEALING',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PILLAGE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_VANGUARD',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RANGED',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SIEGE',                    Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_BOMBARDMENT',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_RECON',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_GROWTH',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_TILE_IMPROVEMENT',   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR',                      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTIAIR',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIRLIFT',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR_CARRIER',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_USE_NUKE',                 Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NUKE',                     Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GROWTH',                   Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PRODUCTION',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLD',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SCIENCE',                  Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SPACESHIP',                Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ESPIONAGE',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CULTURE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TOURISM',                  Type, 0 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ARCHAEOLOGY',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RELIGION',                 Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GREAT_PEOPLE',             Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HAPPINESS',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLDEN_AGE',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_EXPANSION',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TILE_IMPROVEMENT',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_INFRASTRUCTURE',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WATER_CONNECTION',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_LAND_TRADE_ROUTE',       Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_SEA_TRADE_ROUTE',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_ORIGIN',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_DESTINATION',      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WONDER',                   Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DIPLOMACY',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MILITARY_TRAINING',        Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_OFFENSE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DEFENSE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CITY_DEFENSE',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SOLDIER',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MOBILE',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTI_MOBILE',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RECON',                    Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HEALING',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PILLAGE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_VANGUARD',                 Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RANGED',                   Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SIEGE',                    Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_BOMBARDMENT',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_RECON',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_GROWTH',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_TILE_IMPROVEMENT',   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR',                      Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTIAIR',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIRLIFT',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR_CARRIER',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_USE_NUKE',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NUKE',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GROWTH',                   Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PRODUCTION',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLD',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SCIENCE',                  Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SPACESHIP',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ESPIONAGE',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CULTURE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TOURISM',                  Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ARCHAEOLOGY',              Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RELIGION',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GREAT_PEOPLE',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HAPPINESS',                Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLDEN_AGE',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_EXPANSION',                Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TILE_IMPROVEMENT',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_INFRASTRUCTURE',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WATER_CONNECTION',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_LAND_TRADE_ROUTE',       Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_SEA_TRADE_ROUTE',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_ORIGIN',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_DESTINATION',      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WONDER',                   Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DIPLOMACY',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MILITARY_TRAINING',        Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_OFFENSE',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DEFENSE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CITY_DEFENSE',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SOLDIER',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_MOBILE',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTI_MOBILE',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RECON',                    Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HEALING',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PILLAGE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_VANGUARD',                 Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RANGED',                   Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SIEGE',                    Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL',                    Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_BOMBARDMENT',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_RECON',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_GROWTH',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NAVAL_TILE_IMPROVEMENT',   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR',                      Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ANTIAIR',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIRLIFT',                  Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_AIR_CARRIER',              Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_USE_NUKE',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_NUKE',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GROWTH',                   Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_PRODUCTION',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLD',                     Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SCIENCE',                  Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_SPACESHIP',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ESPIONAGE',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_CULTURE',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TOURISM',                  Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_ARCHAEOLOGY',              Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_RELIGION',                 Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GREAT_PEOPLE',             Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_HAPPINESS',                Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_GOLDEN_AGE',               Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_EXPANSION',                Type, 8 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_TILE_IMPROVEMENT',         Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_INFRASTRUCTURE',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WATER_CONNECTION',         Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_LAND_TRADE_ROUTE',       Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_SEA_TRADE_ROUTE',        Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_ORIGIN',           Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_I_TRADE_DESTINATION',      Type, 4 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_WONDER',                   Type, 6 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT 'FLAVOR_DIPLOMACY',                Type, 2 FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';



-- Leader Overrides

UPDATE Leader_Flavors SET Flavor =   9 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_ASHURBANIPAL';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TILE_IMPROVEMENT'          AND LeaderType = 'LEADER_ASHURBANIPAL';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_HARALD';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_HARALD';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_HARALD';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_HARALD';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_HARALD';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ATTILA';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_ODA_NOBUNAGA';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_ODA_NOBUNAGA';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_GENGHIS_KHAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_VANGUARD'                  AND LeaderType = 'LEADER_GENGHIS_KHAN';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_AUGUSTUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_AUGUSTUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_AUGUSTUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_AUGUSTUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_AUGUSTUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_AUGUSTUS';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ASKIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_ASKIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_ASKIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_ASKIA';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ISABELLA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_ISABELLA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_ISABELLA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_ISABELLA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TILE_IMPROVEMENT'          AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   4 WHERE FlavorType = 'FLAVOR_INFRASTRUCTURE'            AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   4 WHERE FlavorType = 'FLAVOR_WATER_CONNECTION'          AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_LAND_TRADE_ROUTE'        AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_SEA_TRADE_ROUTE'         AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_ORIGIN'            AND LeaderType = 'LEADER_ENRICO_DANDOLO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_DESTINATION'       AND LeaderType = 'LEADER_ENRICO_DANDOLO';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_SHAKA';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_SHAKA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_VANGUARD'                  AND LeaderType = 'LEADER_SHAKA';


UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_MONTEZUMA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RANGED'                    AND LeaderType = 'LEADER_WU_ZETIAN';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_BISMARCK';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_BISMARCK';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_ALEXANDER';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_GAJAH_MADA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_GAJAH_MADA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_GAJAH_MADA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_GAJAH_MADA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_GAJAH_MADA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_GAJAH_MADA';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_CASIMIR';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_CATHERINE';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_CATHERINE';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_EXPANSION'                 AND LeaderType = 'LEADER_CATHERINE';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_GUSTAVUS_ADOLPHUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_GUSTAVUS_ADOLPHUS';


UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_MARIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_MARIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_MARIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_MARIA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_MARIA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_PEDRO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_PEDRO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_PEDRO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_PEDRO';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_PEDRO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLDEN_AGE'                AND LeaderType = 'LEADER_PEDRO';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_THEODORA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_THEODORA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_RAMESSES';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_WONDER'                    AND LeaderType = 'LEADER_RAMESSES';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_SELASSIE';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_SELASSIE';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_SELASSIE';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_SELASSIE';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_PACHACUTI';
UPDATE Leader_Flavors SET Flavor =   2 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_PACHACUTI';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_GANDHI';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_GANDHI';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_GANDHI';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_GANDHI';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_SPACESHIP'                 AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =   4 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =   4 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =   2 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_SEJONG';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_SEJONG';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_PACAL';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_PACAL';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_PACAL';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_AHMAD_ALMANSUR';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_KAMEHAMEHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_KAMEHAMEHA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_RAMKHAMHAENG';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_RAMKHAMHAENG';


UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_WASHINGTON';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_HARUN_AL_RASHID';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_HARUN_AL_RASHID';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_HARUN_AL_RASHID';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_HARUN_AL_RASHID';

UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_NEBUCHADNEZZAR';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_DIDO';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_DIDO';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_BOUDICCA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_BOUDICCA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_BOUDICCA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_RANGED'                    AND LeaderType = 'LEADER_ELIZABETH';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_ELIZABETH';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_ELIZABETH';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_ELIZABETH';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_ELIZABETH';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_ELIZABETH';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_NAPOLEON';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_HIAWATHA';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_HIAWATHA';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_WILLIAM';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_SULEIMAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_SULEIMAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_SULEIMAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_SULEIMAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_SULEIMAN';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_SULEIMAN';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_DARIUS';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_DARIUS';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLDEN_AGE'                AND LeaderType = 'LEADER_DARIUS';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_LAND_TRADE_ROUTE'        AND LeaderType = 'LEADER_MARIA_I';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_SEA_TRADE_ROUTE'         AND LeaderType = 'LEADER_MARIA_I';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_ORIGIN'            AND LeaderType = 'LEADER_MARIA_I';
UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_DESTINATION'       AND LeaderType = 'LEADER_MARIA_I';

UPDATE Leader_Flavors SET Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_POCATELLO';
UPDATE Leader_Flavors SET Flavor =  16 WHERE FlavorType = 'FLAVOR_EXPANSION'                 AND LeaderType = 'LEADER_POCATELLO';


UPDATE LoadedFile SET Value=1 WHERE Type='CEAI_LeaderFlavors.sql';
