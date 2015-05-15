----------------------------------------------------------------
--
-- ScenarioLoadScreen.lua
--
-- Nothing in here should need changing!
--
----------------------------------------------------------------
include("IconSupport")
include("UniqueBonuses")

include("\ScenarioParameters.lua")

ScenarioMajorCivs = (ScenarioCivilizations ~= nil) and table.count(ScenarioCivilizations) or 0
ScenarioAIMajorCivs = (ScenarioAICivilizations ~= nil) and table.count(ScenarioAICivilizations) or 0

-- -- Changing this above 8 requires adding more PreGame slots
-- ScenarioMaxMajorCivs = 8

----------------------------------------------------------------
-- Global Variables
----------------------------------------------------------------
g_HideMap = false
g_HideDifficulty = false
g_DoMFull = false

-- Default to random civ and map
g_CurrentPlayerIndex = nil
g_CurrentMap = nil

g_FixedMapPath = ScenarioFixedMap and Modding.GetEvaluatedFilePath(ModId, ModVersion, ScenarioFixedMap).EvaluatedPath or nil
g_RandomMapPath = ScenarioRandomMap and Modding.GetEvaluatedFilePath(ModId, ModVersion, ScenarioRandomMap).EvaluatedPath or nil

g_CurrentDifficulty = GameInfo.HandicapInfos["HANDICAP_PRINCE"].ID
g_CurrentDifficultyButton = nil

g_CurrentMapSelectionAnim = nil

----------------------------------------------------------------
-- Event handlers
----------------------------------------------------------------
function OnBack()
  if (not Controls.SelectCivScrollPanel:IsHidden()) then
    ToggleCivSelection()
  else
    UIManager:DequeuePopup(ContextPtr)
  end
end
Controls.BackButton:RegisterCallback(Mouse.eLClick, OnBack)

----------------------------------------------------------------
function OnInput(uiMsg, wParam, lParam)
  if uiMsg == KeyEvents.KeyDown then
    if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
      OnBack()
    end
  end

  return true
end
ContextPtr:SetInputHandler(OnInput)

----------------------------------------------------------------
function ToggleCivSelection()
  if (Controls.SelectCivScrollPanel:IsHidden()) then
    BuildCivSelectList()

    Controls.SelectCivScrollPanel:SetHide(false)
    Controls.DifficultyBox:SetHide(true)
    Controls.MapBox:SetHide(true)
    Controls.DoMFullBox:SetHide(true)
    Controls.DoMPanelBox:SetHide(true)
    Controls.StartButton:SetHide(true)
  else
    Controls.SelectCivScrollPanel:SetHide(true)
    Controls.DifficultyBox:SetHide(g_HideDifficulty)
    Controls.MapBox:SetHide(g_HideMap)
    Controls.DoMFullBox:SetHide(not g_DoMFull)
    Controls.DoMPanelBox:SetHide(g_DoMFull)
    Controls.StartButton:SetHide(false)
  end
end
if (ScenarioMajorCivs > 1) then
  Controls.CivilizationButton:RegisterCallback(Mouse.eLClick, ToggleCivSelection)
end

