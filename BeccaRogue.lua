---@diagnostic disable: undefined-global, lowercase-global
local Tinkr = ...
local wowex = {}
local Routine = Tinkr.Routine
local Util = Tinkr.Util
local Draw = Tinkr.Util.Draw:New()
local E = Tinkr:require('Routine.Modules.Exports')
Tinkr:require('scripts.cromulon.libs.Libdraw.Libs.LibStub.LibStub', wowex)
Tinkr:require('scripts.cromulon.libs.Libdraw.LibDraw', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.AceGUI30', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-BlizOptionsGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-DropDownGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Frame', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-InlineGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-ScrollFrame', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-SimpleGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TabGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TreeGroup', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Window', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Button', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-CheckBox', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-ColorPicker', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown-Items', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-EditBox', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Heading', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Icon', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-InteractiveLabel', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Keybinding', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Label', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-MultiLineEditBox', wowex)
Tinkr:require('scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Slider', wowex)
Tinkr:require('scripts.cromulon.system.configs', wowex)
Tinkr:require('scripts.cromulon.libs.libCh0tFqRg.libCh0tFqRg', wowex)
Tinkr:require('scripts.cromulon.libs.libNekSv2Ip.libNekSv2Ip', wowex)
Tinkr:require('scripts.cromulon.libs.CallbackHandler10.CallbackHandler10', wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-20', wowex)
Tinkr:require('scripts.cromulon.libs.HereBeDragons.HereBeDragons-pins-20', wowex)
Tinkr:require('scripts.cromulon.interface.uibuilder', wowex)
Tinkr:require('scripts.cromulon.interface.buttons', wowex)

Draw:Sync(function(draw)
  local px, py, pz = ObjectPosition('player')
  if e.buff(BladeFlurry,"player") then
    draw:Circle(px, py, pz, 8)
  end 
end)

local function Debug()
  local _, _, icon = GetSpellInfo(11294)
  --print("|T"..icon..":0|t")
  RaidNotice_AddMessage(RaidWarningFrame, "|T"..icon..":0|t".."Hi", ChatTypeInfo["RAID_WARNING"],1)
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
    return range
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
    multiplier = 0
    if UnitLevel("player") >= 20 then
      multiplier = 1.4
    else multiplier = 1.8
    end
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
    end
  end
  local function Defensives()
    if UnitAffectingCombat("player") then
      if castable(Feint) and health() <= 80 and UnitIsUnit("targettarget", "player") and (IsInInstance() or IsInRaid()) then
        cast(Feint)
      end
      if castable(Vanish) and health() <= wowex.config.read('Vanish', 10) and GetItemCount(5140) > 0 and ttd("target") > 4 then
        cast(Vanish)
      end
      if castable(Evasion) and health() <= wowex.config.read('Evasion', 30) then
        cast(Evasion,"player")
      end
      if castable(Gouge) and health() <= wowex.config.read('Gouge', 15) and ttd("target") > 10 then
        cast(Gouge,"target")
      end
    end
  end
  local function Cooldowns()
  end
  local function Opener()
    if UnitCanAttack("player","target") then
      if buff(Stealth,"player") and IsBehind() then
        if itemType5 == "Daggers" and castable(Ambush) then
          cast(Ambush,"target")
        end
        if itemType5 ~= "Daggers" and castable(CheapShot) then
          cast(CheapShot,"target")
        end
      end
    end
  end
  local function Dps()
    if UnitExists("target") and melee() and UnitCanAttack("player","target") then
      if not IsPlayerAttacking('target') then
        Eval('StartAttack()', 't')
      end
      if castable(SliceAndDice,"target") and GetComboPoints >= 2 and not buff(SliceAndDice, 'player') then
        cast(SliceAndDice,"target")
      end
      --Test
      if castable(ExposeArmor, 'target') and combo() == 5 and
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
    if buff(Stealth,"player") and UnitExists("target") and not UnitAffectingCombat("target") and not UnitIsPlayer("target") and IsFacing("target", "player") and distance("player","target") <= 15 then
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
  local function Hide()
    if wowex.config.read('useStealth', false)  and not (buff(Stealth,"player") or buff(Vanish,"player")) and castable(Stealth) then
      if wowex.config.read('StealthMode') == "DynTarget" then
        if UnitExists("target") and distance("player","target") <= GetAggroRange("target") then
          cast(Stealth)
        end
      end
      if wowex.config.read('StealthMode') == "DynOM" then
        for i, object in ipairs(Objects()) do
          if ObjectType(object) == 3 and UnitCanAttack("player",object) and distance("player",object) <= GetAggroRange(object) and not UnitAffectingCombat(object) and not UnitIsDeadOrGhost(object) then
            cast(Stealth)
          end
        end
      end
      if wowex.config.read('Stealtheat') then
        if buff(1131,"player") and castable(Stealth,"player") then
          cast(Stealth)
        end
      end
    end
  end
  if not UnitIsDeadOrGhost("target") then
    kickNameplate(Kick, true)
    if Defensives() then return true end
    if Execute() then return true end
    if Opener() then return true end
    if Dps() then return true end
    if Filler() then return true end 
    if Hide() then return true end
    if Distract() then return true end
  end
  if not UnitAffectingCombat("player") and (not buff(Stealth,"player") or not buff(Vanish,"player")) and InventorySlots() > 2 then
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
wowex.build_rotation_gui(example)
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
  }
  
}
wowex.button_factory(button_example)
Draw:Enable()
