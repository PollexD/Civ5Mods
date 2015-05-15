----------------------------------------------------------------
--
-- ScenarioVictoryProgress.lua
--
----------------------------------------------------------------
include("\ScenarioUtilities.lua")

---------------------------------------------------------------------
function OnUpdate()
	

	-- Check for a domination victory or out of turns
	if (IsScenarioLastManStanding()) then
		ScenarioWin(ContextPtr, Players[Game.GetActivePlayer()], "VICTORY_DOMINATION")
	elseif (IsScenarioOutOfTurns()) then
		ScenarioLose(ContextPtr)
	else
		-- Update the victory progress banner
		-- Controls.VictoryProgressLabel:LocalizeAndSetText("TXT_KEY_SCENARIO_TURNS_REMAINING", ScenarioTurnsRemaining());
		 Controls.VictoryProgressLabel:LocalizeAndSetText("TXT_KEY_SCENARIO_TURNS_AND_OPPONENTS_REMAINING", ScenarioTurnsRemaining(), ScenarioCountOpponents());
		Controls.Grid:DoAutoSize();
	end
end
ContextPtr:SetUpdate(OnUpdate)

---------------------------------------------------------------------
function OnBriefingButton()
    UI.AddPopup( { Type = ButtonPopupTypes.BUTTONPOPUP_TEXT,
                   Data1 = 800,
                   Option1 = true,
                   Text = "TXT_KEY_SCENARIO_BRIEFING_TEXT" } );
end
Controls.BriefingButton:RegisterCallback(Mouse.eLClick, OnBriefingButton);

---------------------------------------------------------------------
Events.SerialEventEnterCityScreen.Add(function() ContextPtr:SetHide(true) end);
Events.SerialEventExitCityScreen.Add(function() ContextPtr:SetHide(false) end);

---------------------------------------------------------------------
function GetLuxuriesRequired()
	-- 15 luxuries less one for each difficulty removed from Deity
	-- So Deity requires all 15 (15 - (7-7)),
	-- while Chieftain only needs 9 (15 - (7-1))
	return 15 - (7 - PreGame.GetHandicap(0));
end

function GetLuxuriesAcquired(pPlayer)
	local luxCount = 0;

	for resource in GameInfo.Resources() do
		local resourceID = resource.ID;
		if (pPlayer:GetNumResourceTotal(resourceID, true) > 0) then
			if (resource.Happiness ~= 0) then
				luxCount = luxCount + 1;
			end
		end
	end

	return luxCount;
end
---------------------------------------------------------------------
