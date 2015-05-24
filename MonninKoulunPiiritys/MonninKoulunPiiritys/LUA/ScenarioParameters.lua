----------------------------------------------------------------
-- Scenario Parameters - change these to match your requirements
----------------------------------------------------------------
ModId = "254cab8d-af29-4603-9e66-53587df46420"
ModVersion = Modding.GetActivatedModVersion(ModId);


ScenarioFixedMap = "MAPS/MonninKoulunPiiritys.Civ5Map"           -- Set to nil to disable option
--ScenarioRandomMap = "MAPS/ScenarioMapScript.lua"        -- Set to nil to disable option
--ScenarioMapSize = "WORLDSIZE_STANDARD"                  -- Only needed for random maps
--ScenarioMinorCivs = 16                                  -- Only needed for random maps


-- If using a WorldBuilder (.Civ5Map) map,
-- this table MUST match the placed playable civs
ScenarioCivilizations = {
  [0] = "CIVILIZATION_ALIEN",
  [1] = "CIVILIZATION_MONNI",
}
-- ScenarioDefaultCivilization = "CIVILIZATION_ARABIA"  -- Set to nil to set initial value to "random"
ScenarioDefaultCivilization = nil

-- Other AI (non-playable) civs - only needed for random maps
ScenarioAICivilizations = {
}


--ScenarioDifficulties = {
  --"HANDICAP_CHIEFTAIN",
  --"HANDICAP_WARLORD",
  --"HANDICAP_PRINCE",
  --"HANDICAP_KING",
  --"HANDICAP_EMPEROR",
  --"HANDICAP_IMMORTAL",
  --"HANDICAP_DEITY",
--}
ScenarioDefaultDifficulty = "HANDICAP_PRINCE"


-- If using a script to determine victory, pick the one(s) that will make the AI behave the best
ScenarioVictories = {
  VICTORY_TIME       = false,
  VICTORY_SPACE_RACE = false,
  VICTORY_DOMINATION = true,
  VICTORY_CULTURAL   = false,
  VICTORY_DIPLOMATIC = false,
}


ScenarioGameSpeed = "GAMESPEED_STANDARD"


ScenarioTurns = 100
