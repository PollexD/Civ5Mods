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

  local scout = pPlayer:InitUnit(GameInfoTypes["UNIT_SCOUT"], pStartPlot:GetX(), pStartPlot:GetY(), UNITAI_EXPLORE);
  scout:JumpToNearestValidPlot();
  local ship = pPlayer:InitUnit(GameInfoTypes["UNIT_TRIREME"], pStartPlot:GetX(), pStartPlot:GetY(), UNITAI_EXPLORE_SEA, DirectionTypes.DIRECTION_WEST);
  ship:JumpToNearestValidPlot();

  pPlayer:ChangeGold(50);
end

----------------------------------------------------------------
ScenarioInitialise()