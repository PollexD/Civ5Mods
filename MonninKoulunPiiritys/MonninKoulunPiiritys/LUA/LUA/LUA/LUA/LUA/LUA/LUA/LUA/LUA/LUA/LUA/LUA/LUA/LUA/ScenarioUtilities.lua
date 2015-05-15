----------------------------------------------------------------
--
-- ScenarioUtilities.lua
--
----------------------------------------------------------------
include("\ScenarioParameters.lua")
include("MapGenerator")

---------------------------------------------------------------------
function IsScenarioInitialised()
  local savedData = Modding.OpenSaveData()

  local bInitialised = (savedData.GetValue("ScenarioInitialised") ~= nil)

  if (not bInitialised) then
    savedData.SetValue("ScenarioInitialised", 1)
  end

  return bInitialised
end

---------------------------------------------------------------------
function IsScenarioNotInitialised()
  return not IsScenarioInitialised()
end

---------------------------------------------------------------------
function ScenarioWin(pContext, pPlayer, sVictoryType)
       	Game.SetWinner(pPlayer:GetTeam(), GameInfo.Victories[sVictoryType].ID)
       	pContext:ClearUpdate() 
       	pContext:SetHide(true)
end

----------------------------------------------------------------
function ScenarioLose(pContext)
	Game.SetGameState(GameplayGameStateTypes.GAMESTATE_OVER)
	pContext:ClearUpdate() 
	pContext:SetHide(true)
end

----------------------------------------------------------------
function IsScenarioOutOfTurns()
	-- Only out of turns if the turn counter is enabled (ie ScenarioTurns > 0)
	return (ScenarioTurns > 0) and (ScenarioTurnsRemaining() < 1)
end

----------------------------------------------------------------
function ScenarioTurnsRemaining()
	return (ScenarioTurns - Game.GetGameTurn())
end

----------------------------------------------------------------
function IsScenarioLastManStanding()
	return (ScenarioCountOpponents() == 0)
end

----------------------------------------------------------------
function ScenarioCountOpponents()
	local iOtherLeadersAlive = 0

	-- Loop through all the Majors checking for others alive
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local player = Players[iPlayerLoop]
		if (player:IsAlive()) then
			if (iPlayerLoop ~= Game.GetActivePlayer()) then
				iOtherLeadersAlive = iOtherLeadersAlive + 1
			end
		end
	end

	return iOtherLeadersAlive
end

----------------------------------------------------------------
function IsScenarioWBMap()
  return Path.UsesExtension(PreGame.GetMapScript(),".Civ5Map") 
end

----------------------------------------------------------------
function IsScenarioScriptMap()
  return not IsScenarioWBMap() 
end

----------------------------------------------------------------
function ClearGoodies()
  local iGoody = GameInfo.Improvements["IMPROVEMENT_GOODY_HUT"].ID

  for iPlot = 0, Map.GetNumPlots()-1, 1 do
    local pPlot = Map.GetPlotByIndex(iPlot)

    if (pPlot:GetImprovementType() == iGoody) then
      pPlot:SetImprovementType(-1)
    end
  end
end

----------------------------------------------------------------
function GetPlayerStartPlot(pPlayer)
  if (IsScenarioWBMap()) then
    -- Strangely, for a WB map the starting plot is nowhere near the first city/unit placed!
    for city in pPlayer:Cities() do
      return Map.GetPlot(city:GetX(), city:GetY())
    end

    for unit in pPlayer:Units() do
      return unit:GetPlot()
    end
  end

  return pPlayer:GetStartingPlot()
end

