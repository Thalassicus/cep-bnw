-- This CEAI_LeaderFlavors.sql data automatically created by:
-- Leader_Priorities tab of Leaders spreadsheet
-- https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dHlBVGdUV0doVGlVU3dGLWt3LS1YRHc&usp=drive_web#gid=4
-- Update the spreadsheet, then copy to this file.

DELETE FROM Leader_Flavors;


-- Personality Types
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MILITARY_TRAINING',        LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_OFFENSE',                  LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DEFENSE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CITY_DEFENSE',             LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SOLDIER',                  LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MOBILE',                   LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTI_MOBILE',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RECON',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HEALING',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PILLAGE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_VANGUARD',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RANGED',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SIEGE',                    LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_BOMBARDMENT',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_RECON',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_GROWTH',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_TILE_IMPROVEMENT',   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR',                      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTIAIR',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIRLIFT',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR_CARRIER',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_USE_NUKE',                 LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NUKE',                     LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GROWTH',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PRODUCTION',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLD',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SCIENCE',                  LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SPACESHIP',                LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ESPIONAGE',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CULTURE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TOURISM',                  LeaderType, 0) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ARCHAEOLOGY',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RELIGION',                 LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GREAT_PEOPLE',             LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HAPPINESS',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLDEN_AGE',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_EXPANSION',                LeaderType, 9) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TILE_IMPROVEMENT',         LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_INFRASTRUCTURE',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WATER_CONNECTION',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_LAND_TRADE_ROUTE',       LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_SEA_TRADE_ROUTE',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_ORIGIN',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_DESTINATION',      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WONDER',                   LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DIPLOMACY',                LeaderType, 0) FROM Leaders WHERE Personality = 'PERSONALITY_CONQUEROR';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MILITARY_TRAINING',        LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_OFFENSE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DEFENSE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CITY_DEFENSE',             LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SOLDIER',                  LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MOBILE',                   LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTI_MOBILE',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RECON',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HEALING',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PILLAGE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_VANGUARD',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RANGED',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SIEGE',                    LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_BOMBARDMENT',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_RECON',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_GROWTH',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_TILE_IMPROVEMENT',   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR',                      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTIAIR',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIRLIFT',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR_CARRIER',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_USE_NUKE',                 LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NUKE',                     LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GROWTH',                   LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PRODUCTION',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLD',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SCIENCE',                  LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SPACESHIP',                LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ESPIONAGE',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CULTURE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TOURISM',                  LeaderType, 0) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ARCHAEOLOGY',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RELIGION',                 LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GREAT_PEOPLE',             LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HAPPINESS',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLDEN_AGE',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_EXPANSION',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TILE_IMPROVEMENT',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_INFRASTRUCTURE',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WATER_CONNECTION',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_LAND_TRADE_ROUTE',       LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_SEA_TRADE_ROUTE',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_ORIGIN',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_DESTINATION',      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WONDER',                   LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DIPLOMACY',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_COALITION';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MILITARY_TRAINING',        LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_OFFENSE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DEFENSE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CITY_DEFENSE',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SOLDIER',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MOBILE',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTI_MOBILE',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RECON',                    LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HEALING',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PILLAGE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_VANGUARD',                 LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RANGED',                   LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SIEGE',                    LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_BOMBARDMENT',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_RECON',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_GROWTH',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_TILE_IMPROVEMENT',   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR',                      LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTIAIR',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIRLIFT',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR_CARRIER',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_USE_NUKE',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NUKE',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GROWTH',                   LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PRODUCTION',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLD',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SCIENCE',                  LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SPACESHIP',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ESPIONAGE',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CULTURE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TOURISM',                  LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ARCHAEOLOGY',              LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RELIGION',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GREAT_PEOPLE',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HAPPINESS',                LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLDEN_AGE',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_EXPANSION',                LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TILE_IMPROVEMENT',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_INFRASTRUCTURE',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WATER_CONNECTION',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_LAND_TRADE_ROUTE',       LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_SEA_TRADE_ROUTE',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_ORIGIN',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_DESTINATION',      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WONDER',                   LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DIPLOMACY',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_DIPLOMAT';

INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MILITARY_TRAINING',        LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_OFFENSE',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DEFENSE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CITY_DEFENSE',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SOLDIER',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_MOBILE',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTI_MOBILE',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RECON',                    LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HEALING',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PILLAGE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_VANGUARD',                 LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RANGED',                   LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SIEGE',                    LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL',                    LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_BOMBARDMENT',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_RECON',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_GROWTH',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NAVAL_TILE_IMPROVEMENT',   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR',                      LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ANTIAIR',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIRLIFT',                  LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_AIR_CARRIER',              LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_USE_NUKE',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_NUKE',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GROWTH',                   LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_PRODUCTION',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLD',                     LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SCIENCE',                  LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_SPACESHIP',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ESPIONAGE',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_CULTURE',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TOURISM',                  LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_ARCHAEOLOGY',              LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_RELIGION',                 LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GREAT_PEOPLE',             LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_HAPPINESS',                LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_GOLDEN_AGE',               LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_EXPANSION',                LeaderType, 8) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_TILE_IMPROVEMENT',         LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_INFRASTRUCTURE',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WATER_CONNECTION',         LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_LAND_TRADE_ROUTE',       LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_SEA_TRADE_ROUTE',        LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_ORIGIN',           LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_I_TRADE_DESTINATION',      LeaderType, 4) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_WONDER',                   LeaderType, 6) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';
INSERT OR REPLACE INTO Leader_Flavors(FlavorType, LeaderType, Flavor) SELECT ('FLAVOR_DIPLOMACY',                LeaderType, 2) FROM Leaders WHERE Personality = 'PERSONALITY_EXPANSIONIST';



-- Leader Overrides

