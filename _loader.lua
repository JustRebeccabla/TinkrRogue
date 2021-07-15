---@diagnostic disable: undefined-global
local Tinkr = ...
local Routine = Tinkr.Routine

if UnitClass("player") == "Rogue" then
  Eval('RunMacroText("/tinkr load BeccaRogue.lua")', 'r')
end