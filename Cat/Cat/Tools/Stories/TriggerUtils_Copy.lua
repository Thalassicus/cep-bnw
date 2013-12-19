-- TriggerUtils.lua
-- Author: Thalassicus
-- Based on work by: Hipfot, Skodkim, Spatzimaus, and VeyDer
--------------------------------------------------------------

include( "ThalsUtilities.lua" )

local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

function _AddNewUnit( playerID, unit_type, x, y )
	if type( playerID.GetID ) == "function" then
		playerID = playerID:GetID();
	end
	if type( unit_type ) == "string" then
		unit_type = GameInfo.Units[ unit_type ];
	end
	if unit_type == nil then
		return;
	else
		unit_type = unit_type.ID;
	end

	Players[ playerID ]:InitUnit( unit_type, x, y );
end
LuaEvents._AddNewUnit.Add( _AddNewUnit );

function _City ( pCity, func, ... )
	local params = {...};
	if type(pCity) == "number" then
		return;
	end
	return pCity[ func ]( pCity, unpack( params ) );
end
LuaEvents._City.Add( _City );

function _ExecuteAfterTurns( delay, ... )
	local turn = Game.GetGameTurn() + delay;
	local params = {...};
	_ExecuteOnTurn( turn, unpack( params ) );
end
LuaEvents._ExecuteAfterTurns.Add( _ExecuteAfterTurns );

function _ExecuteOnTurn( turn, ... )
	local params	= {...};
	local pPlayer	= Players[ Game.GetActivePlayer() ];
	local key		= "__turn_queue_" .. turn;
	local turn_data = load( pPlayer, key ) or {};
	table.insert( turn_data, params );
	save( pPlayer, key, turn_data );
end
LuaEvents._ExecuteOnTurn.Add( _ExecuteOnTurn );

function _Player ( pPlayer, func, ... )
	local params	= {...};
	if type(pPlayer) ~= "table" then
		pPlayer	= Players[ pPlayer ];
	end
	if pPlayer == nil then
		return;
	end

	return pPlayer[ func ]( pPlayer, unpack( params ) );
end
LuaEvents._Player.Add( _Player );

function _PlayerChangeHappiness( pPlayer, modifier )
	local curr_happiness = _Player( pPlayer, "GetHappiness" );
	_Player( pPlayer, "SetHappiness", curr_happiness + modifier );
end
LuaEvents._PlayerChangeHappiness.Add( _PlayerChangeHappiness );

function _PlayerHasTech( pPlayer, tech )
	if type( tech ) == "string" then
		tech	= GameInfo.Technologies[ tech ].ID;
	end

	local team	= Teams[ _Player( pPlayer, "GetID" ) ];
	return team:IsHasTech( tech );
end
LuaEvents._PlayerHasTech.Add( _PlayerHasTech );
LuaEvents._PlayerHasTechnology.Add( _PlayerHasTech );

function _PlayerSetTech( pPlayer, tech, has )
	if type( tech ) == "string" then
		tech	= GameInfo.Technologies[ tech ].ID;
	end
	local team	= Teams[ _Player( pPlayer, "GetID" ) ];
	if has == true or has == 1 then
		has	= true;
	else
		has	= false;
	end
	team:SetHasTech( tech, has );
end
LuaEvents._PlayerSetTech.Add( _PlayerSetTech );
LuaEvents._PlayerSetTechnology.Add( _PlayerSetTech );

function _Plot ( pPlot, func, ... )
	local params	= {...};
	pPlot[ func ]( pPlot, unpack( params ) );
end
LuaEvents._Plot.Add( _Plot );

function _Shuffle( t )
	local n = #t
	while n > 1 do
		local k = math.random( n )
		t[ n ], t[ k ]	= t[ k ], t[ n ]
		n = n - 1
	end
	return t
end
LuaEvents._Shuffle.Add( _Shuffle );


function _ToNumber( a )
	local a2	= tonumber( a );
	if a2 ~= nil then
		return a2;
	end
	if type( a ) == "boolean" then
		if a then
			return 1;
		else
			return 0;
		end
	end
	return nil;
end
LuaEvents._ToNumber.Add( _ToNumber );

function _TurnQueueHandler()
	local turn		= Game.GetGameTurn();
	local pPlayer	= Players[ Game.GetActivePlayer() ];
	local key		= "__turn_queue_" .. turn;
	local turn_data	= load( pPlayer, key ) or {};

	for i, event in pairs( turn_data ) do
		local func_name	= event[ 1 ];
		table.remove( event, 1 );
		LuaEvents[ func_name ]( unpack( event ) );
	end
end
Events.ActivePlayerTurnStart.Add( _TurnQueueHandler );

function _Unit ( pUnit, func, ... )
	local params	= {...};
	if type(pUnit) == "number" then
		return;
	end
	return pUnit[ func ]( pUnit, unpack( params ) );
end
LuaEvents._Unit.Add( _Unit );

function DoAlertMessage( text, player, city, unit, plot )
	local activeTeamID = Game.GetActiveTeam()

	if player and Teams[player:GetTeam()]:IsHasMet(activeTeamID) then
		player = player:GetName()
	else
		player = Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
	end

	if city and city:IsRevealed(activeTeamID) then
		city = city:GetName()
	else
		city = Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
	end

	if unit and not unit:IsInvisible(activeTeamID) then
		unit = Locale.ConvertTextKey(GameInfo.Units[unit:GetUnitType()].Description)
	else
		unit = Locale.ConvertTextKey("TXT_KEY_DISTANT_UNIT")
	end

	plot = ""

	local message = Locale.ConvertTextKey(text, player, city, unit, plot)

	log:Debug(message)
	Events.GameplayAlertMessage(message)
end
LuaEvents.DoAlertMessage.Add( DoAlertMessage );