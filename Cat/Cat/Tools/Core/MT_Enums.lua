-- MT_Enums
-- Author: Thalassicus
-- DateCreated: 8/12/2013 8:55:33 AM
--------------------------------------------------------------


TipSection = {}
		
TipSection.BUILDING_HEADER			= 0
TipSection.BUILDING_SPECIAL_ABILITY	= 1
TipSection.BUILDING_ABILITY			= 2
TipSection.BUILDING_YIELD			= 3
TipSection.BUILDING_REQUIREMENT		= 4

TipSection.PROMO_RANGE				= 1
TipSection.PROMO_RANGED_STRENGTH	= 2
TipSection.PROMO_STRENGTH			= 3
TipSection.PROMO_MOVES				= 4
TipSection.PROMO_HEAL				= 5
TipSection.PROMO_SIGHT				= 6
TipSection.PROMO_AIR				= 7
TipSection.PROMO_NAVAL				= 8
TipSection.PROMO_GOLD				= 9
TipSection.PROMO_GREAT_GENERAL		= 10
TipSection.PROMO_RES_URANIUM		= 11
TipSection.PROMO_WAR				= 12
TipSection.PROMO_NEGATIVE			= 13
TipSection.PROMO_OTHER				= 14

TipSectionIcon = {
	[TipSection.PROMO_RANGE]			= "[ICON_RANGE_STRENGTH]"	,
	[TipSection.PROMO_RANGED_STRENGTH]	= "[ICON_RANGE_STRENGTH]"	,
	[TipSection.PROMO_STRENGTH]			= "[ICON_STRENGTH]"			,
	[TipSection.PROMO_MOVES]			= "[ICON_MOVES]"			,
	[TipSection.PROMO_HEAL]				= "[ICON_HEAL]"				,
	[TipSection.PROMO_SIGHT]			= "[ICON_SIGHT]"			,
	[TipSection.PROMO_AIR]				= "[ICON_AIR]"				,
	[TipSection.PROMO_NAVAL]			= "[ICON_NAVAL]"			,
	[TipSection.PROMO_GOLD]				= "[ICON_GOLD]"				,
	[TipSection.PROMO_GREAT_GENERAL]	= "[ICON_GREAT_GENERAL]"	,
	[TipSection.PROMO_RES_URANIUM]		= "[ICON_RES_URANIUM]"		,
	[TipSection.PROMO_WAR]				= "[ICON_WAR]"				,
	[TipSection.PROMO_OTHER]			= "[ICON_BULLET]"			,
	[TipSection.PROMO_NEGATIVE]			= "[ICON_ATTRIBUTE_NEGATIVE]"
}