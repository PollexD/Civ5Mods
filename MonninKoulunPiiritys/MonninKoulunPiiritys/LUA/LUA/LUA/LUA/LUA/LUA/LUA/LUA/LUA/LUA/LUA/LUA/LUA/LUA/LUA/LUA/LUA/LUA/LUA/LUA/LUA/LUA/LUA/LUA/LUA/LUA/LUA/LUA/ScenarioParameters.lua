----------------------------------------------------------------
-- Scenario Parameters - change these to match your requirements
----------------------------------------------------------------
ModId = "196f496e-d7bc-46c9-8697-a40a0cec5a89"
ModVersion = Modding.GetActivatedModVersion(ModId);


ScenarioFixedMap = "MAPS/ScenarioMap.Civ5Map"           -- Set to nil to disable option
ScenarioRandomMap = "MAPS/ScenarioMapScript.lua"        -- Set to nil to disable option
ScenarioMapSize = "WORLDSIZE_STANDARD"                  -- Only needed for random maps
ScenarioMinorCivs = 16                                  -- Only needed for random maps


-- If using a WorldBuilder (.Civ5Map) map,
-- this table MUST match the placed playable civs
ScenarioCivilizations = {
  [0] = "CIVILIZATION_ENGLAND",
  [1] = "CIVILIZATION_ARABIA",
  [2] = "CIVILIZATION_OTTOMAN",
  [3] = "CIVILIZATION_GREECE",
}
-- ScenarioDefaultCivilization = "CIVILIZATION_ARABIA"  -- Set to nil to set initial value to "random"
ScenarioDefaultCivilization = nil

-- Other AI (non-playable) civs - only needed for random maps
ScenarioAICivilizations = {
}


ScenarioDifficulties = {
  "HANDICAP_CHIEFTAIN",
  "HANDICAP_WARLORD",
  "HANDICAP_PRINCE",
  "HANDICAP_KING",
  "HANDICAP_EMPEROR",
  "HANDICAP_IMMORTAL",
  "HANDICAP_DEITY",
}
ScenarioDefaultDifficulty = "HANDICAP_PRINCE"


-- If using a script to determine victory, pick the one(s) that will make the AI behave the best
ScenarioVictories = {
  VICTORY_TIME       = false,
  VICTORY_SPACE_RACE = false,
  VICTORY_DOMINATION = true,
  VICTORY_CULTURAL   = true,
  VICTORY_DIPLOMATIC = true,
}


ScenarioGameSpeed = "GAMESPEED_QUICK"


ScenarioTurns = 0