----------------------------------------------------------------
function SetPlayerIndex(playerIndex)
  g_CurrentPlayerIndex = playerIndex
    
  if (playerIndex ~= nil) then
    --Set up items for specified player.
    local civType = ScenarioCivilizations[playerIndex]

    -- Use the Civilization_Leaders table to cross reference from this civ to the Leaders table
    local civ = GameInfo.Civilizations[civType]
    local leader = GameInfo.Leaders[GameInfo.Civilization_Leaders("CivilizationType = '" .. civ.Type .. "'")().LeaderheadType]
    local leaderDescription = leader.Description

    -- Set Leader & Civ Text
    Controls.Title:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER_CIV", leaderDescription, civ.ShortDescription)

    -- Set Civ Leader Icon
    IconHookup(leader.PortraitIndex, 128, leader.IconAtlas, Controls.Portrait)
      
    -- Set Civ Icon
    IconHookup(civ.PortraitIndex, 64, civ.IconAtlas, Controls.IconShadow)
      
    -- Sets Trait bonus Text
    local leaderTrait = GameInfo.Leader_Traits("LeaderType ='" .. leader.Type .. "'")()
    local trait = leaderTrait.TraitType
    Controls.BonusTitle:LocalizeAndSetText(GameInfo.Traits[trait].ShortDescription)
    Controls.BonusDescription:LocalizeAndSetText(GameInfo.Traits[trait].Description)

    ---- Sets Bonus Icons
    PopulateUniqueBonuses(Controls, civ, leader)
          
    -- Sets Dawn of Man Quote
    Controls.DoMFullText:LocalizeAndSetText(civ.DawnOfManQuote or "")
    Controls.DoMPanelText:LocalizeAndSetText(civ.DawnOfManQuote or "")
  else
    -- Setup entry for random player.
    Controls.Title:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER")
    IconHookup(22, 128, "LEADER_ATLAS", Controls.Portrait )
    
    if (questionOffset ~= nil) then       
      Controls.IconShadow:SetTexture(questionTextureSheet)
      Controls.IconShadow:SetTextureOffset(questionOffset)
    end
      
    -- Sets Trait bonus Text
    Controls.BonusTitle:LocalizeAndSetText("TXT_KEY_MISC_RANDOMIZE")
    Controls.BonusDescription:SetText("")
  
    -- Sets Bonus Icons
    local maxSmallButtons = 2
    for buttonNum = 1, maxSmallButtons, 1 do
      local buttonName = "B"..tostring(buttonNum)
      Controls[buttonName]:SetTexture(questionTextureSheet)
      Controls[buttonName]:SetTextureOffset(questionOffset)
      Controls[buttonName]:SetToolTipString(unknownString)
      Controls[buttonName]:SetHide(false)
      local buttonFrameName = "BF"..tostring(buttonNum)
      Controls[buttonFrameName]:SetHide(false)
    end
    
    -- Sets Dawn of Man Quote
    Controls.DoMFullText:LocalizeAndSetText("TXT_KEY_SCENARIO_BRIEFING_TEXT")    
    Controls.DoMPanelText:LocalizeAndSetText("TXT_KEY_SCENARIO_BRIEFING_TEXT")    
  end

  Controls.DoMFullStack:CalculateSize()
  Controls.DoMFullStack:ReprocessAnchoring()
  Controls.DoMFullScrollPanel:CalculateInternalSize()
  Controls.DoMPanelStack:CalculateSize()
  Controls.DoMPanelStack:ReprocessAnchoring()
  Controls.DoMPanelScrollPanel:CalculateInternalSize()
end

----------------------------------------------------------------
function DifficultySelected(button, difficulty)
  g_CurrentDifficulty = difficulty
  g_CurrentDifficultyButton.SelectionAnim:SetHide(true)

  button.SelectionAnim:SetHide(false)
  g_CurrentDifficultyButton = button
end

----------------------------------------------------------------
function MapSelected(selectionAnim, map)
  g_CurrentMap = map
  if (g_CurrentMapSelectionAnim ~= nil) then
    g_CurrentMapSelectionAnim:SetHide(true)
  end
  
  selectionAnim:SetHide(false)
  g_CurrentMapSelectionAnim = selectionAnim
end
Controls.FixedMapButton:RegisterCallback(Mouse.eLClick, function() MapSelected(Controls.FixedMapSelectionAnim, g_FixedMapPath) end)
Controls.RandomMapButton:RegisterCallback(Mouse.eLClick, function() MapSelected(Controls.RandomMapSelectionAnim, nil) end)

----------------------------------------------------------------
function OnStart()
  PreGame.Reset()
    
  -- Fixed/Random map specifics
  if (g_CurrentMap ~= nil) then
    -- Setup the fixed map
    PreGame.SetLoadWBScenario(true)
    PreGame.SetMapScript(g_CurrentMap)

    -- Setup the player
    UI.ResetScenarioPlayerSlots(true)

    local playerIndex = g_CurrentPlayerIndex
    if (playerIndex == nil) then
      playerIndex = math.random(0, ScenarioMajorCivs - 1)
    end
  
    -- Swap Civilization to make active player the new index.
    if (playerIndex ~= nil) then
      UI.MoveScenarioPlayerToSlot(playerIndex, 0)
    end

    -- Setup the handicap    
    PreGame.SetOverrideScenarioHandicap(true)
    PreGame.SetHandicap(0, g_CurrentDifficulty)
  else
    -- Setup the random map
    PreGame.SetLoadWBScenario(false)
    PreGame.RandomizeMapSeed()
    PreGame.SetMapScript(g_RandomMapPath)
    PreGame.SetWorldSize(GameInfo.Worlds[ScenarioMapSize].ID)

    -- Setup spaces for the civilizations
    PreGame.ResetSlots()
