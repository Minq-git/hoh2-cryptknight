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
	
	// Hook: Prevent death and trigger zombie transformation
	[Hook]
	void PlayerDamageTaken(Player@ player, DamageInfo di)
	{
		// Only process if player would die
		if (player.IsDead() || di.Damage <= 0)
			return;
			
		auto record = player.m_record;
		if (record is null)
			return;
			
		// Check if already transformed
		if (IsZombieTransformed(player))
			return;
			
		// Check if player has unwaivering_oath skill
		bool hasUnwaiveringOath = false;
		uint oathLevel = 0;
		
		// Check picked skills dictionary
		if (record.pickedSkills.exists("unwaivering_oath"))
		{
			hasUnwaiveringOath = true;
			oathLevel = uint(record.pickedSkills["unwaivering_oath"]);
		}
		
		if (!hasUnwaiveringOath || oathLevel == 0)
			return;
			
		// Check if this damage would kill the player
		// Note: HP is stored as a float 0.0-1.0 representing percentage of max health
		// Damage is in actual HP points, so we need to convert
		float currentHpPercent = record.hp;
		int maxHp = record.currStats.Health;
		float currentHp = currentHpPercent * float(maxHp);
		int damageAmount = di.Damage;
		
		// Check if damage would kill the player
		if (currentHp <= float(damageAmount))
		{
			// Prevent death and trigger transformation
			// Heal player to full HP (1.0 = 100%)
			record.hp = 1.0f;
			
			// Apply zombie transformation buff based on skill level
			string buffPath = "players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_" + oathLevel;
			auto buffDef = LoadActorBuff(buffPath);
			if (buffDef !is null)
			{
				auto actor = cast<Actor>(player);
				if (actor !is null)
				{
					actor.ApplyBuff(ActorBuff(actor, buffDef, 1.0f, false));
					
					// Mark as transformed (use peer ID as key since Guid doesn't have ToString)
					g_zombieTransformed[record.peer] = true;
				}
			}
			
			// Set damage to 0 to prevent death
			di.Damage = 0;
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
			if (player.peer == 255 || player.IsDead())
				continue;
				
			auto playerBase = cast<PlayerBase>(player.actor);
			if (playerBase is null)
				continue;
				
			bool isZombie = IsZombieTransformed(playerBase);
			
			if (isZombie)
			{
				// Check if zombie buff has expired
				auto actor = cast<Actor>(playerBase);
				if (actor !is null)
				{
					auto buffList = actor.GetBuffList();
					if (buffList !is null)
					{
						bool hasZombieBuff = false;
						for (uint j = 0; j < buffList.m_buffs.length(); j++)
						{
							auto buff = buffList.m_buffs[j];
							uint pathHash = buff.m_def.m_pathHash;
							if (pathHash == g_zombieBuffHash1 || pathHash == g_zombieBuffHash2 || 
							    pathHash == g_zombieBuffHash3 || pathHash == g_zombieBuffHash4 || 
							    pathHash == g_zombieBuffHash5)
							{
								hasZombieBuff = true;
								break;
							}
						}
						
						// If buff expired, kill the player
						if (!hasZombieBuff)
						{
							playerBase.m_record.hp = 0.0f;
							if (g_zombieTransformed.exists(player.peer))
								g_zombieTransformed.delete(player.peer);
							continue;
						}
					}
				}
				
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
