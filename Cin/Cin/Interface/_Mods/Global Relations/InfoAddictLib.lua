-- InfoAddictLib
-- Author: robk
-- DateCreated: 10/3/2010 4:54:46 PM
--------------------------------------------------------------

-- Uncomment this if it seems like nothing is loading at all and
-- you want to make sure it's not just the logger messing up.
-- print "Processing InfoAddictLib"

-- Set up the logging facility




-- Set this to return true to use the in game replay data instead of the data that
-- InfoAddict collects on its own.

function useReplayData() return false; end



-- The default and max number of labels on the x-axis and the optional y-axis for the historical graphs
-- are defined here. Once the sliders are changed in the options menu, the value is pulled from
-- the options in the mod user database.

function defaultNumXLabels() return 4; end
function defaultNumYLabels() return 4; end

function maxNumXLabels() return 10; end
function maxNumYLabels() return 20; end




-- Mod ID and version for accessing the shared mod user database.

function InfoAddictModID()
  return "robk_InfoAddict";
end;

function InfoAddictModVer()
  return 1;
end;

function InfoAddictModGUID()
  return "55b74e57-9a4b-4bb1-a514-a00f0646c359";
end;


-- Open a persistent connection to the user database.

local modUserData = Modding.OpenUserData(InfoAddictModID(), InfoAddictModVer());



-- Control option to see all empires regardless if we've met them or not. Set seeThem() to
-- true to cheat, you cheating cheater. The warning popped up a little too often so I've slapped
-- a timer onto it to keep it from being too annoying. It should only show up periodically now.

local lastCheatWarn = 0;
local cheatWarnInterval = 15;
local seeThem = false;

function seeEveryone()
  if (seeThem) then
    local now = os.time();
    if (now - lastCheatWarn > cheatWarnInterval) then
      --logger:warn("OMG you can see everyone!!  CHEEEEEEEE-TERRRRRRRR");
      lastCheatWarn = os.time();
    end;
  end;
  return seeThem;
end;

-- Call this from the tuner to toggle seeThem on and off.

function toggleSeeThem()
  if (seeThem) then
    --logger:warn("Cheat mode disabled");
    seeThem = false;
  else
    --logger:warn("Cheat mode just activated");
    seeThem = true;
  end
end



-- Feed this function a time (os.clock) and it'll return how much time has passed
-- since that time in string format. If you feed it the future, it will barf.

function elapsedTime(starttime)

  local now = os.clock();

  if (starttime > now) then
    --logger:warn("printPerfData sez BAAARRRRFFFFF");
  else
    local diff = now - starttime;
	  return(Locale.ToNumber(diff, "#.####") .. "s");
  end
  
end;



-- Gets a value from the replay data cache along with a few checks to make sure the player
-- was alive and that the data is actually valid.

function getHistoricalValue(turn, pid, type)

  -- The first turn will always have 0 values since we're reporting the value
  -- of the data type at the -beginning- of the turn instead of at the -end-
  -- of the turn, which is how Info Addict behaved prior to v16 / civ verison
  -- 1.0.1.332.

  if (turn == Game.GetStartTurn()) then
    return 0;
  end;

  if (useReplayData() == false) then
    if (MapModData.InfoAddict.HistoricalData[turn] == nil) then return nil end;
    if (MapModData.InfoAddict.HistoricalData[turn][pid] == nil) then return nil end;
    return MapModData.InfoAddict.HistoricalData[turn][pid][type];
  else

    local realtype = GetReplayType(type);
    local alivetype = GetReplayType("alive");

    if (MapModData.InfoAddict.ReplayDataCache[pid] == nil) then return nil end;
    if (MapModData.InfoAddict.ReplayDataCache[pid][realtype] == nil) then return nil end;
  
    -- Check to see if the player was alive during this turn. If not, we return a nil
    -- value.

    if (MapModData.InfoAddict.ReplayDataCache[pid][alivetype][turn] == 0) then
      return nil;
    end;
    
    return MapModData.InfoAddict.ReplayDataCache[pid][realtype][turn];

  end;

end;



-- Converts the InfoAddict name for a data type to the type name that the civ engine
-- stores the data in natively. If the data type is not a native one, the original data type
-- is returned.

