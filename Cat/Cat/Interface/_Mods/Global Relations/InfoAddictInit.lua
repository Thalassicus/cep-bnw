-- InfoAddictInit
-- Author: robk
-- DateCreated: 11/29/2010 10:29:21 PM
--------------------------------------------------------------

-- Init file for Info Addict. This file gets called by InGameUIAddin and is the entry
-- point for most of the mod. The contexts below are loaded after all the contexts in
-- InGame.xml. 


-- Setting up the main shared table for the mod
MapModData.InfoAddict = {};


-- Data manager for InfoAddict. Data collection and ongoing data managment happens here.
--ContextPtr:LoadNewContext("InfoAddictDataManager");


-- Main UI context for the InfoAddict GUI. To reference the context pointer for
-- InfoAddictScreen from other places(these contexts don't appear in ContextPtr:LookUpControl()
-- as far as I know), I'm saving the context pointer in the shared MapModData table.

MapModData.InfoAddict.InfoAddictScreenContext = ContextPtr:LoadNewContext("InfoAddictScreen");
MapModData.InfoAddict.InfoAddictScreenContext:SetHide(true);


-- Load the UI hooks for InfoAddict
ContextPtr:LoadNewContext("InfoAddictHooks");

