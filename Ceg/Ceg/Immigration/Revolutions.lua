-- Revolutions
-- Author: Afforess
-- DateCreated: 10/6/2010 3:19:52 PM
--------------------------------------------------------------
include("StringUtils");

DebugMode = true
PlayersIndex = nil
iStabilityMax = 1000
iStabilityMin = -1000
iWarningThreshold = -250

function doRevolutions()

	if not PlayersIndex then
		doGameInitialization();
	end

	--Major Civs
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local pPlayer = Players[ iPlayerLoop ];
		if isValidPlayer(pPlayer) then

			for pCity in pPlayer:Cities() do
				doRevolt(pCity, pPlayer);
			end
		end
	end

	saveGameData();
end

function doGameInitialization()
	PlayersIndex = {}
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local pPlayer = Players[ iPlayerLoop ];

		table.insert(PlayersIndex , iPlayerLoop);
		PlayersIndex[iPlayerLoop] = {};

		if (isValidPlayer(pPlayer)) then

			local SaveData = pPlayer:GetScriptData();
			if DebugMode then
				print("Attempting to Load Save Data");
			end
			if SaveData == "" then
				if DebugMode then
					print("No Save Data");
				end
				for pCity in pPlayer:Cities() do
					table.insert(PlayersIndex[iPlayerLoop], {pCity:GetID(), 0});
				end
				local tbl = tableToString(PlayersIndex[iPlayerLoop], pPlayer:GetNumCities(), 2, {",", ":"}, 1);
				if DebugMode then
					print("Save Data Created");
					print(tbl);
				end
				pPlayer:SetScriptData(tbl);
			else
				if DebugMode then
					print("Loading Save Data");
					print(SaveData);
				end

				SaveData = stringToTable(SaveData, pPlayer:GetNumCities(), 2, {",", ":"}, 1);
				PlayersIndex[iPlayerLoop] = SaveData;
			end
		end
	end
end

function saveGameData()
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local pPlayer = Players[ iPlayerLoop ];
		if isValidPlayer(pPlayer) then
			if DebugMode then
				print("Attempting to Save Data");
			end
			local tbl = tableToString(PlayersIndex[iPlayerLoop], pPlayer:GetNumCities(), 2, {",", ":"}, 1);
			if DebugMode then
				print("Save Data Created");
				print(tbl);
			end
			pPlayer:SetScriptData(tbl);
		end
	end
end


function isValidPlayer(pPlayer)
	return pPlayer ~= nil and pPlayer:IsAlive() and pPlayer:GetNumCities() > 0;
end

function rangeOf(iVal, iMin, iMax)
	if (iVal > iMax) then
		return iMax;
	elseif (iVal < iMin) then
		return iMin;
	end
	return iVal;
end

function getStabilityIndex(pCity)
	if PlayersIndex[pCity:GetOwner()] then
		for i = 1, Players[pCity:GetOwner()]:GetNumCities(), 1 do
			if PlayersIndex[pCity:GetOwner()][i][1] == pCity:GetID() then
				return PlayersIndex[pCity:GetOwner()][i][2];
			end
		end
	end
	return 0;
end

function setStabilityIndex(pCity, iNewVal)
	local bSuccess = false;
	for i = 1, Players[pCity:GetOwner()]:GetNumCities(), 1 do
		if PlayersIndex[pCity:GetOwner()][i][1] == pCity:GetID() then
			PlayersIndex[pCity:GetOwner()][i][2] = rangeOf(iNewVal, iStabilityMin, iStabilityMax);
			bSuccess = true;
			break;
		end
	end
	if not bSuccess then
		table.insert(PlayersIndex[pCity:GetOwner()], {pCity:GetID(), iNewVal});
	end
end

function changeStabilityIndex(pCity, iChange)
	setStabilityIndex(pCity, getStabilityIndex(pCity) + iChange);
end

