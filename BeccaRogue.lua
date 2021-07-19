---@diagnostic disable: undefined-global, lowercase-global
local Tinkr = ...
local wowex = {}
local Routine = Tinkr.Routine
local Util = Tinkr.Util
local Draw = Tinkr.Util.Draw:New()
local E = Tinkr:require('Routine.Modules.Exports')
local lastdebugmsg = ""
local lastdebugtime = 0
local poisondelay = 0
Tinkr:require('scripts.cromulon.libs.Libdraw.Libs.LibStub.LibStub', wowex) --! If you are loading from disk your rotaiton. 
Tinkr:require('scripts.cromulon.libs.Libdraw.LibDraw', wowex) 
Tinkr:require('scripts.cromulon.libs.AceGUI30.AceGUI30', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-BlizOptionsGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-DropDownGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Frame' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-InlineGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-ScrollFrame' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-SimpleGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TabGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TreeGroup' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Window' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Button' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-CheckBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-ColorPicker' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown-Items' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-EditBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Heading' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Icon' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-InteractiveLabel' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Keybinding' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Label' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-MultiLineEditBox' , wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Slider' , wowex)
Tinkr:require('scripts.wowex.libs.AceAddon30.AceAddon30' , wowex)
Tinkr:require('scripts.wowex.libs.AceConsole30.AceConsole30' , wowex)
Tinkr:require('scripts.wowex.libs.AceDB30.AceDB30' , wowex)
Tinkr:require('scripts.cromulon.system.configs' , wowex)
Tinkr:require('scripts.cromulon.system.storage' , wowex)
Tinkr:require('scripts.cromulon.libs.libCh0tFqRg.libCh0tFqRg' , wowex)
Tinkr:require('scripts.cromulon.libs.libNekSv2Ip.libNekSv2Ip' , wowex)
Tinkr:require('scripts.cromulon.libs.CallbackHandler10.CallbackHandler10' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-20' , wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-pins-20' , wowex)
Tinkr:require('scripts.cromulon.interface.uibuilder' , wowex)
Tinkr:require('scripts.cromulon.interface.buttons' , wowex)
Tinkr:require('scripts.cromulon.interface.panels' , wowex)
Tinkr:require('scripts.cromulon.interface.minimap' , wowex)
--[[     Object = 0,
Item = 1,
Container = 2,
Unit = 3,
Player = 4,
ActivePlayer = 5,
GameObject = 6,
DynamicObject = 7,
Corpse = 8,
AreaTrigger = 9,
SceneObject = 10,
ConversationData = 11,
}; ]]
function hasbuff(spellname, unit)
  local unit = unit or 'player'
  if not spellname then return false end
  if (not UnitExists(unit) or UnitIsDeadOrGhost(unit)) then return false end
  for i = 1, 40 do
    local _, _, count, _, _, _, _, _, _, spellId, _, _, _, _, _ =
    UnitBuff(unit, i) --, "HELPFUL")
    local buffname,_ = GetSpellInfo(spellId) 
    if buffname == spellname then return true end
  end
  return false
end

function distancetwo(object)
  local X1, Y1, Z1 = ObjectPosition('player')
  local X2, Y2, Z2 = ObjectPosition(object)
  if X1 and Y1 and X2 and Y2 and Z1 and Z2 then
    return math.sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2))
  end
end

Draw:Sync(function(draw)
  local px, py, pz = ObjectPosition('player')
  local rotation = ObjectRotation("player")
  if wowex.wowexStorage.read('bladeflurrydraw') and hasbuff("Blade Flurry","player") then
    draw:Circle(px, py, pz, 4.5)
  end
  if wowex.wowexStorage.read('targetingusdraw') then
    for i, object in ipairs(Objects()) do
      if ObjectType(object) == 4 and UnitCanAttack("player",object) then
        if not ObjectTarget(object) == ObjectId("player") then
          local px, py, pz = ObjectPosition("player")
          local tx, ty, tz = ObjectPosition(object)
          if distancetwo(object) <= 8 then
            draw:SetColor(0,255,0)
          end
          if distancetwo(object) >= 8 and distancetwo(object) <= 30 then
            draw:SetColor(199,206,0)            
          end
          if distancetwo(object) >= 30 then
            draw:SetColor(255,0,0)
          end  
          draw:SetWidth(4)
          draw:SetAlpha(150)
          draw:Line(px,py,pz,tx,ty,tz,4,55)
        end
      end
    end 
  end
end)


