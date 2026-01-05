class SpawnRaiseDeadMinion : IAction
{
	int m_dist;
	bool m_safeSpawn;
	uint m_weaponInfo;
	
	SpawnRaiseDeadMinion(UnitPtr unit, SValue& params)
	{
		m_dist = GetParamInt(unit, params, "dist", false, 40);
		m_safeSpawn = GetParamBool(unit, params, "safe-spawn", false, false);
		m_weaponInfo = 0;
	}
	
	void CancelAction() {}
	void SetWeaponInformation(uint weapon) { m_weaponInfo = weapon; }
	void Update(int dt, int cooldown) {}
	bool NeedNetParams() { return true; }
	
	bool DoAction(SValueBuilder@ builder, Actor@ owner, Actor@ target, vec2 pos, vec2 dir, float intensity)
	{
		// Only the server can spawn units in multiplayer
		// In single player, IsServer() returns true, so this works for both cases
		if (!Network::IsServer())
		{
			// Client: Push intensity to builder and return true
			// The game engine will send this to the server and call NetDoAction()
			if (builder !is null)
				builder.PushFloat(intensity);
			return true;
		}
		
		if (owner is null)
			return false;
		
		auto player = cast<PlayerBase>(owner);
		if (player is null || player.m_record is null)
			return false;
		
		auto@ summons = player.m_record.summons;
		
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
			return false;
		
		// Spawn the unit
		auto prod = Resources::GetUnitProducer(unitPath);
		if (prod is null)
			return false;
		
		// Check if player already has a minion of this type
		// If so, find and destroy the one with lowest health before spawning
		IOwnedUnit@ lowestHealthUnit = null;
		int lowestHealthGroupIndex = -1;
		int lowestHealthUnitIndex = -1;
		float lowestHealth = 999999.0f; // Start at very high value so first unit is always selected
		
		// First, clean up any destroyed units from the array
		// Only clean up units that are definitely destroyed - be conservative to avoid removing units
		// that are still syncing in multiplayer
		for (uint i = 0; i < summons.length(); i++)
		{
			if (summons[i].m_prod is prod)
			{
				// Clean up destroyed units from this group (iterate backwards to avoid index issues)
				for (int k = int(summons[i].m_units.length()) - 1; k >= 0; k--)
				{
					auto unit = summons[i].m_units[k];
					if (unit is null)
					{
						summons[i].m_units.removeAt(k);
						if (k < int(summons[i].m_weaponInfo.length()))
							summons[i].m_weaponInfo.removeAt(k);
						if (k < int(summons[i].m_save.length()))
							summons[i].m_save.removeAt(k);
						if (k < int(summons[i].m_saveData.length()))
							summons[i].m_saveData.removeAt(k);
					}
					else
					{
						// Only remove if unit is definitely destroyed
						// Don't check IsValid() as it might return false for units that are still syncing
						UnitPtr unitPtr = unit.GetUnit();
						if (unitPtr.IsDestroyed())
						{
							summons[i].m_units.removeAt(k);
							if (k < int(summons[i].m_weaponInfo.length()))
								summons[i].m_weaponInfo.removeAt(k);
							if (k < int(summons[i].m_save.length()))
								summons[i].m_save.removeAt(k);
							if (k < int(summons[i].m_saveData.length()))
								summons[i].m_saveData.removeAt(k);
						}
					}
				}
			}
		}
		
		for (uint i = 0; i < summons.length(); i++)
		{
			if (summons[i].m_prod is prod)
			{
				// Found the matching producer type
				for (uint k = 0; k < summons[i].m_units.length(); k++)
				{
					auto unit = summons[i].m_units[k];
					if (unit is null || unit.GetUnit().IsDestroyed())
						continue;
					
					// Get the actor to check health
					UnitPtr unitPtr = unit.GetUnit();
					if (!unitPtr.IsValid())
						continue;
					
					auto actor = cast<Actor>(unitPtr.GetScriptBehavior());
					if (actor !is null)
					{
						float health = actor.GetHealth();
						
						// Always select first unit, then compare for lower health
						if (lowestHealthUnit is null || health < lowestHealth)
						{
							lowestHealth = health;
							@lowestHealthUnit = unit;
							lowestHealthGroupIndex = i;
							lowestHealthUnitIndex = k;
						}
					}
				}
				break; // Found the matching type, no need to continue
			}
		}
		
		// If we found an existing minion of this type, destroy it first, then remove from array
		// Destroy first to ensure it's fully cleaned up before spawning the new one
		if (lowestHealthUnit !is null && lowestHealthGroupIndex != -1 && lowestHealthUnitIndex != -1)
		{
			// Store reference to the unit
			UnitPtr unitToDestroy = lowestHealthUnit.GetUnit();
			
			// Destroy the unit FIRST
			if (Network::IsServer())
			{
				lowestHealthUnit.Destroy();
			}
			else
			{
				(Network::Message("UnitDestroyed") << unitToDestroy).SendToHost();
			}
			
			// Remove from summons array AFTER destroying
			// This ensures the unit is gone before we spawn the new one
			summons[lowestHealthGroupIndex].m_units.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_weaponInfo.length()))
				summons[lowestHealthGroupIndex].m_weaponInfo.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_save.length()))
				summons[lowestHealthGroupIndex].m_save.removeAt(lowestHealthUnitIndex);
			if (lowestHealthUnitIndex < int(summons[lowestHealthGroupIndex].m_saveData.length()))
				summons[lowestHealthGroupIndex].m_saveData.removeAt(lowestHealthUnitIndex);
		}
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
			auto ownedUnit = cast<IOwnedUnit>(spawned.GetScriptBehavior());
			if (ownedUnit !is null)
			{
				// Initialize the owned unit with owner and intensity
				// PlayerOwnedActor.Initialize() will automatically register the summon
				// to player.m_record.summons, which is already per-player in multiplayer
				// Pass weapon info (matching SpawnUnit pattern)
				ownedUnit.Initialize(owner, intensity, false, m_weaponInfo);
				
				// Send network message to clients so they can initialize the unit locally
				// This matches the pattern from SpawnUnitBase::SpawnUnitBaseImpl()
				// Clients need to call Initialize() with husk=true to register in their local summons array
				if (Network::IsServer())
				{
					(Network::Message("SpawnedOwnedUnit") << prod.GetResourceHash() << spawned.GetId() << spawnPos << "" << 0 << owner.m_unit << 0 << intensity << int(m_weaponInfo)).SendToAll();
				}
				
				// Ensure the cap is set correctly immediately after registration
				// This prevents the base game from destroying the unit before modifiers apply
				for (uint i = 0; i < summons.length(); i++)
				{
					if (summons[i].m_prod is prod)
					{
						// Set cap to 1 (base) + 0 (from modifier) = 1
						// This matches what ModifySummons with add-max-num: 0 should do
						if (summons[i].m_maxSummons < 1)
							summons[i].m_maxSummons = 1;
						break;
					}
				}
			}
			else
			{
				// Failed to get IOwnedUnit interface, destroy the spawned unit
				if (Network::IsServer())
					spawned.Destroy();
				return false;
			}
		}
		else
		{
			return false;
		}
		
		return true;
	}
	
	bool NetDoAction(SValue@ param, Actor@ owner, vec2 pos, vec2 dir)
	{
		// Network handling - only the server should execute this
		// Clients will have their actions synced by the server
		if (!Network::IsServer())
			return false;
		
		// Extract intensity from network parameter (pushed by client)
		float intensity = 1.0f;
		if (param !is null)
			intensity = param.GetFloat();
		
		return DoAction(null, owner, null, pos, dir, intensity);
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

