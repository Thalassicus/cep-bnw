function OnDiploCornerHook()
  print("OnDiploCornerHook()")
  LuaEvents.PromotionTreeDisplay() 
end
LuaEvents.DiploCornerAddin({text="TXT_KEY_PROMO_DIPLO_CORNER_HOOK", tip="TXT_KEY_PROMO_DIPLO_CORNER_HOOK_TT", group="military", call=OnDiploCornerHook}) 
