### Communitas Expansion Project changelog

This is the changelog from version 3.9 onward.
Where possible the line that describes the change will have the same or similar wording to the commit that it is tied to.

If you wish to see the changes from previous versions there are a couple of options available:

+ Build a time machine and go back and write this file as new changes occur. (may incur a paradox issue)
+ Examine the commits and apply logic to decide which code changes apply where/when.
+ Read all the forum posts, mod release files and other data you may find.

If none of the options above work then please proceed on to the change log below.

Newer changes are made at the top and the oldest is at the bottom.

==================================================================

* Great Hall Flavor change -- This was made to help the lua code for the policies to not view this building as avaliable
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