function doRevolt(pCity, pOwner)
	updateStability(pCity, pOwner);
	local iIndex = getStabilityIndex(pCity);
	if (iIndex < iWarningThreshold) then
		spawnRebels(pCity);
	end
end

function spawnRebels(pCity)
	pBarbarian = Players[GameDefines.BARBARIAN_PLAYER];
	if (true) then
		for thisDirection = 0, (DirectionTypes.NUM_DIRECTION_TYPES-1), 1 do
			local adjacentPlot = Map.PlotDirection(pCity:GetX(), pCity:GetY(), thisDirection);
			if (adjacentPlot) then
				local unitCount = adjacentPlot:GetNumUnits();
				if unitCount == 0 then
					local domainType = "DOMAIN_LAND";
					if adjacentPlot:IsWater() then
						domainType = "DOMAIN_SEA"
					end
					local eBestUnit = getBestSpawnUnit(pBarbarian, domainType)
					if eBestUnit ~= -1 then
						pBarbarian:InitUnit(eBestUnit, adjacentPlot:GetX(), adjacentPlot:GetY());
						break;
					end
				end
			end
		end
	end
end

function isValidRebelUnit(eUnit)
	if (eUnit == -1 or eUnit == nil) then
		return false;
	end
	if (eUnit.Domain ~= "DOMAIN_LAND") then
		return false;
	end
	return true;
	--if (GameInfo.UnitClasses(eUnit.UnitClass)
end

function getUprisingUnitTypes(pCity, pRevPlayer, bCheckEnemy)

	local spawnableUnits = {};
	local trainableUnits = {};

	local pOwner = Players[pCity:GetOwner()];
	local iCurrentEra = pOwner:GetCurrentEra();

	local pEnemy = nil;
	if (bCheckEnemy and pRevPlayer:IsBarbarian()) then
		pEnemy = pRevPlayer;
	end

	local pCiv = GameInfo.Civilizations[pOwner:GetCivilizationType()];
	local condition = "CivilizationType = '" .. thisCiv.Type .. "'";

	for eUnit in GameInfo.Units() do
	
		for eUniqueUnit in GameInfo.Civilization_UnitClassOverrides( condition ) do
			if (eUniqueUnit.UnitClass == eUnit.UnitClass) then
				eUnit = eUniqueUnit;
			end
		end

		if (isValidRebelUnit(eUnit) then


		

			if pPlayer:CanTrain(eUnit.ID) then
				if eUnit.Domain == domainType then
					if eBestUnit == -1 or (eUnit.Combat > eBestUnit.Combat and eUnit.Combat > 0) then
						eBestUnit = eUnit;
					end
				end
			end
		end
	end
	return eBestUnit;
end

			# First check what units there are nearby
			if( not unitInfo.getPrereqAndTech() == TechTypes.NO_TECH ) :
				unitTechInfo = gc.getTechInfo( unitInfo.getPrereqAndTech() )

				if( unitTechInfo.getEra() > iOwnerEra - 3 ) :
					#if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel: %s requires knowledge of %s"%(unitInfo.getDescription(),unitTechInfo.getDescription()))
					if( len(ownerUnits) > 0 ) :
						if( ownerUnits[0].canAttack() ) :
							if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Owner has %d %s"%(len(ownerUnits),PyInfo.UnitInfo(ownerUnitType).getDescription()))

							if( unitInfo.getUnitAIType(UnitAITypes.UNITAI_ATTACK) or unitInfo.getUnitAIType(UnitAITypes.UNITAI_COUNTER) ):

								# Probability of spawning units based on those nearby
								for unit in ownerUnits :
									if( plotDistance( unit.getX(), unit.getY(), pCity.getX(), pCity.getY() ) < 7 ) :
										if( bIsBarb ) :
											spawnUnitID = ownerUnitType
										else :
											spawnUnitID = gc.getCivilizationInfo( pRevPlayer.getCivilizationType() ).getCivilizationUnits(unitClass)
										spawnableUnits.append( spawnUnitID )
										if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Can spawn from owner %s"%(PyInfo.UnitInfo(spawnUnitID).getDescription()))
										if( unitInfo.getDefaultUnitAIType() == UnitAITypes.UNITAI_CITY_DEFENSE ) :
											if( unitTechInfo.getEra() == iOwnerEra ) :
												if( spawnableUnits.count( spawnUnitID ) > 1 ) :
													break
											else :
												if( spawnableUnits.count( spawnUnitID ) > 3 ) :
													break
										else :
											if( unitTechInfo.getEra() == iOwnerEra ) :
												if( spawnableUnits.count( spawnUnitID ) > 3 ) :
													break
											else :
												if( spawnableUnits.count( spawnUnitID ) > 5 ) :
													break

								if( unitTechInfo.getEra() < iOwnerEra and unitTechInfo.getEra() >= iOwnerEra - 2) :
									# Can spawn old units from further away
									for unit in ownerUnits :
										if( unit.area().getID() == pCity.area().getID() ):
											if( bIsBarb ) :
												spawnUnitID = ownerUnitType
											else :
												spawnUnitID = gc.getCivilizationInfo( pRevPlayer.getCivilizationType() ).getCivilizationUnits(unitClass)

											if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Outdated unit in Area %s"%(PyInfo.UnitInfo(ownerUnitType).getDescription()))
											if( pCity.canTrain(ownerUnitType,False,False, False, False) ) :
												spawnableUnits.append( spawnUnitID )
												if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Can spawn outdated unit from Area buildable %s"%(PyInfo.UnitInfo(spawnUnitID).getDescription()))

											break

					if( not enemyPy == None ) :
						enemyUnitType = gc.getCivilizationInfo( pRevPlayer.getCivilizationType() ).getCivilizationUnits(unitClass)
						enemyUnits = enemyPy.getUnitsOfType( enemyUnitType )
						if( len( enemyUnits ) > 0 ) :
							if( enemyUnits[0].canAttack() ) :
								if( unitInfo.getUnitAIType( UnitAITypes.UNITAI_ATTACK )  ):
									iCount = 0
									for unit in enemyUnits :
										if( plotDistance( unit.getX(), unit.getY(), pCity.getX(), pCity.getY() ) < 7 ) :
											spawnableUnits.append( enemyUnitType )
											if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Can spawn from enemy %s"%(PyInfo.UnitInfo(enemyUnitType).getDescription()))

											iCount += 1
											if( unitInfo.getDefaultUnitAIType() == UnitAITypes.UNITAI_CITY_DEFENSE and iCount > 1 ) :
												break
											elif( iCount > 3 ) :
												break

			if( pCity.canTrain(ownerUnitType,False,False,False,False) ):
				if( unitInfo.getUnitAIType( UnitAITypes.UNITAI_ATTACK ) ):
					if( bIsBarb ) :
						spawnUnitID = ownerUnitType
					else :
						spawnUnitID = gc.getCivilizationInfo( pRevPlayer.getCivilizationType() ).getCivilizationUnits(unitClass)

					trainableUnits.append( spawnUnitID )
					if( unitInfo.getCombat() > 4 ) :
						trainableUnits.append( spawnUnitID )
						if( unitInfo.getCombat() > 15 ) :
							trainableUnits.append( spawnUnitID )
					if( LOG_DEBUG and not bSilent ) : CvUtil.pyPrint("Rebel:  Can build %s"%(PyInfo.UnitInfo(spawnUnitID).getDescription()))

		if( len(spawnableUnits) < 1 ) :
			spawnableUnits = trainableUnits

		return spawnableUnits

--ToDo, lot more factors.
function updateStability(pCity, pOwner)
	print(string.format("Stability: %d", pOwner:GetExcessHappiness()));
	changeStabilityIndex(pCity, pOwner:GetExcessHappiness());
end

Events.ActivePlayerTurnStart.Add(doRevolutions);