local function Debug(text,spellid)
  if (lastdebugmsg ~= message or lastdebugtime < GetTime()) then
    local _, _, icon = GetSpellInfo(spellid)
    lastdebugmsg = message
    lastdebugtime = GetTime() + 2
    RaidNotice_AddMessage(RaidWarningFrame, "|T"..icon..":0|t"..text, ChatTypeInfo["RAID_WARNING"],1)
    return true
  end
  return false
end


Routine:RegisterRoutine(function()
  local GetComboPoints = GetComboPoints("player","target")
  local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
  local _, _, _, _, _, _, itemType5 = GetItemInfo(mainHandLink)
  if gcd() > latency() then return end
  if mounted() or UnitIsDeadOrGhost("player") or debuff(Gouge,"target") or buff(Vanish,"player") then return end
  local function InventorySlots()
    local slotsfree = 0
    for i = 0, 4 do
      freeslots, _ = GetContainerNumFreeSlots(i)
      slotsfree = slotsfree + freeslots
    end
    return slotsfree
  end
  local function GetFinisherMaxDamage(ID)
    local function GetStringSpace(x, y)
      for i = 1, 7 do
        if string.sub(x, y + i, y + i) then
          if string.sub(x, y + i, y + i) == " " then
            return i
          end
        end
      end
    end
    local f = GetSpellDescription(ID)
    local _, a, b, c, d, e = strsplit("\n", f)
    local aa, bb, cc, dd, ee = string.find(a, "%-"), string.find(b, "%-"), string.find(c, "%-"), string.find(d, "%-"), string.find(e, "%-")
    return tonumber(string.sub(a, aa + 1, aa + GetStringSpace(a, aa))), tonumber(string.sub(b, bb + 1, bb + GetStringSpace(b, bb))), tonumber(string.sub(c, cc + 1, cc + GetStringSpace(c, cc))), tonumber(string.sub(d, dd + 1, dd + GetStringSpace(d, dd))), tonumber(string.sub(e, ee + 1, ee + GetStringSpace(e, ee)))
  end
  local function GetAggroRange(unit)
    local range = 0
    local playerlvl = UnitLevel("player")
    local targetlvl = UnitLevel(unit)
    range = 20 - (playerlvl - targetlvl) * 1
    if range <= 5 then
      range = 10
    elseif range >= 45 then
      range = 45
    elseif UnitReaction("player", unit) >= 4 then
      range = 10
    end
    return range +2
  end
  
  local function IsFacing(Unit, Other)
    local SelfX, SelfY, SelfZ = ObjectPosition(Unit)
    local SelfFacing = ObjectRotation(Unit)
    local OtherX, OtherY, OtherZ = ObjectPosition(Other)
    local Angle = SelfX and SelfY and OtherX and OtherY and SelfFacing and ((SelfX - OtherX) * math.cos(-SelfFacing)) - ((SelfY - OtherY) * math.sin(-SelfFacing)) or 0
    return Angle < 0
  end
  local function IsBehind()
    if not IsFacing("target", "player") then
      return true
    end
  end
  local function Execute()
    --*Eviscerate=Attack Power * (Number of Combo Points used * 0.03) * abitrary multiplier to account for Auto Attacks while pooling
    local e1, e2, e3, e4, e5 = GetFinisherMaxDamage("Eviscerate")
    local ap = UnitAttackPower("player")
    local multiplier = wowex.wowexStorage.read("personalmultiplier")
    local evisc1calculated = ap * (1 * 0.03) + e1 * multiplier
    local evisc2calculated = ap * (2 * 0.03) + e2 * multiplier
    local evisc3calculated = ap * (3 * 0.03) + e3 * multiplier
    local evisc4calculated = ap * (4 * 0.03) + e4 * multiplier
    if not UnitIsPlayer("target") and castable(Eviscerate) then
      if UnitHealth("target") <= evisc1calculated and GetComboPoints == 1 then
        cast(Eviscerate)
      end
      if UnitHealth("target") <= evisc2calculated and GetComboPoints == 2 then
        cast(Eviscerate)
      end
      if UnitHealth("target") <= evisc3calculated and GetComboPoints == 3 then
        cast(Eviscerate)
      end
      if UnitHealth("target") <= evisc4calculated and GetComboPoints == 4 then
        cast(Eviscerate)
      end
      if GetComboPoints == 5 then
        cast(Eviscerate)
      end
    end
  end
  local function Defensives()
    if UnitAffectingCombat("player") then
      if castable(Feint) and health() <= 80 and UnitIsUnit("targettarget", "player") and (IsInInstance() or IsInRaid()) then
        cast(Feint)
      end
      if castable(Vanish) and health() <= wowex.wowexStorage.read('vanishhp',10) and GetItemCount(5140) > 0 and ttd("target") > 4 then
        cast(Vanish)
      end
      if castable(Evasion) and health() <= wowex.wowexStorage.read('evasionhp', 30) then
        cast(Evasion,"player")
      end
      if castable(Gouge) and health() <= wowex.wowexStorage.read('gougehp',0) and ttd("target") > 10 then
        cast(Gouge,"target")
      end
    end
  end
  local function Cooldowns()
  end
  local function Opener()
    if UnitCanAttack("player","target") and melee() then
      if buff(Stealth,"player") then
        if not IsBehind("target") then
          if wowex.wowexStorage.read("openerfrontal") == "Cheap Shot" and castable(CheapShot) then
            cast(CheapShot,"target")
          end
        end
        if IsBehind("target") then
          if wowex.wowexStorage.read("openerbehind") == "Garrote" and castable(Garrote) then
            cast(Garrote,"target")
          end
          if wowex.wowexStorage.read("openerbehind") == "Cheap Shot" and castable(CheapShot) then
            cast(CheapShot,"target")
          end
          if wowex.wowexStorage.read("openerbehind") == "Ambush" and castable(Ambush) then
            cast(Ambush,"target")
          end
        end
      end
    end
  end
  
  
  local function Dps()
    if UnitExists("target") and melee() and UnitCanAttack("player","target") and not buff(Stealth,"player") then
      kickNameplate(Kick, true)
      if not IsPlayerAttacking('target') then
        Eval('StartAttack()', 't')
      end
      if castable(SliceAndDice,"target") and GetComboPoints >= 2 and not buff(SliceAndDice, 'player') then
        cast(SliceAndDice,"target")
      end
      if castable(Riposte,"target") then
        cast(Riposte,"target")
      end
      --Test until replacement copied from cutegirl
      if wowex.wowexStorage.read('useExpose') and castable(ExposeArmor, 'target') and combo() == 5 and
      (not debuff(ExposeArmor, 'target') or debuffduration(ExposeArmor, 'target') < 2) and ttd() >15 then
        return cast(ExposeArmor, 'target')
      end
      if castable(SliceAndDice, 'target') and combo() >= 2 and buffduration(SliceAndDice, 'player') < 2 then
        return cast(SliceAndDice, 'target')
      end
      --if castable(Eviscerate, 'target') and combo() >= 3 and buffduration(Rapture, 'player') > 4 and
      --not debuff(Eviscerate, 'target') then
      --  return cast(Eviscerate, 'target')
      --end
      if castable(Rapture, 'target') and combo() >= 2 and between(2, buffduration(Rapture, 'player'), 4) then
        return cast(Rapture, 'target')
      end
    end
    
  end
  local function Loot()
    for i, object in ipairs(Objects()) do
      if ObjectLootable(object) and ObjectDistance("player",object) < 5 and ObjectType(object) == 3 then
        ObjectInteract(object)
      end
    end
    for i = GetNumLootItems(), 1, -1 do
      LootSlot(i)
    end
  end
  local function Project(X, Y, Z, Direction, Distance)
    return X + math.cos(Direction) * Distance, Y + math.sin(Direction) * Distance, Z
  end
  local function Distract()
    --*Throw Distract behind the enemy if its facing us to let us open with a behind opener
    if buff(Stealth,"player") and UnitCanAttack("player","target") and UnitExists("target") and not UnitAffectingCombat("target") and not UnitIsPlayer("target") and IsFacing("target", "player") and distance("player","target") <= 15 then
      local X, Y, Z = ObjectPosition("target")
      local SelfFacing = ObjectRotation("player")
      local ProjX, ProjY, ProjZ = Project(X, Y, Z, SelfFacing, 7)
      if ProjX and IsSpellKnown(1725) and (not IsInRaid() or not IsInInstance()) then
        cast("Distract",'none'):click(ProjX,ProjY,ProjZ)
      end
    end
  end
  local function Filler()
    if (not debuff(Sap,"target") and not debuff(Gouge,"target") and not debuff(Blind,"target") and not buff(Vanish,"player") and not buff(Stealth,"player")) and GetComboPoints < 5 and UnitCanAttack("player","target") and melee() then
      --Backstab/SS if Hemorrhage is not learned on Daggers
      if itemType5 == "Daggers" and not IsSpellKnown(26864) then
        if IsBehind() and castable(Backstab) then
          cast(Backstab,"target")
        end
        if not IsBehind() and castable(SinisterStrike) then
          cast(SinisterStrike,"target")
        end
      end
      --Cast Hemorrhage if its known
      if IsSpellKnown(26864) then
        if castable(Hemorrhage) then
          cast(Hemorrhage,"target")
        end
      end
      --SS Spam on everything else
      if not IsSpellKnown(26864) and itemType5 ~= "Daggers" then
        if castable(SinisterStrike) then
          cast(SinisterStrike,"target")
        end
      end
    end
  end
  --Poisons thanks rex
  function checkweaponenchants(hand)
    if not hand then return end
    local mainhandbuff, _, _, _, offhandbuff, _, _, _ = GetWeaponEnchantInfo()
    if mainhandbuff == true and hand == 'mainhand' then
      return true
    elseif offhandbuff == true and hand == 'offhand' then
      return true
    end
    return false
  end
  local function Poison()
    local deadlypoisonlist = {22054, 22053, 20844, 8985, 8984, 2893, 2892}
    local instantpoisonlist = {21927, 8928, 8927, 8926, 6950, 6949, 6947}
    local cripplingpoisonlist = {3776, 3775}
    local mindnumbingpoisonlist = {9186, 6951, 5237}
    local woundpoisonlist = {22055, 10922, 10921, 10920, 10918}
    if not UnitAffectingCombat("player") and GetUnitSpeed("player") == 0 then
      if not checkweaponenchants('mainhand') then
        if wowex.wowexStorage.read("mainhandpoison") == "Instant" then
          for i = 1, #instantpoisonlist do
            if GetItemCount(instantpoisonlist[i]) >= 1 and (GetItemCooldown(instantpoisonlist[i])) == 0 and poisondelay < GetTime() then
              local instantpoisonname = GetItemInfo(instantpoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. instantpoisonname .. '")', 'player')
              Eval('RunMacroText("/use 16")', 'player')
              Debug(instantpoisonname,2842)
            end
          end
        elseif wowex.wowexStorage.read("mainhandpoison") == "Wound" then
          for i = 1, #woundpoisonlist do
            if GetItemCount(woundpoisonlist[i]) >= 1 and (GetItemCooldown(woundpoisonlist[i])) == 0 and poisondelay < GetTime() then
              local woundpoisonname = GetItemInfo(woundpoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. woundpoisonname .. '")', 'player')
              Eval('RunMacroText("/use 16")', 'player')
              Debug(woundpoisonname,2842)
            end
          end
        elseif wowex.wowexStorage.read("mainhandpoison") == "Crippling" then
          for i = 1, #cripplingpoisonlist do
            if GetItemCount(cripplingpoisonlist[i]) >= 1 and (GetItemCooldown(cripplingpoisonlist[i])) == 0 and poisondelay < GetTime() then
              local cripplingname = GetItemInfo(cripplingpoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. cripplingname .. '")', 'player')
              Eval('RunMacroText("/use 16")', 'player')
              Debug(cripplingname,2842)
            end
          end
        end
      end
      if not checkweaponenchants('offhand') then
        if wowex.wowexStorage.read("offhandpoison") == "Deadly" then
          for i = 1, #deadlypoisonlist do
            if GetItemCount(deadlypoisonlist[i]) >= 1 and (GetItemCooldown(deadlypoisonlist[i])) == 0 and poisondelay < GetTime() then
              local instantpoisonname = GetItemInfo(deadlypoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. instantpoisonname .. '")', 'player')
              Eval('RunMacroText("/use 17")', 'player')
              Debug(instantpoisonname,2842)
            end
          end
        elseif wowex.wowexStorage.read("offhandpoison") == "MindNumbing" then
          for i = 1, #mindnumbingpoisonlist do
            if GetItemCount(mindnumbingpoisonlist[i]) >= 1 and (GetItemCooldown(mindnumbingpoisonlist[i])) == 0 and poisondelay < GetTime() then
              local mindnumbingname = GetItemInfo(mindnumbingpoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. mindnumbingname .. '")', 'player')
              Eval('RunMacroText("/use 17")', 'player')
              Debug(mindnumbingname,2842)     
            end
          end
        elseif wowex.wowexStorage.read("offhandpoison") == "Crippling" then
          for i = 1, #cripplingpoisonlist do
            if GetItemCount(cripplingpoisonlist[i]) >= 1 and (GetItemCooldown(cripplingpoisonlist[i])) == 0 and poisondelay < GetTime() then
              local cripplingname = GetItemInfo(cripplingpoisonlist[i])
              poisondelay = GetTime() + 4
              Eval('RunMacroText("/use ' .. cripplingname .. '")', 'player')
              Eval('RunMacroText("/use 17")', 'player')
              Debug(cripplingname,2842)
            end
          end
        end
      end
    end
  end
  local function pvp()
    for i, object in ipairs(Objects()) do
      if ObjectType(object) == 4 and UnitCanAttack("player",object) then
        if buff(Stealth,object) then
          if buff(Stealth,"player") and castable(Sap,object) then
            FaceObject(object)
            cast(Sap,object)
            Debug("Sap".." "..UnitName(object),11297)
          elseif castable(Gouge,object) then
            FaceObject(object)
            cast(Gouge,object)
            Debug("Gouge".." "..UnitName(object),11286)       
          end
        end 
      end
    end
  end
  local function Hide()
    if wowex.wowexStorage.read("useStealth") and not (buff(Stealth,"player") or buff(Vanish,"player")) and castable(Stealth) then
      if wowex.wowexStorage.read("stealthmode") == "DynTarget" then
        if UnitExists("target") and distance("player","target") <= GetAggroRange("target") then
          cast(Stealth)
        end
      end
      if wowex.wowexStorage.read("stealthmode") == "DynOM" then
        for i, object in ipairs(Objects()) do
          if ObjectType(object) == 3 and UnitCanAttack("player",object) and UnitCreatureType(object) ~= "Critter" and distance("player",object) <= GetAggroRange(object) and not UnitIsDeadOrGhost(object) and not UnitAffectingCombat(object) then
            cast(Stealth)
          end
        end
      end
      if wowex.wowexStorage.read('stealtheat') then
        if IsEatingOrDrinking() and castable(Stealth,"player") then
          cast(Stealth)
        end
      end
    end
  end
  if not UnitIsDeadOrGhost("target") then
    if Defensives() then return true end
    if Execute() then return true end
    if pvp() then return true end
    if Opener() then return true end
    if Dps() then return true end
    if Filler() then return true end 
    if Hide() then return true end
    if Distract() then return true end
    if Poison() then return true end
  end
  if wowex.wowexStorage.read('autoloot') and not UnitAffectingCombat("player") and (not buff(Stealth,"player") or not buff(Vanish,"player")) and InventorySlots() > 2 then
    Loot()
    return true 
  end
end, Routine.Classes.Rogue, Routine.Specs.Rogue)
Routine:LoadRoutine(Routine.Specs.Rogue)
print("\124cffff80ff\124Tinterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16\124t [Rebecca] whispers: Hello, " .. UnitName("player") .. ". We have detected an \"UNAUTHORIZED THIRD PARTY PROGRAM\" running on your computer. Have fun with it.:)")