function GetReplayType(type)

  if (type == "score") then return "REPLAYDATASET_SCORE";
  elseif (type == "military") then return "REPLAYDATASET_MILITARYMIGHT";
  elseif (type == "culture") then return "REPLAYDATASET_CULTUREPERTURN";
  elseif (type == "happiness") then return "REPLAYDATASET_EXCESSHAPINESS";
  elseif (type == "science") then return "REPLAYDATASET_SCIENCEPERTURN";
  elseif (type == "land") then return "REPLAYDATASET_TOTALLAND";
  elseif (type == "production") then return "REPLAYDATASET_PRODUCTIONPERTURN";
  elseif (type == "population") then return "REPLAYDATASET_POPULATION";
  elseif (type == "grossgold") then return "REPLAYDATASET_GOLDPERTURN";
  elseif (type == "totalgold") then return "REPLAYDATASET_TOTALGOLD";
  elseif (type == "food") then return "REPLAYDATASET_FOODPERTURN";
  elseif (type == "numcities") then return "REPLAYDATASET_CITYCOUNT";
  elseif (type == "policies") then return "REPLAYDATASET_NUMBEROFPOLICIES";
  elseif (type == "techs") then return "REPLAYDATASET_TECHSKNOWN";

  -- Types that follow are unique to InfoAddict
  elseif (type == "wonders") then return "INFOADDICTDATASET_WONDERS";
  elseif (type == "gold") then return "INFOADDICTDATASET_NETGOLDPERTURN";
  elseif (type == "alive") then return "INFOADDICTDATASET_ALIVE";
  elseif (type == "realpopulation") then return "INFOADDICTDATASET_REALPOPULATION";
  end;

  return type;
end;



-- Returns true or false on whether the active player has met a civ. Takes the
-- civ pid as the argument.

function hasMetCiv(pid)
  local pPlayer = Players[pid];
  local pTeam = Teams[pPlayer:GetTeam()];
  return not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive() and
    (pTeam:IsHasMet(Game.GetActiveTeam()) or seeEveryone())
end;


-- Returns the number of civs that the active player has currently met.

function getVisibleCivCount()
  local civcount = 0
  for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
    if( hasMetCiv(iPlayerLoop) ) then
      civcount = civcount + 1;
    end;
  end;
  return civcount;
end;


-- Get a count of all active civs whether we've met them or not.

function getAllCivCount()
  local civcount = 0
  for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
    local pPlayer = Players[iPlayerLoop];
    if( not pPlayer:IsMinorCiv() and pPlayer:IsEverAlive() ) then
      civcount = civcount + 1;
    end;
  end;
  return civcount;
end;


-- Given a civ Pid, return a full civ title that looks like "Washington of
-- the American Empire".

function getFullLeaderTitle(pid)

  local player = Players[pid];
  local name = Locale.ConvertTextKey( GameInfo.Civilizations[ player:GetCivilizationType() ].Description );
  local leader = player:GetName();
  return leader .. " " .. Locale.ConvertTextKey("TXT_KEY_INFOADDICT_OF_THE") .. " " .. name;

end;


-- Returns a civ name that fits within the number of characters specified. Best effort is made
-- to not chop the string off the end but will end up doing so if no other recourse is found.

function getCivNameThatFits(pid, length)
  local player = Players[pid]
  local civName = Locale.ConvertTextKey( GameInfo.Civilizations[ player:GetCivilizationType() ].ShortDescription )

  -- Try out the first word of the civ description since it's usually "Somethingish Empire".
  if (string.len(civName) > length) then
    local civDesc = Locale.ConvertTextKey( GameInfo.Civilizations[ player:GetCivilizationType() ].Description)
    civName = string.match(civDesc, "%a+");
  end

  -- Still not good? Well, I guess we need to snip then.
  if (string.len(civName) > length) then
    civName = string.sub(civName, 0, length)
  end

  return civName
end


-- Given a civ Pid, returns the text color specifier associated with that empire. Alpha in ratio
-- format (from 0 to 1) is required to set the text alpha. Brighten is a boolean that, when set to
-- true, attempts to brighten the text of dark civs by bumping up the color components to a minimum
-- level. It may distort the colors somewhat but will make them more visible on a darker background.

