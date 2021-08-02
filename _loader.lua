local Tinkr = ...
local Routine = Tinkr.Routine

if UnitClass("player") == "Rogue" then
  Eval('RunMacroText("/tinkr load BeccaRogue.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaGatherEsp.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaZygorEsp.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaEsp.lua")', 'r')
  elseif UnitClass("player") == "Druid" then
   --Eval('RunMacroText("/tinkr load BeccaDruid.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaGatherEsp.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaZygorEsp.lua")', 'r')
  --Eval('RunMacroText("/tinkr load BeccaEsp.lua")', 'r')
end