local example = {
  key = "tinkr_configs",
  title = "Made by Rebecca",
  width = 840,
  height = 360,
  resize = true,
  show = false,
  table = {
    {key = "heading", type = "heading", text = "BeccaRogue"},
    { key = "StealthMode", width = 130, label = "StealthMode", type = "dropdown", options = { "DynOM", "DynTarget", "Always", } },
    {
      key = "Stealtheat",
      type = "checkbox",
      text = "Stealth",
      desc = "Stealth on Food"
    },
    {
      key = "AutoLoot",
      type = "checkbox",
      text = "Auto Loot",
      desc = "Auto Loot"
    },
    {key = "heading", type = "heading", text = "Defensives"}, {
      key = "Evasion",
      type = "slider",
      text = "Evasion",
      label = "% Evasion",
      min = 0,
      max = 100,
      step = 5
    },
    {
      key = "Vanish",
      type = "slider",
      text = "Vanish",
      label = "% Vanish",
      min = 0,
      max = 100,
      step = 5
    },
    {
      key = "Gouge",
      type = "slider",
      text = "Gouge",
      label = "% Gouge",
      min = 0,
      max = 100,
      step = 5
    },
  }
}
--wowex.build_rotation_gui(example)
local button_example = {
  {
    key = "useStealth",
    buttonname = "useStealth",
    texture = "ability_stealth",
    tooltip = "Stealth",
    text = "Stealth",
    setx = "TOP",
    parent = "settings",
    sety = "TOPRIGHT"
  },
  {
    key = "useExpose",
    buttonname = "useExpose",
    texture = "ability_warrior_riposte",
    tooltip = "Expose Armor",
    text = "Expose Armor",
    setx = "TOP",
    parent = "useStealth",
    sety = "TOPRIGHT"
  }
  
}
wowex.button_factory(button_example)
Draw:Enable()

