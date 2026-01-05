namespace Modifiers
{
	// Custom modifier: Provides damage reduction for Pestilence buff based on skill level
	// Level 1: 10% reduction (0.9 multiplier)
	// Level 2: 20% reduction (0.8 multiplier)
	// Level 3: 30% reduction (0.7 multiplier)
	// Level 4: 40% reduction (0.6 multiplier)
	// Level 5: 50% reduction (0.5 multiplier)
	class PestilenceDamageReduction : Modifier
	{
		PestilenceDamageReduction() { }
		PestilenceDamageReduction(UnitPtr unit, SValue& params)
		{
			// No parameters needed - we'll read skill level from player
		}

		Modifier@ Instance() override
		{
			auto ret = PestilenceDamageReduction();
			ret = this;
			ret.m_cloned++;
			return ret;
		}

		ModDynamism HasDamageTakenMul() override { return ModDynamism::Dynamic; }
		float DamageTakenMul(PlayerBase@ player, Actor@ attacker, DamageInfo& dmg, float intensity) override
		{
			if (player is null || player.m_record is null)
				return 1.0f;
			
			// Get the pestilence skill level
			uint skillLevel = 1;
			if (player.m_record.pickedSkills.exists("pestilence"))
				skillLevel = uint(player.m_record.pickedSkills["pestilence"]);
			
			// Calculate damage reduction multiplier based on skill level
			// Level 1: 10% reduction = 0.9, Level 2: 20% = 0.8, Level 3: 30% = 0.7, Level 4: 40% = 0.6, Level 5: 50% = 0.5
			float dmgReductionPercent = 0.1f + (float(skillLevel - 1) * 0.1f);
			float dmgMultiplier = 1.0f - dmgReductionPercent;
			
			// Clamp to valid range (0.5 to 0.9)
			dmgMultiplier = clamp(dmgMultiplier, 0.5f, 0.9f);
			
			// Return the damage multiplier (DamageTakenMul applies this as: finalDamage = damage * multiplier)
			return dmgMultiplier;
		}
	}
}

