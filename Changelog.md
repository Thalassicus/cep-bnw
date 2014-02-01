### Communitas Expansion Project changelog

This is the changelog from version 3.9 onward.
Where possible the line that describes the change will have the same or similar wording to the commit that it is tied to.

A more generalized overview of changes to the mod can be found on the [Releases](https://github.com/Thalassicus/cep-bnw/releases) tab.
For the average user this changelog will describe things that may not be of concern.

If you wish to see the changes from previous versions there are a couple of options available:

+ Build a time machine and go back and write this file as new changes occur. (may incur a paradox issue)
+ Examine the commits and apply logic to decide which code changes apply where/when.
+ Read all the forum posts, mod release files and other data you may find.

If none of the options above work then please proceed on to the change log below.

Newer changes are made at the top and the oldest is at the bottom.

==================================================================


*	Policy adjustments 3  --  Landed Elite now provides 1 Food per 4 pop in the capital, Spoils of War gives 3x the value of units.
*	Policy adjustments 2  --  CounterIntelligence doubles anti-spy building production, Secularism increases Science from specialists
*	Policy adjustments -- Citizenship grants 1 Worker, Cultural Diplomacy gives a 10% boost to Great People production, Ethics now 25% to Tourism
*	Artistic Genius -- Fixes the Great person rates
*	Spelling error -- minor hang over from previous spelling fix
*	CSD visual error -- CSD civil servant was lacking a reference to an icon
*	Reference & block -- A small reference fix for the mod 'Beyond the Future'
*	Hanseatic League fix -- A rogue 's' corrupted the function call. grrrr!!!
*	Conquistador -- The new 'dummy' unit now correctly replaces the Conquistador once the religion spread is used
*	Unused units -- Marine & Anti Tank Gun are now correctly removed in the Tech tree
*	Obsolete code location -- The Scout obsolescence is handled by this code
*	Spelling error fix
*	Syntax error fix
*	Handicap Modifications -- Incorporated the Google spreadsheet figures in a better format
*	CityView.lua -- A number of 'fixes' to make CSD & CEP work nicely together
*	DISABLE_GOLD_GIFTS -- This is now handled by the CSD mod
*	Load order -- Rearranged the order of some files to fix certain bugs
*	SQL load checks -- Added more checks for file loading
*	CSD compatibility -- Changes by both sets of mod authors make using both these mods together possible
*	Humanism -- This policy was unintentionally granting happiness from Research labs
*	Greek words -- various texts that had Greek lettering were being corrupted
*	Tradition wonder -- Tradition now has Banaue Rice Terraces as the wonder for its opener
*	Modified AI promotion -- Removed the +2 visibility, removed accelerated XP gain & added garrison bonus
*	Feed the World -- Reduced the food from 3 to 2
*	Removed GP tweak -- the YIELD_CULTURE wasn't used by specialists so was removed to avoid possible future bugs
*	Handicaps -- Moved various handicaps into difficulty specific sections
*	Phalanx bonus -- This bonus should now correctly apply against MELEE units also
*	Mercenary Army -- This policy should now grant the units it was supposed to grant
*	Golden Age yield fix -- Effect now matches the description
*	Candi -- This unique garden variant wasn't giving +1Food like other gardens
*	Korean trait -- fixes the crossed over specialist yields
*	Move after attack -- some promotions were removing the extra movement points after attacking, this is the fix
*	Ceremonial Rites -- now gives Culture for buildings
*	Unit resources -- removed the strategic resources from Gatling Guns, Machine Guns & Bazookas
*	Walls -- conquest probability now at 25%
*	Scouts upgrades -- Now obsolete at Metal Casting to allow longer periods of use
*	spelling fix
*	Divine Inspiration -- Should now generate Tourism for all wonders
*	Babylonian UA text -- Only 1 Great Scientist
*	Ranged Blitz text -- should now correctly show 90%
*	Jungle farms -- the required tech is needed before farms may be built
*	Caravans -- changed the value to make them more worthwhile
*	AI updates
*	CS information -- Text for the changed influence from removing barbarians for CS
*	Ethiopian Stele -- Slight fix for the Stele
*	Armies & Research -- refer to the [Releases](https://github.com/Thalassicus/cep-bnw/releases) page
*	Renowned unit story -- Swordsman & Composite Bowman are now the units upgraded to
*	Debug text -- Clarified the text
*	City-state Capture -- changed the outcomes
*	Ethiopia Fix -- The Stele is given +1Faith per pop.

**3.13** -- AI Handicaps

*	Possible Civilopedia crash fix -- Addresses the problem of different DLC content changing the files
*	Ottoman Fix -- The Ottoman UA is now working as expected
*	Armies -- Various changes to the military units
*	Spelling fixes -- Policies had a few errors


**3.12** -- Promotion Icons

*	Stories -- Scout story updrade to 'Sentinel' error
*	Syntax fix -- Production queue problem due to syntax error
*	Adjusted AI -- Diplomatic weightings are adjusted
*	Lighthouse fix
*	Minor fixes -- Less Tourism & more Culture
*	Minor fixes -- Egyptian Chariot doesn't 'goodyhutupgrade', lower vanguard costs, changes to seaports

**3.11** -- Flag Promotions

*	Stories -- Stories reactivated, minor adjustments to AI Gold, aqueducts on lakes
*	Blank TECH fix -- The removal of the TECH_FUTURE_TECH from the Marine & Anti-Tank had unexpected consequences
*	CN Tower -- Moved it TECH_ELECTRONICS as the required tech as it currently is 4 tiers away from the free building it grants
*	Minor text fixes -- Marine & Anti-Tank no longer show in pedia, Bireme & Projects have minor visual changes in the TECH tree
*	Wealth policy -- The opening pick now gives the +15% to Gold & Production
*	Smith -- Minor fixes
*	Steam Mill -- Fixed some requirements that it lacked as a Factory replacement
*	Workshop -- Fixed the TXT_KEY reference, moved it to Metal Casting, removed the "On Flat" requirement, and other minor tweaks
*	Polder -- Added the polder to the BuildFeatures table. Jungle/forest must now be cleared first.
*	Carvel Hulls -- Removed the audio from this tech to match the options
*	Trade Office -- Fixed the costing error
*	Policy - Discipline -- Now provides a Great General upon selection
*	Cultural Centers & Unity -- Fixed more code with these policies
*	Churches of Lalibela -- Added the prerequisite of being in the Holy City, to stop it being built without religion
*	Flourishing Arts policy -- Changed the text to match the effect and changed the FLAVOR to Archaeology & Tourism
*	Conquistador fix -- Removed the modded changes which rendered the unit impotent as a military unit
*	Mongol Code -- Moved the Mongol trait code back into xml away from lua code
*	TerrainType fix -- Coastal tiles should now give +2 Food
	
**3.10** -- GP spawn rate lowered, Gardens increase that rate, Specialists are available from more buildings

*	Hand-Axe movement fix -- The Hand-axe was incorrectly set the movement rate of a 'chariot'
*	Terracotta Army GP -- This Wonder had a GP rate but no GP was set
*	Syntax fix -- Corrected sql syntax in the CEP_Start.sql
*	IsVisible Check -- CityView.lua wasn't making the check for the tag 'IsVisible'
*	City-State greeting -- Changed the text to read the same regardless of whether you are first or not
*	Phalanx promotion -- Changed it to 'Bonus against Mounted'
*	AI Raze check -- The AI now checks whether it is possible to raze before taken that action
*	Mongol UA fix -- Raised the military might needed allowing greater bullying of CS. Fixed the Liberate call for CS taken with this UA
*	Jesuit Education fix -- Added the Library to the belief, missing in the vanilla code
*	Eiffel Tower fix -- Synced the +12 Tourism enhanced yield to the prerequisite tech
*	Ceremonial Burial fix -- Corrected the text to show +1 Happiness per 2 cities
*	Great Hall Flavor change -- This was made to help the lua code for the policies to not view this building as avaliable
*	Minor changes -- Barbarian camp changes to spawn rate and distance. 'Unit boarding' changed to 'OFF' by default

**3.9.4** -- Merge of branches and some minor production changes to 'Forests'

*	More policy fixes -- 'Ethics' incorrectly referred to as 'Cultural Exchange'
*	BLANK Leader personality -- The Google docs missed a '0' in the generated sql code
*	Capital double fix -- After the lua code was fixed the XML defining the Palace needed work
*	Policy fixes -- 'Fine Arts' text was causing problems with 'Homestead Act','Cultural Centers' & 'Ceremonial Rites'
*	Lowered AIBonuses -- Two commits that looked at how the Science yields are affected by the AIResearchPercent bonus

**3.9.3 -- Major Bug/Hotfix release.** -- Focus was on the YieldLibrary, leader personalities & flavors, Exploration & Liberty policies

**3.9.2 -- Second Hotfix release.**

**3.9.1 -- Minor hotfix release.** Quickly pulled and replaced.

*	Capital fix -- The code for the Capital displaying twice
*	Text changes -- A couple of minor text changes to policies and beliefs. Also changed the Google docs
*	Temporary Policy fix -- See this issue [52](https://github.com/Thalassicus/cep-bnw/issues/52)
*	TECH_NULL -- A bug with the Google spreadsheet meant a NULL wasn't being foramtted as TECH_NULL
*	Wonder unlock fix -- A newer more elegant way of 'NULL'ing out the wonders. Also affects the Google docs
*	Dutch Trade Office -- The Dutch were missing their UB and thus the older defunct Sea Beggar showed up, but was not available
*	Tooltip fix -- A rogue comma in place of an apostrophe
*	Wonder unlocks -- Commented out the Wonders granted from the old policies
*	Honor policy fix -- Culture from Barbarians killed value was tweaked down (5x to 2x the Strength in Culture given)
*	Final Policy updates -- Further changes to a number of different files and fields
*	Policy updates -- Mainly to do with FLAVOR and Era adjustments
*	Unit Prerequisites -- Unit prereqs were fixed by changing UnitClass' to 'Class'
*	Major additions to Aesthetics -- This policy tree was added and reworked
*	Stonehenge -- Stonehenge was given the TXT_KEY_GENERIC to remove the 'Good for:' & 'Abilities:' showing on its splash screen
*	TXT_KEY_GENERIC -- The text in this field was changed to a blank as the field still appears on some panels
*	Bushido -- The mod version of the Japanese ability was removed as it added no new information
*	Flavian Amphitheatre -- The *.dds file was not called correctly due to a name change
*	Minor text fix -- 'One With Nature' belief has a minor change 
*	Spaceship Projects -- Minor code change to make the Apollo project and the spaceship parts different
*	Carvel Hulls -- A dummy TXT_KEY_GENERIC was added to the HELP field which also helped fix the TechPopup/City Capture bug
*	COALITIONIST -- PERSONALITY_COALITION was incorrectly referred to as COALITIONIST
*	Holiday definitions -- Some more holidays were added to the code
*	Carvel Hulls -- The definition lacked a HELP field which produced lua errors with a 'nil' field
*	Minor text fixes -- The city capture text for 'FORCE' was changed and the TXT_KEY for Golden Ages was added

**3.9 -- Initial Release** Includes changes to Wonders and the Policy trees.