--     if (ScenarioMaxMajorCivs > 8) then
--       -- TODO - need to add more pre-game slots
--     end

    -- Setup the civilizations
    local iPlayer = 0
    -- Playable civilizations first
    for i = 0, ScenarioMajorCivs-1, 1 do
      PreGame.SetCivilization(iPlayer, GameInfo.Civilizations[ScenarioCivilizations[i]].ID)
      iPlayer = iPlayer + 1
    end
    -- then AI civilizations
    for i = 0, ScenarioAIMajorCivs-1, 1 do
      PreGame.SetCivilization(iPlayer, GameInfo.Civilizations[ScenarioAICivilizations[i]].ID)
      iPlayer = iPlayer + 1
    end

    for i = 1, (ScenarioMajorCivs+ScenarioAIMajorCivs)-1, 1 do
      PreGame.SetSlotStatus(i, SlotStatus.SS_COMPUTER)
      PreGame.SetSlotClaim(i, SlotClaim.SLOTCLAIM_ASSIGNED)
    end
--     for i = (ScenarioMajorCivs+ScenarioAIMajorCivs), math.max(7, ScenarioMaxMajorCivs-1), 1 do
    for i = (ScenarioMajorCivs+ScenarioAIMajorCivs), (8-1), 1 do
      PreGame.SetSlotStatus(i, SlotStatus.SS_CLOSED)
    end
  
    -- Setup the player
    local playerIndex = g_CurrentPlayerIndex
    if (playerIndex == nil) then
      playerIndex = math.random(0, table.count(ScenarioCivilizations) - 1)
    end
  
    -- Swap Civilization to make active player the new index.
    if (playerIndex ~= nil) then
      PreGame.SetCivilization(0, GameInfo.Civilizations[ScenarioCivilizations[playerIndex]].ID)
      PreGame.SetCivilization(playerIndex, GameInfo.Civilizations[ScenarioCivilizations[0]].ID)
    end
  
    -- Setup the handicap    
    PreGame.SetHandicap(0, g_CurrentDifficulty)

    -- Setup the city states
    PreGame.SetNumMinorCivs(ScenarioMinorCivs)
  end

  PreGame.SetGameSpeed(GameInfo.GameSpeeds[ScenarioGameSpeed].ID)
  SetVictories()

  PreGame.SetGameOption("GAMEOPTION_NO_TUTORIAL", true)

  Events.SerialEventStartGame()
  UIManager:SetUICursor(1)
end
Controls.StartButton:RegisterCallback(Mouse.eLClick, OnStart)


----------------------------------------------------------------
-- Helper Methods
----------------------------------------------------------------
function HideMapBox()
  g_HideMap = true
  Controls.MapBox:SetHide(g_HideMap)

  -- Expand the difficulty box to fill the space
  Controls.DifficultyBox:SetOffset(Vector2(38, 155))
  Controls.DifficultyBox:SetSize(Vector2(354, 258+140+6))

  -- And all the sub-controls
  Controls.DifficultyBackground:SetSize(Vector2(350, 258+140+6))
  Controls.DifficultyFrame:SetSize(Vector2(354, 258+140+6))
  Controls.DifficultyScrollPanel:SetSize(Vector2(330, 220+140+6))

  -- Recalc the scroll bar size
  Controls.DifficultyScrollPanel:CalculateInternalSize()

  ExpandDoMBox()
end

----------------------------------------------------------------
function HideDifficultyBox()
  g_HideDifficulty = true
  Controls.DifficultyBox:SetHide(g_HideDifficulty)

  ExpandDoMBox()
end

