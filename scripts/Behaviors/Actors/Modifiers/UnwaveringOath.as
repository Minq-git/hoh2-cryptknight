namespace Modifiers
{
	class UnwaveringOath : Modifier
	{
		string m_zombieBuffPath;
		string m_trackingBuffPath;
		string m_cooldownBuffPath;
		uint m_oathLevel;
		
		UnwaveringOath(UnitPtr unit, SValue& params)
		{
			// We'll get the buff path dynamically based on skill level from the player
			// Store the base path pattern
			m_zombieBuffPath = ""; // Will be set dynamically
			m_trackingBuffPath = "players/cryptknight/buffs/skills_buffs.sval:unwavering_oath_active";
			m_cooldownBuffPath = "players/cryptknight/buffs/skills_buffs.sval:unwavering_oath_cooldown";
			
			// Get skill level from params (default to 1)
			m_oathLevel = GetParamInt(unit, params, "level", false, 1);
			PrintError("[UnwaveringOath] Constructor: level = " + m_oathLevel);
		}
		
		string GetZombieBuffPath(uint level)
		{
			// Construct the buff path based on skill level
			return "players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_" + level;
		}

		ModDynamism HasNonLethalDamage() override { return ModDynamism::Dynamic; }
		bool NonLethalDamage(PlayerBase@ player, Actor@ attacker, DamageInfo& dmg, float intensity) override
		{
			if (player is null || player.m_record is null)
				return false;
			
			// Check if damage would kill the player (reduce HP to 1 or below)
			int maxHp = player.m_record.currStats.Health;
			if (maxHp <= 0)
				return false;
			
			float currentHpPercent = player.m_record.hp;
			int currentHp = int(currentHpPercent * float(maxHp) + 0.5f);
			
			// Calculate estimated final damage (after armor/resistance)
			// We use raw damage as a conservative estimate
			int rawDamage = dmg.PhysicalDamage + dmg.FireDamage + dmg.IceDamage + 
			                dmg.LightningDamage + dmg.PureDamage + dmg.PoisonDamage;
			
			// If raw damage >= current HP, it could be lethal
			if (rawDamage >= currentHp)
				return true;
			
			return false;
		}
		
		ModDynamism HasDamageTaken() override { return ModDynamism::Dynamic; }
		void DamageTaken(PlayerBase@ player, Actor@ enemy, int dmgAmnt, float intensity) override
		{
			if (player is null || player.m_record is null || dmgAmnt <= 0)
			{
				PrintError("[UnwaveringOath] DamageTaken: Early return - player null or no damage");
				return;
			}
			
			// Check if player already has zombie transformation buff
			auto actor = cast<Actor>(player);
			if (actor is null)
			{
				PrintError("[UnwaveringOath] DamageTaken: Actor is null");
				return;
			}
			
			auto buffList = actor.GetBuffList();
			if (buffList !is null)
			{
				uint trackingBuffHash = HashString(m_trackingBuffPath);
				uint cooldownBuffHash = HashString(m_cooldownBuffPath);
				// Check for any zombie transformation buff (levels 1-5) OR tracking buff OR cooldown buff
				// If any exists, we can't trigger the transformation
				for (uint i = 0; i < buffList.m_buffs.length(); i++)
				{
					uint pathHash = buffList.m_buffs[i].m_def.m_pathHash;
					uint hash1 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_1");
					uint hash2 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_2");
					uint hash3 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_3");
					uint hash4 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_4");
					uint hash5 = HashString("players/cryptknight/buffs/skills_buffs.sval:zombie_transformation_5");
					if (pathHash == hash1 || pathHash == hash2 || pathHash == hash3 || pathHash == hash4 || pathHash == hash5 || pathHash == trackingBuffHash || pathHash == cooldownBuffHash)
					{
						// Already transformed or on cooldown, don't apply again
						if (pathHash == cooldownBuffHash)
							PrintError("[UnwaveringOath] DamageTaken: On cooldown, skipping");
						else
							PrintError("[UnwaveringOath] DamageTaken: Already has zombie or tracking buff, skipping");
						return;
					}
				}
			}
			
			// Check if HP is at or below 1 HP point
			int maxHp = player.m_record.currStats.Health;
			if (maxHp <= 0)
			{
				PrintError("[UnwaveringOath] DamageTaken: Max HP is 0 or negative");
				return;
			}
			
			float currentHpPercent = player.m_record.hp;
			float oneHpPercent = 1.0f / float(maxHp);
			int currentHp = int(currentHpPercent * float(maxHp) + 0.5f);
			
			PrintError("[UnwaveringOath] DamageTaken: HP=" + currentHp + "/" + maxHp + " (" + currentHpPercent + "), damage=" + dmgAmnt);
			
			// If HP is at 1 or below, apply zombie transformation
			if (currentHp <= 1)
			{
				PrintError("[UnwaveringOath] DamageTaken: HP <= 1, applying transformation");
				
				// Get the actual skill level from the player's record
				uint actualLevel = m_oathLevel;
				if (player.m_record.pickedSkills.exists("unwavering_oath"))
				{
					actualLevel = uint(player.m_record.pickedSkills["unwavering_oath"]);
					PrintError("[UnwaveringOath] Got skill level from pickedSkills: " + actualLevel);
				}
				else
				{
					PrintError("[UnwaveringOath] Using default level: " + actualLevel);
				}
				
				// Lock HP to exactly 1 HP point
				player.m_record.hp = max(player.m_record.hp, oneHpPercent);
				
				// Get the zombie buff path based on skill level
				string zombieBuffPath = GetZombieBuffPath(actualLevel);
				PrintError("[UnwaveringOath] Loading zombie buff: " + zombieBuffPath);
				
				// Apply zombie transformation buff
				if (zombieBuffPath != "")
				{
					auto buffDef = LoadActorBuff(zombieBuffPath);
					if (buffDef !is null)
					{
						// Get the duration from the zombie buff
						int zombieDuration = buffDef.m_duration;
						PrintError("[UnwaveringOath] Zombie buff duration: " + zombieDuration);
						
						// Apply zombie transformation buff
						actor.ApplyBuff(ActorBuff(actor, buffDef, 1.0f, false));
						PrintError("[UnwaveringOath] Applied zombie buff");
						
						// Apply unwavering oath tracking buff with the same duration
						// This will show a timer in the UI
						// IMPORTANT: Only apply once - check if it already exists first
						auto trackingBuffList = actor.GetBuffList();
						uint trackingBuffHash = HashString(m_trackingBuffPath);
						bool trackingBuffExists = false;
						
						if (trackingBuffList !is null)
						{
							for (uint i = 0; i < trackingBuffList.m_buffs.length(); i++)
							{
								if (trackingBuffList.m_buffs[i].m_def.m_pathHash == trackingBuffHash)
								{
									trackingBuffExists = true;
									PrintError("[UnwaveringOath] Tracking buff already exists, not re-applying");
									break;
								}
							}
						}
						
						if (!trackingBuffExists)
						{
							PrintError("[UnwaveringOath] Loading tracking buff: " + m_trackingBuffPath);
							auto trackingBuffDef = LoadActorBuff(m_trackingBuffPath);
							if (trackingBuffDef !is null)
							{
								PrintError("[UnwaveringOath] Tracking buff loaded, original duration: " + trackingBuffDef.m_duration);
								
								// Temporarily modify the definition's duration to match zombie buff
								// This ensures the UI displays the correct duration
								int originalDefDuration = trackingBuffDef.m_duration;
								trackingBuffDef.m_duration = zombieDuration;
								
								// Create and apply the buff with the modified duration
								auto trackingBuff = ActorBuff(actor, trackingBuffDef, 1.0f, false);
								// Also set the instance duration explicitly (in case it's initialized from definition)
								trackingBuff.m_duration = zombieDuration;
								PrintError("[UnwaveringOath] Set tracking buff duration to: " + zombieDuration);
								
								// Apply the buff
								actor.ApplyBuff(trackingBuff);
								PrintError("[UnwaveringOath] Applied tracking buff with duration: " + zombieDuration);
								
								// Restore the original definition duration for future uses
								trackingBuffDef.m_duration = originalDefDuration;
								
								// Verify and ensure the buff instance has the correct duration
								if (trackingBuffList !is null)
								{
									for (uint i = 0; i < trackingBuffList.m_buffs.length(); i++)
									{
										auto buff = trackingBuffList.m_buffs[i];
										if (buff.m_def.m_pathHash == trackingBuffHash)
										{
											// Ensure the instance duration matches (in case it was reset)
											buff.m_duration = zombieDuration;
											PrintError("[UnwaveringOath] Verified and set tracking buff duration: " + buff.m_duration);
											break;
										}
									}
								}
							}
							else
							{
								PrintError("[UnwaveringOath] ERROR: Failed to load tracking buff definition: " + m_trackingBuffPath);
							}
						}
					}
					else
					{
						PrintError("[UnwaveringOath] ERROR: Failed to load zombie buff definition: " + m_zombieBuffPath);
					}
				}
				else
				{
					PrintError("[UnwaveringOath] ERROR: m_zombieBuffPath is empty!");
				}
			}
			else
			{
				PrintError("[UnwaveringOath] DamageTaken: HP > 1, not applying transformation");
			}
		}
	}
}

