---@diagnostic disable: undefined-global, lowercase-global
local Tinkr = ...
local Routine = Tinkr.Routine
local Draw = Tinkr.Util.Draw:New()


--[[
No Support, No Requests. Take it or leave it
"This doesn't work on my non English Client" - Translate weapon equip types for me and i might merge it
"This doesnt work with XyZ" -I dont care
"Can you add .... for my bot?" -Nope
"Flyhack?" -No
Just for myself and/or close Friends.

--]]
print("\124cffff80ff\124Tinterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16\124t [Rebecca] whispers: Hello, " .. UnitName("player") .. ". We have detected an \"UNAUTHORIZED THIRD PARTY PROGRAM\" running on your computer. Have fun with it.:)")


Routine:RegisterRoutine(function()
  local GetComboPoints = GetComboPoints("player","target")
  local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
  local _, _, _, _, _, _, itemType5 = GetItemInfo(mainHandLink)
  if gcd() > latency() then return end
  if mounted() or UnitIsDeadOrGhost("player") or debuff(Gouge,"target") then return end
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
  local function GetAggroRange()
    local range = 0
    local playerlvl = UnitLevel("player")
    local targetlvl = UnitLevel("target")
    range = 20 - (playerlvl - targetlvl) * 1
    if range <= 5 then
      range = 10
    elseif range >= 45 then
      range = 45
    elseif UnitReaction("player", "target") >= 4 then
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
      if castable(Vanish) and health() <= 15 and GetItemCount(5140) > 0 and ttd("target") > 4 then
        cast(Vanish)
      end
      if castable(Gouge) and health() <= 20 and ttd("target") > 10 then
        cast(Gouge)
      end
    end
  end
  local function Cooldowns()
  end
  local function Opener()
    if buff(Stealth,"player") and IsBehind() then
      if itemType5 == "Daggers" and castable(Ambush) then
        cast(Ambush,"target")
      end
      if itemType5 ~= "Daggers" and castable(CheapShot) then
        cast(CheapShot,"target")
      end
    end
  end
  local function Dps()
    if castable(SliceAndDice,"target") and GetComboPoints >= 2 and not buff(SliceAndDice, 'player') then
      cast(SliceAndDice,"target")
    end
    --Test
    if castable(ExposeArmor, 'target') and combo() == 5 and
    (not debuff(ExposeArmor, 'target') or debuffduration(ExposeArmor, 'target') < 2) then
      return cast(ExposeArmor, 'target')
    end
    if castable(SliceAndDice, 'target') and combo() >= 2 and buffduration(SliceAndDice, 'player') < 2 then
      return cast(SliceAndDice, 'target')
    end
    if castable(Eviscerate, 'target') and combo() >= 3 and buffduration(Rapture, 'player') > 4 and
    not debuff(Eviscerate, 'target') then
      return cast(Eviscerate, 'target')
    end
    if castable(Rapture, 'target') and combo() >= 2 and between(2, buffduration(Rapture, 'player'), 4) then
      return cast(Rapture, 'target')
    end
    
    
  end
  local function Loot()
    for i, object in ipairs(Objects()) do
      if ObjectLootable(object) and ObjectDistance("player",object) < 5 then
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
    if buff(Stealth,"player") and UnitExists("target") and not UnitIsPlayer("target") and IsFacing("target", "player") and distance("player","target") <= 15 then
      local X, Y, Z = ObjectPosition("target")
      local SelfFacing = ObjectRotation("player")
      local ProjX, ProjY, ProjZ = Project(X, Y, Z, SelfFacing, 7)
      if ProjX and IsSpellKnown(1725) and (not IsInRaid() or not IsInInstance()) then
        cast("Distract",'none'):click(ProjX,ProjY,ProjZ)
      end
    end
  end
  local function Filler()
    
    if (not debuff(Sap,"target") and not debuff(Gouge,"target") and not debuff(Blind,"target") and not buff(Vanish,"player") and not buff(Stealth,"player")) and GetComboPoints < 5 and melee() then
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
    if UnitExists("target") and not buff(Stealth,"player") and distance("player","target") <= GetAggroRange() and castable(Stealth) then
      cast(Stealth)
    end
  end
  
  
  if UnitExists("target") and not UnitIsDeadOrGhost("target") then
    if Defensives() then return true end
    if Execute() then return true end
    if Opener() then return true end
    if Dps() then return true end

    if Filler() then return true end 
    if Hide() then return true end
    if Distract() then return true end
  end
  if not UnitAffectingCombat("player") and not buff(Stealth,"player") and InventorySlots() > 2 then
    Loot()
    return true 
  end
  
end, Routine.Classes.Rogue, 'BeccaRogue')
