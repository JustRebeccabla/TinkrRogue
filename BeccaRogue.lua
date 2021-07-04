---@diagnostic disable: undefined-global
local Tinkr = ...
local Routine = Tinkr.Routine
--[[
No Support, No Requests. Take it or leave it
"This doesn't work on my non English Client" - I dont care to localise stuff like EquipTypes and stuff. Use English like a normal Person.(Do a Merge Request if you want, then i merge it)
"This doesnt work with XyZ" -I dont care
"Can you add .... for my bot?" -Nope
"Flyhack?" -No
Just for myself and/or close Friends.

--]]
print("\124cffff80ff\124Tinterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16\124t [Rebecca] whispers: Hello, " .. UnitName("player") .. ". We have detected an \"UNAUTHORIZED THIRD PARTY PROGRAM\" running on your computer. Have fun with it.:)")


Routine:RegisterRoutine(function()
  local GetComboPoints = GetComboPoints("player","target")
  if gcd() > latency() then return end
  if mounted() or UnitIsDeadOrGhost("player") then return end
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
    local multiplier = 1.4
    local evisc1calculated = ap * (1 * 0.03) + e1 * multiplier
    local evisc2calculated = ap * (2 * 0.03) + e2 * multiplier
    local evisc3calculated = ap * (3 * 0.03) + e3 * multiplier
    local evisc4calculated = ap * (4 * 0.03) + e4 * multiplier
    local evisc5calculated = ap * (5 * 0.03) + e5 * multiplier
    
  end
  local function Defensives()
  end
  local function Cooldowns()
  end
  local function AoE()
  end
  local function Opener()
  end
  local function Filler()
    local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
    local _, _, _, _, _, _, itemType5 = GetItemInfo(mainHandLink)
    if (not debuff(Sap,"target") or not debuff(Gouge,"target") or not debuff(Blind,"target") or not buff("Vanish","player")) and GetComboPoints < 5 then
      if itemType5 == "Daggers" and not IsSpellKnown(Hemorrhage) then
        if IsBehind() and castable(Backstab,"target") then
          cast(Backstab,"target")
        end
        if not IsBehind() and castable(SinisterStrike,"target") then
          cast(SinisterStrike,"target")
        end
      end
      if IsSpellKnown(Hemorrhage) then
        if castable(Hemorrhage,"target") then
          cast(Hemorrhage,"target")
        end
      end
      if not IsSpellKnown(Hemorrhage) and itemType5 ~= "Daggers" then
        if castable(SinisterStrike,"target") then
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
  if Execute() then return true end
  if Filler() then return true end 
  if Hide() then return true end
end, Routine.Classes.Rogue, 'BeccaRogue')