----------------------------------------------------------------
function ExpandDoMBox()
  if (g_HideMap and g_HideDifficulty) then
    g_DoMFull = true

    Controls.DoMFullBox:SetHide(not g_DoMFull)
    Controls.DoMPanelBox:SetHide(g_DoMFull)
  end
end

----------------------------------------------------------------
function BuildDifficultySelectList()
  for diffIndex, diffType in ipairs(ScenarioDifficulties) do
    local diff = GameInfo.HandicapInfos[diffType]
    if (diff ~= nil) then
      local controlTable = {}
      ContextPtr:BuildInstanceForControl("ItemInstance", controlTable, Controls.DifficultyStack)

      if (diff.ID == g_CurrentDifficulty) then
        g_CurrentDifficultyButton = controlTable
        controlTable.SelectionAnim:SetHide(false)
      end

      IconHookup(diff.PortraitIndex, 64, diff.IconAtlas, controlTable.Icon)
      controlTable.Help:LocalizeAndSetText(diff.Help)
      controlTable.Name:LocalizeAndSetText(diff.Description)
      controlTable.Button:SetToolTipString(Locale.ConvertTextKey(diff.Help))
      controlTable.Button:RegisterCallback(Mouse.eLClick, function() DifficultySelected(controlTable, diff.ID) end)
    end
  end
  
  Controls.DifficultyStack:CalculateSize()
  Controls.DifficultyStack:ReprocessAnchoring()
  Controls.DifficultyScrollPanel:CalculateInternalSize()
end

----------------------------------------------------------------
function BuildCivSelectList()
  Controls.SelectCivStack:DestroyAllChildren() 
  
  --Create Random Selection Entry if it's not already selected
  if (g_CurrentPlayerIndex ~= nil) then
    local controlTable = {}
    ContextPtr:BuildInstanceForControl("SelectCivInstance", controlTable, Controls.SelectCivStack)
    
    controlTable.Button:SetVoid1(-1)
    controlTable.Button:RegisterCallback(Mouse.eLClick, function() SetPlayerIndex(nil) ToggleCivSelection() end)

    controlTable.Title:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER")
    controlTable.Description:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER_HELP")
    IconHookup(22, 128, "LEADER_ATLAS", controlTable.Portrait)
    
    if (questionOffset ~= nil) then       
      controlTable.Icon:SetTexture(questionTextureSheet)
      controlTable.Icon:SetTextureOffset(questionOffset)
      controlTable.IconShadow:SetTexture(questionTextureSheet)
      controlTable.IconShadow:SetTextureOffset(questionOffset)
    end
    
    local primaryColor       = GameInfo.Colors.COLOR_DARK_GREY
    local primaryColorVector = Vector4(primaryColor.Red, primaryColor.Green, primaryColor.Blue, primaryColor.Alpha)
    controlTable.Icon:SetColor(primaryColorVector)
    
    local secondaryColor       = GameInfo.Colors.COLOR_LIGHT_GREY
    local secondaryColorVector = Vector4(secondaryColor.Red, secondaryColor.Green, secondaryColor.Blue, secondaryColor.Alpha)
    controlTable.TeamColor:SetColor(secondaryColorVector)
  
    -- Sets Trait bonus Text
    controlTable.BonusTitle:LocalizeAndSetText("TXT_KEY_MISC_RANDOMIZE")
    controlTable.BonusDescription:SetText("")
  
     -- Sets Bonus Icons
    local maxSmallButtons = 2
    for buttonNum = 1, maxSmallButtons, 1 do
      local buttonName = "B"..tostring(buttonNum)
      controlTable[buttonName]:SetTexture(questionTextureSheet)
      controlTable[buttonName]:SetTextureOffset(questionOffset)
      controlTable[buttonName]:SetToolTipString(unknownString)
      controlTable[buttonName]:SetHide(false)
      local buttonFrameName = "BF"..tostring(buttonNum)
      controlTable[buttonFrameName]:SetHide(false)
    end
  end 
     
  for playerIndex, civType in pairs(ScenarioCivilizations) do
    if (playerIndex ~= g_CurrentPlayerIndex) then
      local civ = GameInfo.Civilizations[civType]
      
      -- Use the Civilization_Leaders table to cross reference from this civ to the Leaders table
      local leader = GameInfo.Leaders[GameInfo.Civilization_Leaders("CivilizationType = '" .. civ.Type .. "'")().LeaderheadType]
      local leaderDescription = leader.Description
        
      local colorSet = GameInfo.PlayerColors[civ.DefaultPlayerColor]
        
      local primaryColor       = GameInfo.Colors[colorSet.PrimaryColor]
      local primaryColorVector = Vector4(primaryColor.Red, primaryColor.Green, primaryColor.Blue, primaryColor.Alpha)
        
      local secondaryColor       = GameInfo.Colors[colorSet.SecondaryColor]
      local secondaryColorVector = Vector4(secondaryColor.Red, secondaryColor.Green, secondaryColor.Blue, secondaryColor.Alpha)
            
      local controlTable = {}
      ContextPtr:BuildInstanceForControl("SelectCivInstance", controlTable, Controls.SelectCivStack)
        
      controlTable.Button:SetVoid1(civ.ID)
      controlTable.Button:RegisterCallback(Mouse.eLClick, function() SetPlayerIndex(playerIndex) ToggleCivSelection() end)
        
      controlTable.Title:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER_CIV", leaderDescription, civ.ShortDescription)
      controlTable.Description:SetText(Locale.ConvertTextKey(civ.Description))

      IconHookup(leader.PortraitIndex, 128, leader.IconAtlas, controlTable.Portrait)
      local textureOffset, textureAtlas = IconLookup(civ.PortraitIndex, 64, civ.IconAtlas)
      if (textureOffset ~= nil) then       
        controlTable.Icon:SetTexture(textureAtlas)
        controlTable.Icon:SetTextureOffset(textureOffset)
        controlTable.IconShadow:SetTexture(textureAtlas)
        controlTable.IconShadow:SetTextureOffset(textureOffset)
      end

      controlTable.Icon:SetColor(primaryColorVector)
      controlTable.TeamColor:SetColor(secondaryColorVector)
        
      -- Sets Trait bonus Text
      local leaderTrait = GameInfo.Leader_Traits("LeaderType ='" .. leader.Type .. "'")()
      local trait = leaderTrait.TraitType
      local gameTrait = GameInfo.Traits[trait]
      controlTable.BonusTitle:SetText(Locale.ConvertTextKey(gameTrait.ShortDescription))
      controlTable.BonusDescription:SetText(Locale.ConvertTextKey(gameTrait.Description))
     
      PopulateUniqueBonuses(controlTable, civ, leader)
    end
  end
  
  Controls.SelectCivStack:CalculateSize()
  Controls.SelectCivStack:ReprocessAnchoring()
  Controls.SelectCivScrollPanel:CalculateInternalSize()
