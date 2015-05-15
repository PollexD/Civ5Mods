----------------------------------------------------------------
--
-- Scenario Initialisation
--
----------------------------------------------------------------
include("\ScenarioUtilities.lua")

----------------------------------------------------------------
function ScenarioInitialise() 
  if (IsScenarioNotInitialised()) then
    -- Loop over each player and initialise them
    for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
      local pPlayer = Players[iPlayerLoop];
      if (pPlayer:IsAlive()) then
        InitPlayer(pPlayer);
      end
    end

    -- Add random goody huts to World Builder maps
    if (IsScenarioWBMap()) then
      ClearGoodies()
      AddGoodies()
    end
  end
end

----------------------------------------------------------------
function InitPlayer(pPlayer)
  local pStartPlot = GetPlayerStartPlot(pPlayer);
 

  pPlayer:ChangeGold(50);
end

----------------------------------------------------------------
ScenarioInitialise()