---@diagnostic disable: undefined-global
local Tinkr = ...
local Routine = Tinkr.Routine
--[[
No Support, No Requests. Take it or leave it
"This doesnt work with XyZ" -I dont care
"Can you add .... for my bot?" -Nope
"Flyhack?" -No
Just for myself and/or close Friends.
--]]

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




Routine:RegisterRoutine(function()
    if gcd() > latency() then return end
    if mounted() then return end
    
end, Routine.Classes.Rogue, 'BeccaRogue')