local mytable = {
  key = "cromulon_config",
  name = "Rebecca Rogue Tbc",
  height = 650,
  width = 400,
  panels = 
  {
    { 
      name = "Offensive",
      items = 
      {
        { key = "heading", type = "text", color = 'FFF468', text = "Multiplier = Eviscerate=Attack Power * (Number of Combo Points used * 0.03) * abitrary multiplier to account for Auto Attacks while pooling Recommendation : <= 60 == 1.6 >= 60 == 1.4" },
        
        { key = "heading", type = "heading", color = 'FFF468', text = "Execute" },
        { key = "personalmultiplier", type = "slider", text = "Execute Multiplier", label = "Execute Multiplier", min = 1, max = 3, step = 0.1 },
        { key = "heading", type = "heading", color = 'FFF468', text = "Opener" },
        { key = "openerfrontal", width = 175, label = "Frontal", text = wowex.wowexStorage.read("openerfrontal"), type = "dropdown",
        options = {"Cheap Shot", "None",} },
        { key = "openerbehind", width = 175, label = "Behind", text = wowex.wowexStorage.read("openerbehind"), type = "dropdown",
        options = {"Ambush", "Cheap Shot", "Garrote","None"} },
        --{ key = "pershealwavepercent", type = "slider", text = "Healing Wave", label = "Healing Wave at", min = 1, max = 100, step = 1 },
        
      },
    },
    { 
      name = "Defensives",
      items = 
      {
        { key = "heading", type = "heading", color = 'FFF468', text = "Evasion" },
        { key = "evasionhp", type = "slider", text = "", label = "Evasion at", min = 1, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FFF468', text = "Vanish" },
        { key = "vanishhp", type = "slider", text = "", label = "Vanish at", min = 0, max = 100, step = 1 },
        { key = "heading", type = "heading", color = 'FFF468', text = "Gouge" },
        { key = "gougehp", type = "slider", text = "", label = "Gouge at", min = 0, max = 100, step = 1 },
        
      }
    },
    { 
      name = "General",
      items = 
      {
        { key = "heading", type = "heading", color = 'FFF468', text = "Poison" },
        { key = "mainhandpoison", width = 175, label = "Mainhand", text = wowex.wowexStorage.read("mainhandpoison"), type = "dropdown",
        options = {"Instant", "Wound","Crippling", "None"} },
        { key = "offhandpoison", width = 175, label = "Offhand", text = wowex.wowexStorage.read("offhandpoison"), type = "dropdown",
        options = {"Deadly", "MindNumbing","Crippling","None"} },
        { key = "heading", type = "heading", color = 'FFF468', text = "Stealth" },
        {type = "text", text = "DynOM = Scans the area around you for NPC aggro ranges and puts you into stealth when you get close to them.", color = 'FFF468'},
        {type = "text", text = "DynTarget = Stealthes you when you're near your TARGET's aggro range.", color = 'FFF468'},       
        { key = "stealthmode", width = 175, label = "Stealth Mode", text = wowex.wowexStorage.read("stealthmode"), type = "dropdown",
        options = {"DynOM", "DynTarget",} },
        { key = "stealtheat",  type = "checkbox", text = "Stealth while eating", desc = "" },
        
        { key = "heading", type = "heading", color = 'FFF468', text = "Other" },
        { key = "autoloot",  type = "checkbox", text = "Auto Loot", desc = "" },
        
      }
    },
    { 
      name = "Draw",
      items = 
      {
        { key = "bladeflurrydraw",  type = "checkbox", text = "BladeFlurry Range", desc = "" },
      --  { key = "targetingusdraw",  type = "checkbox", text = "Players targeting us", desc = "" },
      --  {type = "text", text = "Red: >= 30y yellow: <= 30y green: <= 8y", color = 'FFF468'},
        
      }
    },
  },
  
  tabgroup = 
  {
    {text = "Offensive", value = "one"},
    {text = "Defensives", value = "two"},
    {text = "General", value = "three"},
    {text = "Draw", value = "four"}
    
  }
}
wowex.createpanels(mytable)