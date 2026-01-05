class SpawnRaiseDeadMinion : IAction
{
	int m_dist;
	bool m_safeSpawn;
	
	SpawnRaiseDeadMinion(UnitPtr unit, SValue& params)
	{
		m_dist = GetParamInt(unit, params, "dist", false, 40);
		m_safeSpawn = GetParamBool(unit, params, "safe-spawn", false, false);
	}
	
	void CancelAction() {}
	void SetWeaponInformation(uint weapon) {}
	void Update(int dt, int cooldown) {}
	bool NeedNetParams() { return false; }
	
	bool DoAction(SValueBuilder@ builder, Actor@ owner, Actor@ target, vec2 pos, vec2 dir, float intensity)
	{
		if (owner is null)
			return false;
		
		auto player = cast<PlayerBase>(owner);
		if (player is null || player.m_record is null)
			return false;
		
		// Validate player record is valid for multiplayer
		// The game engine should handle network synchronization automatically
		
		// Get stronger_together skill level
		uint strongerTogetherLevel = 0;
		auto@ strongerTogetherDef = player.m_record.playerClass.GetSkillDef(HashString("stronger_together"));
		if (strongerTogetherDef !is null)
			strongerTogetherLevel = player.m_record.GetSkillLevel(strongerTogetherDef);
		
		// Determine which unit to spawn based on skill level
		// Logic: Spawn the first unlocked type that we don't have yet
		string unitPath = "";
		
		auto@ summons = player.m_record.summons;
		auto defenderProd = Resources::GetUnitProducer("players/cryptknight/units/minion_defender.unit");
		auto footmanProd = Resources::GetUnitProducer("players/cryptknight/units/minion_footman.unit");
		auto sentryProd = Resources::GetUnitProducer("players/cryptknight/units/minion_sentry.unit");
		auto mageProd = Resources::GetUnitProducer("players/cryptknight/units/minion_mage.unit");
		auto knightProd = Resources::GetUnitProducer("players/cryptknight/units/minion_knight.unit");
		
		// Check which types we currently have
		bool hasDefender = false, hasFootman = false, hasSentry = false, hasMage = false, hasKnight = false;
		for (uint i = 0; i < summons.length(); i++)
		{
			if (summons[i].m_prod is defenderProd && summons[i].m_units.length() > 0) hasDefender = true;
			if (summons[i].m_prod is footmanProd && summons[i].m_units.length() > 0) hasFootman = true;
			if (summons[i].m_prod is sentryProd && summons[i].m_units.length() > 0) hasSentry = true;
			if (summons[i].m_prod is mageProd && summons[i].m_units.length() > 0) hasMage = true;
			if (summons[i].m_prod is knightProd && summons[i].m_units.length() > 0) hasKnight = true;
		}
		
		// Spawn first unlocked type that we don't have
		if (strongerTogetherLevel == 0)
		{
			// Base: Only defender
			unitPath = "players/cryptknight/units/minion_defender.unit";
		}
		else if (strongerTogetherLevel == 1)
		{
			// Level 1: Only defender (buffed)
			unitPath = "players/cryptknight/units/minion_defender.unit";
		}
		else if (strongerTogetherLevel == 2)
		{
			// Level 2: Defender or Footman
			if (!hasDefender) unitPath = "players/cryptknight/units/minion_defender.unit";
			else if (!hasFootman) unitPath = "players/cryptknight/units/minion_footman.unit";
			else unitPath = "players/cryptknight/units/minion_defender.unit"; // Default if both present
		}
		else if (strongerTogetherLevel == 3)
		{
			// Level 3: Defender, Footman, or Sentry
			if (!hasDefender) unitPath = "players/cryptknight/units/minion_defender.unit";
			else if (!hasFootman) unitPath = "players/cryptknight/units/minion_footman.unit";
			else if (!hasSentry) unitPath = "players/cryptknight/units/minion_sentry.unit";
			else unitPath = "players/cryptknight/units/minion_defender.unit";
		}
		else if (strongerTogetherLevel == 4)
		{
			// Level 4: Defender, Footman, Sentry, or Mage
			if (!hasDefender) unitPath = "players/cryptknight/units/minion_defender.unit";
			else if (!hasFootman) unitPath = "players/cryptknight/units/minion_footman.unit";
			else if (!hasSentry) unitPath = "players/cryptknight/units/minion_sentry.unit";
			else if (!hasMage) unitPath = "players/cryptknight/units/minion_mage.unit";
			else unitPath = "players/cryptknight/units/minion_defender.unit";
		}
		else if (strongerTogetherLevel >= 5)
		{
			// Level 5: All types available
			if (!hasDefender) unitPath = "players/cryptknight/units/minion_defender.unit";
			else if (!hasFootman) unitPath = "players/cryptknight/units/minion_footman.unit";
			else if (!hasSentry) unitPath = "players/cryptknight/units/minion_sentry.unit";
			else if (!hasMage) unitPath = "players/cryptknight/units/minion_mage.unit";
			else if (!hasKnight) unitPath = "players/cryptknight/units/minion_knight.unit";
			else unitPath = "players/cryptknight/units/minion_defender.unit";
		}
		
		if (unitPath.isEmpty())
		{
			PrintError("[SpawnRaiseDeadMinion] ERROR: unitPath is empty!");
			return false;
		}
		
		PrintError("[SpawnRaiseDeadMinion] Attempting to spawn: " + unitPath);
		
		// Spawn the unit
		auto prod = Resources::GetUnitProducer(unitPath);
		if (prod is null)
		{
			PrintError("[SpawnRaiseDeadMinion] ERROR: Failed to get producer for: " + unitPath);
			return false;
		}
		
		// Check if player already has a minion of this type
		// If so, find and destroy the one with lowest health before spawning
		IOwnedUnit@ lowestHealthUnit = null;
		int lowestHealthGroupIndex = -1;
		int lowestHealthUnitIndex = -1;
		float lowestHealth = 999999.0f; // Start at very high value so first unit is always selected
		int unitsChecked = 0;
		
		PrintError("[SpawnRaiseDeadMinion] Checking for existing minions of type: " + unitPath);
		PrintError("[SpawnRaiseDeadMinion] Total summon groups: " + summons.length());
		
		for (uint i = 0; i < summons.length(); i++)
		{
			if (summons[i].m_prod is prod)
			{
				PrintError("[SpawnRaiseDeadMinion] Found matching producer at group index: " + i);
				PrintError("[SpawnRaiseDeadMinion] Units in this group: " + summons[i].m_units.length());
				
				// Found the matching producer type
				for (uint k = 0; k < summons[i].m_units.length(); k++)
				{
					auto unit = summons[i].m_units[k];
					if (unit is null || unit.GetUnit().IsDestroyed())
					{
						PrintError("[SpawnRaiseDeadMinion] Unit at index " + k + " is null or destroyed, skipping");
						continue;
					}
					
					unitsChecked++;
					
					// Get the actor to check health
					// IOwnedUnit has GetUnit() to get the UnitPtr, then we can get the script behavior
					UnitPtr unitPtr = unit.GetUnit();
					if (!unitPtr.IsValid())
					{
						PrintError("[SpawnRaiseDeadMinion] Unit " + k + " has invalid UnitPtr");
						continue;
					}
					
					auto actor = cast<Actor>(unitPtr.GetScriptBehavior());
					if (actor !is null)
					{
						float health = actor.GetHealth();
						PrintError("[SpawnRaiseDeadMinion] Unit " + k + " health: " + health + " (current lowest: " + lowestHealth + ")");
						
						// Always select first unit, then compare for lower health
						if (lowestHealthUnit is null || health < lowestHealth)
						{
							lowestHealth = health;
							@lowestHealthUnit = unit;
							lowestHealthGroupIndex = i;
							lowestHealthUnitIndex = k;
							PrintError("[SpawnRaiseDeadMinion] New lowest health unit found at index " + k + " with health " + health);
						}
					}
					else
					{
						PrintError("[SpawnRaiseDeadMinion] Unit " + k + " failed to cast to Actor");
					}
				}
				break; // Found the matching type, no need to continue
			}
		}
		
		PrintError("[SpawnRaiseDeadMinion] Checked " + unitsChecked + " units total");
		
		// If we found an existing minion of this type, destroy it first, then remove from array
		// Destroy first to ensure it's fully cleaned up before spawning the new one
		if (lowestHealthUnit !is null && lowestHealthGroupIndex != -1 && lowestHealthUnitIndex != -1)
		{
			PrintError("[SpawnRaiseDeadMinion] REPLACING existing minion:");
			PrintError("  - Group index: " + lowestHealthGroupIndex);
			PrintError("  - Unit index: " + lowestHealthUnitIndex);
			PrintError("  - Health: " + lowestHealth);
			
			// Store reference to the unit
			UnitPtr unitToDestroy = lowestHealthUnit.GetUnit();
			
			PrintError("[SpawnRaiseDeadMinion] Step 1: Destroying old unit...");
			// Destroy the unit FIRST
			if (Network::IsServer())
			{
				lowestHealthUnit.Destroy();
				PrintError("[SpawnRaiseDeadMinion] Step 2: Unit destroyed (server)");
			}
			else
			{
				(Network::Message("UnitDestroyed") << unitToDestroy).SendToHost();
				PrintError("[SpawnRaiseDeadMinion] Step 2: Unit destroy message sent to host (client)");
			}
			
			PrintError("[SpawnRaiseDeadMinion] Step 3: Removing from summons array...");
			// Remove from summons array AFTER destroying
			// This ensures the unit is gone before we spawn the new one
			summons[lowestHealthGroupIndex].m_units.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_weaponInfo.length()))
				summons[lowestHealthGroupIndex].m_weaponInfo.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_save.length()))
				summons[lowestHealthGroupIndex].m_save.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_saveData.length()))
				summons[lowestHealthGroupIndex].m_saveData.removeAt(lowestHealthUnitIndex);
			PrintError("[SpawnRaiseDeadMinion] Step 4: Removed from array, units remaining: " + summons[lowestHealthGroupIndex].m_units.length());
		}
		else
		{
			PrintError("[SpawnRaiseDeadMinion] No existing minion found to replace, spawning new one");
		}
		
		PrintError("[SpawnRaiseDeadMinion] Step 5: Spawning new unit...");
		vec2 spawnPos = pos + dir * float(m_dist);
		if (m_safeSpawn)
		{
			// Try to find a safe spawn position
			vec2 safePos = FindSafeSpawnPosition(spawnPos, owner.m_unit);
			spawnPos = safePos;
		}
		
		UnitPtr spawned = prod.Produce(g_scene, xyz(spawnPos));
		if (spawned.IsValid())
		{
			PrintError("[SpawnRaiseDeadMinion] Step 6: Unit produced successfully");
			auto ownedUnit = cast<IOwnedUnit>(spawned.GetScriptBehavior());
			if (ownedUnit !is null)
			{
				PrintError("[SpawnRaiseDeadMinion] Step 7: Initializing owned unit...");
				// Initialize the owned unit with owner and intensity
				// PlayerOwnedActor.Initialize() will automatically register the summon
				// to player.m_record.summons, which is already per-player in multiplayer
				ownedUnit.Initialize(owner, intensity, false, 0);
				PrintError("[SpawnRaiseDeadMinion] Step 8: Unit initialized and registered");
			}
			else
			{
				PrintError("[SpawnRaiseDeadMinion] ERROR: Failed to cast to IOwnedUnit");
				// Failed to get IOwnedUnit interface, destroy the spawned unit
				if (Network::IsServer())
					spawned.Destroy();
				return false;
			}
		}
		else
		{
			PrintError("[SpawnRaiseDeadMinion] ERROR: Unit production failed");
			return false;
		}
		
		PrintError("[SpawnRaiseDeadMinion] SUCCESS: Spawn complete");
		return true;
	}
	
	bool NetDoAction(SValue@ param, Actor@ owner, vec2 pos, vec2 dir)
	{
		// Network handling - the game engine will sync this to clients
		// Server spawns with intensity 1.0
		return DoAction(null, owner, null, pos, dir, 1.0f);
	}
	
	vec2 FindSafeSpawnPosition(vec2 pos, UnitPtr ownerUnit)
	{
		// Simple safe spawn: try nearby positions in a circle
		vec2 testPos = pos;
		for (int i = 0; i < 8; i++)
		{
			float angle = (float(i) / 8.0f) * PI * 2.0f;
			float dist = float(i + 1) * 5.0f;
			testPos = pos + vec2(cos(angle), sin(angle)) * dist;
			
			// Basic validation - position is within scene bounds
			// More sophisticated checks could be added here
			return testPos;
		}
		return pos; // Fallback to original position
	}
}

