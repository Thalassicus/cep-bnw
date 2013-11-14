-- Cep_Core
-- Author: Thalassicus
-- DateCreated: 12/21/2010 10:00:43 AM
--------------------------------------------------------------

--print("INFO   Loading Cep_Core.lua")

if GameInfo.Units[1].PopCostMod == nil then
	print("FATAL  'Cep_Start.sql' did not load!")
end

include("YieldLibrary.lua")

--print("INFO   Done    Cep_Core.lua")