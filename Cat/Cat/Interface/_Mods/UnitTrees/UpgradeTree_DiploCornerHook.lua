function OnDiploCornerHook()
  print("OnDiploCornerHook()")
  LuaEvents.UpgradeTreeDisplay() 
end
LuaEvents.DiploCornerAddin({text="TXT_KEY_UPGRADE_DIPLO_CORNER_HOOK", tip="TXT_KEY_UPGRADE_DIPLO_CORNER_HOOK_TT", group="military", call=OnDiploCornerHook}) 