UPDATE Leader_Flavors SET (Flavor =   9 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_ASHURBANIPAL');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TILE_IMPROVEMENT'          AND LeaderType = 'LEADER_ASHURBANIPAL');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_HARALD');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_HARALD');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_HARALD');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_HARALD');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_HARALD');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ATTILA');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_ODA_NOBUNAGA');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_ODA_NOBUNAGA');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_GENGHIS_KHAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_VANGUARD'                  AND LeaderType = 'LEADER_GENGHIS_KHAN');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_AUGUSTUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_AUGUSTUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_AUGUSTUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_AUGUSTUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_AUGUSTUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_AUGUSTUS');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ASKIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_ASKIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_ASKIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_ASKIA');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_ISABELLA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_ISABELLA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_ISABELLA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_ISABELLA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TILE_IMPROVEMENT'          AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   4 WHERE FlavorType = 'FLAVOR_INFRASTRUCTURE'            AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   4 WHERE FlavorType = 'FLAVOR_WATER_CONNECTION'          AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_LAND_TRADE_ROUTE'        AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_SEA_TRADE_ROUTE'         AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_ORIGIN'            AND LeaderType = 'LEADER_ENRICO_DANDOLO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_DESTINATION'       AND LeaderType = 'LEADER_ENRICO_DANDOLO');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_SHAKA');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_SHAKA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_VANGUARD'                  AND LeaderType = 'LEADER_SHAKA');


UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_MONTEZUMA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RANGED'                    AND LeaderType = 'LEADER_WU_ZETIAN');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_BISMARCK');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_BISMARCK');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_ALEXANDER');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_GAJAH_MADA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_GAJAH_MADA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_GAJAH_MADA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_GAJAH_MADA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_GAJAH_MADA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_GAJAH_MADA');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_CASIMIR');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MILITARY_TRAINING'         AND LeaderType = 'LEADER_CATHERINE');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_CATHERINE');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_EXPANSION'                 AND LeaderType = 'LEADER_CATHERINE');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_GUSTAVUS_ADOLPHUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_GUSTAVUS_ADOLPHUS');


UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_MARIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_MARIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_MARIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_MARIA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_MARIA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_PEDRO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_PEDRO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_PEDRO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_PEDRO');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_PEDRO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLDEN_AGE'                AND LeaderType = 'LEADER_PEDRO');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_THEODORA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_THEODORA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_RAMESSES');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_WONDER'                    AND LeaderType = 'LEADER_RAMESSES');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_SELASSIE');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_SELASSIE');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_SELASSIE');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_SELASSIE');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_PACHACUTI');
UPDATE Leader_Flavors SET (Flavor =   2 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_PACHACUTI');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_GANDHI');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_GANDHI');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_GANDHI');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_GANDHI');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_GROWTH'                    AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_SPACESHIP'                 AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =   4 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =   4 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =   2 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_SEJONG');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_SEJONG');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_PACAL');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_PACAL');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_PACAL');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_AHMAD_ALMANSUR');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_KAMEHAMEHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_KAMEHAMEHA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_RAMKHAMHAENG');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_SCIENCE'                   AND LeaderType = 'LEADER_RAMKHAMHAENG');


UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_WASHINGTON');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_HARUN_AL_RASHID');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_HARUN_AL_RASHID');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_HARUN_AL_RASHID');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_HARUN_AL_RASHID');

UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_NEBUCHADNEZZAR');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_DIDO');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_DIDO');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_TOURISM'                   AND LeaderType = 'LEADER_BOUDICCA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_ARCHAEOLOGY'               AND LeaderType = 'LEADER_BOUDICCA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RELIGION'                  AND LeaderType = 'LEADER_BOUDICCA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_RANGED'                    AND LeaderType = 'LEADER_ELIZABETH');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_ELIZABETH');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_ELIZABETH');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_ELIZABETH');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_ELIZABETH');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_ELIZABETH');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_CULTURE'                   AND LeaderType = 'LEADER_NAPOLEON');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_SOLDIER'                   AND LeaderType = 'LEADER_HIAWATHA');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_PRODUCTION'                AND LeaderType = 'LEADER_HIAWATHA');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_WILLIAM');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL'                     AND LeaderType = 'LEADER_SULEIMAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'         AND LeaderType = 'LEADER_SULEIMAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_RECON'               AND LeaderType = 'LEADER_SULEIMAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_GROWTH'              AND LeaderType = 'LEADER_SULEIMAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_NAVAL_TILE_IMPROVEMENT'    AND LeaderType = 'LEADER_SULEIMAN');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLD'                      AND LeaderType = 'LEADER_SULEIMAN');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GREAT_PEOPLE'              AND LeaderType = 'LEADER_DARIUS');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_HAPPINESS'                 AND LeaderType = 'LEADER_DARIUS');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_GOLDEN_AGE'                AND LeaderType = 'LEADER_DARIUS');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_LAND_TRADE_ROUTE'        AND LeaderType = 'LEADER_MARIA_I');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_SEA_TRADE_ROUTE'         AND LeaderType = 'LEADER_MARIA_I');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_ORIGIN'            AND LeaderType = 'LEADER_MARIA_I');
UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_I_TRADE_DESTINATION'       AND LeaderType = 'LEADER_MARIA_I');

UPDATE Leader_Flavors SET (Flavor =   8 WHERE FlavorType = 'FLAVOR_MOBILE'                    AND LeaderType = 'LEADER_POCATELLO');
UPDATE Leader_Flavors SET (Flavor =  16 WHERE FlavorType = 'FLAVOR_EXPANSION'                 AND LeaderType = 'LEADER_POCATELLO');


UPDATE LoadedFile SET Value=1 WHERE Type='CEAI_LeaderFlavors.sql';