function getCivTextColor(pid, alpha, brighten)

  local pPlayer = Players[pid];
  local _, primaryColor = pPlayer:GetPlayerColors();

  local brightest = 0;
  local x255 = math.floor(primaryColor.x * 255);  if (x255 > brightest) then brightest = x255 end;
  local y255 = math.floor(primaryColor.y * 255);  if (y255 > brightest) then brightest = y255 end;
  local z255 = math.floor(primaryColor.z * 255);  if (z255 > brightest) then brightest = z255 end;
  local a255 = math.floor(alpha * 255);

  if (brighten) then
    local brightdiff = (200 - brightest)/brightest;
    if (brightdiff > 0) then
      x255 = math.floor(x255 + (x255 * brightdiff));
      y255 = math.floor(y255 + (y255 * brightdiff));
      z255 = math.floor(z255 + (z255 * brightdiff));
    end
  end

	local colorstring = "[COLOR:" .. x255 .. ":" .. y255 .. ":" .. z255 .. ":" .. a255 .. "]";
  --logger:trace("Colorstring = " .. colorstring);
  return colorstring;
end;


-- Given a civ pid, returns the Vector4 color specifier associated with that Empire. Alpha in ratio
-- format (from 0 to 1) is required to set the text alpha. Brighten is a boolean that, when set to
-- true, attempts to brighten the text of dark civs by bumping up the color components to a minimum
-- level. It may distort the colors somewhat but will make them more visible on a darker background.

function getCivColor(pid, alpha, brighten)

  --logger:trace("getCivColor(): Getting civ colors for pid " .. pid);

  local pPlayer = Players[pid];
  local _, primaryColor = pPlayer:GetPlayerColors();

  local x = primaryColor.x;
  local y = primaryColor.y;
  local z = primaryColor.z;

  local brightest = 0;
  if (x > brightest) then brightest = x end;
  if (y > brightest) then brightest = y end;
  if (z > brightest) then brightest = z end;

  if (brighten) then
    local brightdiff = (175/255 - brightest)/brightest;
    if (brightdiff > 0) then
      --logger:trace("Brightening by " .. brightdiff);
      x = x + (x * brightdiff);
      y = y + (y * brightdiff);
      z = z + (z * brightdiff);
    end
  end

  --logger:trace("getCivColor():   origx = " .. primaryColor.x .. ", origy = " ..
  --                primaryColor.y .. ", origz = " .. primaryColor.z);
  --logger:trace("getCivColor():   x = " .. x .. ", y = " .. y .. ", z = " .. z ..", alpha = " .. alpha);
  return Vector4(x, y, z, alpha);
end;



-- Get the current value of the given option

function getInfoAddictOption(option)
  local rowname = "option-" .. option;
  local value = modUserData.GetValue(rowname);
  --logger:trace("Retrieved option " .. rowname .. " = " .. tostring(value));
  return value;
end;


-- Set the current value for the given option

function setInfoAddictOption(option, value)
  local rowname = "option-" .. option;
  --logger:trace("Setting " .. rowname .. " to " .. tostring(value));
  modUserData.SetValue(rowname, value);
end;


-- Given a turn, this returns a string that represents the year with "AD" or "BC"
-- appended to it.

function getYearString(turn)
  local turnYear = Game.GetTurnYear(turn);
    
  local era = "AD";
  if (turnYear < 0) then
    era = "BC";
  end;
  turnYear = math.abs(turnYear);
  turnText = turnYear .. " " .. era;
  return turnText;
end


-- Given a number, this return a string of up to 4 characters that represents that number
-- with a k, M or G suffix. E.g. 100 = "100",  1000 = "1k", 100000 = "100k", etc.

function NumToLabel(number)

  local significand = 0;
  local suffix = "";

  if (number >= 1000000000) then
    suffix = "G";
    significand = number/1000000000;
  elseif (number >= 1000000) then
    suffix = "M";
    significand = number/1000000;
  elseif (number >= 1000) then
    suffix = "k";
    significand = number/1000;
  end

  if (suffix ~= "") then
    if (significand >= 10) then
      return Locale.ToNumber(significand, "#") .. suffix;
    else
      return Locale.ToNumber(significand, "#.#") .. suffix;
    end
  end
  
  return math.floor(number);

end


-- Function that spits out all attributes related to an object. Used for debugging.
function printObjAttr(object)
	for k, v in pairs(getmetatable(object).__index) do print(k) end
	end;



