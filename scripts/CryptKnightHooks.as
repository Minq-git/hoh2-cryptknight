namespace CryptKnight
{
	// Track zombie transformation state per player
	dictionary g_zombieTransformed;
	
	// Hash strings for zombie transformation buffs (full path)
	uint g_zombieBuffHash1 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_1");
	uint g_zombieBuffHash2 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_2");
	uint g_zombieBuffHash3 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_3");
	uint g_zombieBuffHash4 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_4");
	uint g_zombieBuffHash5 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_5");
	uint g_unwaveringOathBuffHash = HashString("players/cryptknight/buffs/skills_buffs.sval:unwavering_oath_active");
	
	bool IsZombieTransformed(PlayerBase@ player)
	{
		if (player is null)
			return false;
			
		auto actor = cast<Actor>(player);
		if (actor is null)
			return false;
			
		auto buffList = actor.GetBuffList();
		if (buffList is null)
			return false;
		
		// Check for zombie transformation buffs
		for (uint i = 0; i < buffList.m_buffs.length(); i++)
		{
			auto buff = buffList.m_buffs[i];
			uint pathHash = buff.m_def.m_pathHash;
			if (pathHash == g_zombieBuffHash1 || pathHash == g_zombieBuffHash2 || 
			    pathHash == g_zombieBuffHash3 || pathHash == g_zombieBuffHash4 || 
			    pathHash == g_zombieBuffHash5)
			{
				return true;
			}
		}
		
		return false;
	}
	
	// Hook: Make player immune during zombie form
	[Hook]
	void PlayerDamageTaken(Player@ player, DamageInfo di)
	{
		if (player.IsDead() || di.Damage <= 0)
			return;
			
		auto record = player.m_record;
		if (record is null)
			return;
			
		// Player extends PlayerBase, so we can use it directly
		PlayerBase@ playerBase = player;
		if (playerBase is null)
			return;
			
		// If already transformed, make immune to all damage and lock HP to 1
		if (IsZombieTransformed(playerBase))
		{
			// Set damage to 0 - complete immunity
			di.Damage = 0;
			// Continuously lock HP to 1 (1 HP point) - prevent it from going below 1
			int maxHp = record.currStats.Health;
			if (maxHp > 0)
			{
				float oneHpPercent = 1.0f / float(maxHp);
				if (record.hp < oneHpPercent)
					record.hp = oneHpPercent;
			}
			return;
		}
	}
	
	// Hook: Make player immune during zombie form (before damage calculation)
	[Hook]
	void PlayerDamage(Player@ player, DamageInfo dmg)
	{
		if (player.IsDead())
			return;
			
		PlayerBase@ playerBase = player;
		if (playerBase is null)
			return;
			
		// If already transformed, make immune to all damage
		if (IsZombieTransformed(playerBase))
		{
			// Set all damage types to 0 for complete immunity
			dmg.PhysicalDamage = 0;
			dmg.FireDamage = 0;
			dmg.IceDamage = 0;
			dmg.LightningDamage = 0;
			dmg.PureDamage = 0;
			dmg.PoisonDamage = 0;
			dmg.Damage = 0;
			return;
		}
	}
	
	// Hook: Clean up zombie state on player spawn/load to prevent save state issues
	[Hook]
	void GameModeSpawnPlayer(AGameplayGameMode@ gameMode, int i, vec2 pos)
	{
		// Clear any lingering zombie transformation state when player spawns
		// This prevents issues with save states where player might be stuck as corpse
		if (i >= 0 && i < int(g_players.length()))
		{
			auto player = g_players[i];
			if (player.peer != 255)
			{
				// Clear zombie state on spawn
				if (g_zombieTransformed.exists(player.peer))
				{
					g_zombieTransformed.delete(player.peer);
				}
				
				// Remove any lingering unwavering oath active buff
				auto playerBase = cast<PlayerBase>(player.actor);
				if (playerBase !is null)
				{
					auto actor = cast<Actor>(playerBase);
					if (actor !is null)
					{
						auto buffList = actor.GetBuffList();
						if (buffList !is null)
						{
							for (uint j = 0; j < buffList.m_buffs.length(); j++)
							{
								auto buff = buffList.m_buffs[j];
								if (buff.m_def.m_pathHash == g_unwaveringOathBuffHash)
								{
									buff.Clear();
									buffList.m_buffs.removeAt(j);
									break;
								}
							}
						}
					}
				}
			}
		}
	}
	
	// Hook: Update to check for expired zombie buffs and kill player, and block skills
	[Hook]
	void GameModeUpdate(BaseGameMode@ baseGameMode, int ms, GameInput& gameInput, MenuInput& menuInput)
	{
		// Check all players for expired zombie buffs and block skills
		for (uint i = 0; i < g_players.length(); i++)
		{
			auto player = g_players[i];
			if (player.peer == 255)
				continue;
				
			auto playerBase = cast<PlayerBase>(player.actor);
			if (playerBase is null)
				continue;
				
			// If player has zombie buff, continuously lock HP to 1 and ensure they're immune
			bool isZombie = IsZombieTransformed(playerBase);
			if (isZombie)
			{
				// Continuously lock HP to 1 (1 HP point) - prevent it from going below 1
				// This ensures HP never drops below 1 during the entire buff duration
				int maxHp = playerBase.m_record.currStats.Health;
				if (maxHp > 0)
				{
					float oneHpPercent = 1.0f / float(maxHp);
					if (playerBase.m_record.hp < oneHpPercent)
						playerBase.m_record.hp = oneHpPercent;
				}
			}
			
			if (player.IsDead())
				continue;
				
			isZombie = IsZombieTransformed(playerBase);
			
			// If player is in zombie form, check if tracking buff is about to expire (last second)
			if (isZombie)
			{
				auto actor = cast<Actor>(playerBase);
				if (actor !is null)
				{
					auto buffList = actor.GetBuffList();
					if (buffList !is null)
					{
						bool foundTrackingBuff = false;
						bool shouldKill = false;
						
						for (uint j = 0; j < buffList.m_buffs.length(); j++)
						{
							auto buff = buffList.m_buffs[j];
							uint pathHash = buff.m_def.m_pathHash;
							
							// Check if tracking buff exists
							if (pathHash == g_unwaveringOathBuffHash)
							{
								foundTrackingBuff = true;
								// Kill player when buff has <= 1 second remaining
								if (buff.m_duration <= 1000)
								{
									shouldKill = true;
								}
								break;
							}
						}
						
						// If tracking buff doesn't exist (removed by game) OR has <= 1 second remaining, kill the player
						if (!foundTrackingBuff || shouldKill)
						{
							// Remove unwavering oath tracking buff if present
							if (foundTrackingBuff)
							{
								for (uint k = 0; k < buffList.m_buffs.length(); k++)
								{
									auto buff = buffList.m_buffs[k];
									if (buff.m_def.m_pathHash == g_unwaveringOathBuffHash)
									{
										buff.Clear();
										buffList.m_buffs.removeAt(k);
										break;
									}
								}
							}
							
							// Kill the player - trigger death properly
							// Get player position and direction before destroying
							vec2 deathDir = vec2(1, 0);
							if (playerBase.m_unit.IsValid())
							{
								// Try to get last direction if available
								auto playerActor = cast<Player>(playerBase);
								if (playerActor !is null)
									deathDir = playerActor.m_lastDirection;
							}
							
							// Create empty damage info for death
							DamageInfo deathDmg;
							
							// Ensure HP is at 0 or below to trigger death properly
							playerBase.m_record.hp = 0.0f;
							
							// Call OnDeath to properly handle death (spawns corpse, sets deadTime, etc.)
							playerBase.OnDeath(deathDmg, deathDir);
							
							// Clean up zombie state
							if (g_zombieTransformed.exists(player.peer))
								g_zombieTransformed.delete(player.peer);
							continue;
						}
					}
				}
			}
			
			if (isZombie)
			{
				
				// Block Q, E, V skills (class skills) when in zombie form
				// Set their cooldowns to maximum to prevent use
				for (uint j = 0; j < playerBase.m_skills.length(); j++)
				{
					auto skill = playerBase.m_skills[j];
					if (skill is null)
						continue;
						
					// Block spells (Q, E, V slots)
					// Allow melee skills (mainhand/offhand) and zombie skills
					if (skill.m_type == PlayerSkillType::Spell)
					{
						uint skillId = skill.m_skillId;
						// Don't block zombie skills
						if (skillId != HashString("zombie_claw") && skillId != HashString("zombie_bite"))
						{
							// Set cooldown to maximum to prevent activation
							// Note: Cooldown members only exist in ActiveSkill, need to cast
							auto activeSkill = cast<Skills::ActiveSkill>(skill);
							if (activeSkill !is null)
							{
								if (activeSkill.m_cooldownC < activeSkill.m_cooldown)
									activeSkill.m_cooldownC = activeSkill.m_cooldown;
							}
						}
					}
				}
			}
		}
	}
}
