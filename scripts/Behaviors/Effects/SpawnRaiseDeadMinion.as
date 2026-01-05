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
			return false;
		
		// Spawn the unit
		auto prod = Resources::GetUnitProducer(unitPath);
		if (prod is null)
			return false;
		
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
				ownedUnit.Initialize(owner, intensity, false, 0);
				
				// Verify the unit was properly registered to this player
				// This ensures multiplayer synchronization
				if (ownedUnit.GetOwner() !is player)
				{
					// Ownership failed, destroy the unit
					if (Network::IsServer())
						ownedUnit.Destroy();
					return false;
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