end

----------------------------------------------------------------
function SetVictories()
  for row in GameInfo.Victories() do
    PreGame.SetVictory(row.ID, ScenarioVictories[row.Type])
  end
end


----------------------------------------------------------------
-- Initialisation
----------------------------------------------------------------
function Initialize()
  -- Civilizations --
  if (ScenarioDefaultCivilization ~= nil) then
    for i, c in pairs(ScenarioCivilizations) do
      if (c == ScenarioDefaultCivilization) then
        g_CurrentPlayerIndex = i
        break
      end
    end
  else
    if (ScenarioMajorCivs == 1) then
      g_CurrentPlayerIndex = 0
    end
  end

  BuildCivSelectList()
  SetPlayerIndex(g_CurrentPlayerIndex)

  -- Difficulty --
  g_CurrentDifficulty = GameInfo.HandicapInfos[ScenarioDefaultDifficulty].ID
  if (ScenarioDifficulties == nil) then
    HideDifficultyBox()
  else
    if (ScenarioDefaultDifficulty == nil) then
      ScenarioDefaultDifficulty = ScenarioDifficulties[1]
    end

    BuildDifficultySelectList()
  end
  
  -- Maps --
  if (ScenarioRandomMap == nil) then
    HideMapBox()

    MapSelected(Controls.FixedMapSelectionAnim, g_FixedMapPath)
  else
    if (ScenarioFixedMap == nil) then
      HideMapBox()
    end

    MapSelected(Controls.RandomMapSelectionAnim, nil)
  end
end

----------------------------------------------------------------
Initialize()
