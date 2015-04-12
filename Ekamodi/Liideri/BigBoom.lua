-- BigBoom
-- Author: PolleXD
-- DateCreated: 4/8/2015 6:29:22 PM
-- Copyright 2015 PolleXD --
--------------------------------------------------------------
print("Eetu> Ladattu")

function NytPosahtaa(pommi)
		-- Laske kaikki ruudut, joihin poksahdus vaikuttaa ja kutsu
		-- <RuudussaPoksahti> jokaiselle vaikutusalueen ruudulle
		print ("Eetu> Nyt Poksahti")
		local paikka = pommi:GetPlot()
		if (paikka ~= nil) then
			print("Eetu> POKS...")
			paikka:NukeExplosion(5, pommi)
			print("Eetu> POKS tehty")
		else
			print("Eetu> Ei paikkaa")
		end

		print("Eetu> Poksahdus loppu")
end

function Posahtaako(playerID, unitID, x, y)
	-- Testataan, onko taistelu annihilaattorin tekema
	local player = Players[playerID]
	local unit = player:GetUnitByID(unitID)
	if (unit ~= nil) then
		print("Eetu> Unit liikkuu "..unit:GetUnitType())
		print("Eetu> Uusi x="..unit:GetX())
		print("Eetu> Uusi y="..unit:GetY())
	end

	print("Eetu> Liike loppu")
end

GameEvents.UnitSetXY.Add(Posahtaako)

function TaisteluLoppu(attackingPlayer, attackingUnit, attackingUnitDamage, attackingUnitFinalDamage, attackingUnitMaxHitPoints, defendingPlayer, defendingUnit, defendingUnitDamage, defendingUnitFinalDamage, defendingUnitMaxHitPoints)
	print("Eetu> TaisteluLoppu")
	return true
end

function TaisteluMenee(attackingPlayer, attackingUnit, attackingUnitDamage, attackingUnitFinalDamage, attackingUnitMaxHitPoints, defendingPlayer, defendingUnit, defendingUnitDamage, defendingUnitFinalDamage, defendingUnitMaxHitPoints)
	print("Eetu> TaisteluMenee: unit="..attackingUnit)
	-- Testataan, onko taistelu annihilaattorin tekema
	local player = Players[attackingPlayer]
	if (player ~= nil) then
		print("Eetu> TaisteluMenee player loyty")
		local unit = player:GetUnitByID(attackingUnit)--Units[attackingUnit]
		if (unit ~= nil) then
			print("Eetu> TaisteluMenee unit loyty Type="..unit:GetUnitType())
			print("Eetu> Verrataan Tyyppin="..GameInfoTypes["UNIT_ANTIMATTER_ANNIHILATION_BOMB"])
			if (unit:GetUnitType() == GameInfoTypes["UNIT_ANTIMATTER_ANNIHILATION_BOMB"]) then
				print("Eetu> TaisteluMenee rajahdus")
				NytPosahtaa(unit)
			end
		end
	end

	return true 
end

Events.RunCombatSim.Add(TaisteluMenee)
Events.EndCombatSim.Add(TaisteluLoppu)
