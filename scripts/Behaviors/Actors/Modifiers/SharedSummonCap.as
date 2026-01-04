namespace Modifiers
{
	class SharedSummonCap : Modifier
	{
		ivec2 m_maxSummons;
		array<UnitProducer@> m_producers;

		SharedSummonCap(UnitPtr unit, SValue& params)
		{
			// Try to read bind parameter first
			// The game engine should resolve binds, but if it doesn't work, try reading as string
			m_maxSummons = GetParamIVec2(unit, params, "max-summons-bind", false, ivec2(0));
			
			// If bind not found or is 0, try reading as direct parameter
			if (m_maxSummons.x == 0 && m_maxSummons.y == 0)
			{
				m_maxSummons = GetParamIVec2(unit, params, "max-summons", false, ivec2(1));
			}

			array<SValue@>@ unitsArr = GetParamArray(unit, params, "units", false);
			if (unitsArr !is null)
			{
				for (uint i = 0; i < unitsArr.length(); i++)
				{
					auto prod = Resources::GetUnitProducer(unitsArr[i].GetString());
					if (prod !is null)
						m_producers.insertLast(prod);
				}
			}
		}

		ModDynamism HasModifyPlayerSummons() override { return ModDynamism::Dynamic; }
		void ModifyPlayerSummons(PlayerBase@ player, float intensity) override
		{
			// Calculate max count from the ivec2 range (x = min level, y = max level)
			// If bind wasn't resolved correctly, try to get it from stronger_together skill level
			int maxCount = lerp(m_maxSummons, intensity);
			
			// If bind failed (x == 0 && y == 0), calculate from stronger_together skill level
			if (m_maxSummons.x == 0 && m_maxSummons.y == 0)
			{
				auto@ strongerTogetherDef = player.m_record.playerClass.GetSkillDef(HashString("stronger_together"));
				if (strongerTogetherDef !is null)
				{
					uint skillLevel = player.m_record.GetSkillLevel(strongerTogetherDef);
					// Cap progression: 0->1, 1->1, 2->2, 3->3, 4->4, 5->5
					maxCount = int(skillLevel == 0 ? 1 : skillLevel);
				}
				else
				{
					maxCount = 1; // Base cap
				}
			}
			
			// If this is the base cap (1) and player has stronger_together, skip enforcement
			// (let the stronger_together modifier handle it with higher cap)
			if (maxCount == 1)
			{
				auto@ strongerTogetherDef = player.m_record.playerClass.GetSkillDef(HashString("stronger_together"));
				if (strongerTogetherDef !is null && player.m_record.GetSkillLevel(strongerTogetherDef) > 0)
					return; // Skip base cap enforcement, let stronger_together handle it
			}
			
			// Use this modifier's cap as the effective cap
			int effectiveMaxCount = maxCount;
			
			auto@ summons = player.m_record.summons;
			
			// First pass: Set individual max to 1 for each type and remove excess
			for (uint i = 0; i < summons.length(); i++)
			{
				bool isTracked = false;
				for (uint j = 0; j < m_producers.length(); j++)
				{
					if (summons[i].m_prod is m_producers[j])
					{
						isTracked = true;
						break;
					}
				}
				
				if (isTracked)
				{
					// Enforce max 1 per minion type
					summons[i].m_maxSummons = 1;
					
					// Remove excess units of this type (keep only the first one)
					// Remove from the end to avoid index shifting issues
					while (summons[i].m_units.length() > 1)
					{
						int lastIndex = int(summons[i].m_units.length()) - 1;
						auto excessUnit = summons[i].m_units[lastIndex];
						
						if (excessUnit !is null && !excessUnit.GetUnit().IsDestroyed())
						{
							if (Network::IsServer())
								excessUnit.Destroy();
							else
								(Network::Message("UnitDestroyed") << excessUnit.GetUnit()).SendToHost();
						}
						
						summons[i].m_units.removeAt(lastIndex);
						if (lastIndex < int(summons[i].m_weaponInfo.length()))
							summons[i].m_weaponInfo.removeAt(lastIndex);
						if (lastIndex < int(summons[i].m_save.length()))
							summons[i].m_save.removeAt(lastIndex);
						if (lastIndex < int(summons[i].m_saveData.length()))
							summons[i].m_saveData.removeAt(lastIndex);
					}
				}
			}
			
			// Second pass: Count total valid units
			int currentCount = 0;
			for (uint i = 0; i < summons.length(); i++)
			{
				bool isTracked = false;
				for (uint j = 0; j < m_producers.length(); j++)
				{
					if (summons[i].m_prod is m_producers[j])
					{
						isTracked = true;
						break;
					}
				}
				
				if (isTracked)
				{
					for (uint k = 0; k < summons[i].m_units.length(); k++)
					{
						if (summons[i].m_units[k] !is null && !summons[i].m_units[k].GetUnit().IsDestroyed())
							currentCount++;
					}
				}
			}
			
			// Third pass: Remove oldest if over the shared total cap
			int overflow = currentCount - effectiveMaxCount;
			if (overflow > 0)
			{
				// Remove oldest across all tracked types (FIFO) until we're under the cap
				while (overflow > 0)
				{
					// Find the oldest unit among tracked groups
					IOwnedUnit@ oldestUnit = null;
					int oldestGroupIndex = -1;
					int oldestUnitIndex = -1;
					
					for (uint i = 0; i < summons.length(); i++)
					{
						// Skip empty groups
						if (summons[i].m_units.length() == 0)
							continue;

						bool isTracked = false;
						for (uint j = 0; j < m_producers.length(); j++)
						{
							if (summons[i].m_prod is m_producers[j])
							{
								isTracked = true;
								break;
							}
						}
						
						if (!isTracked)
							continue;

						// Find the oldest unit in this group (first in array = oldest)
						for (uint k = 0; k < summons[i].m_units.length(); k++)
						{
							auto candidateUnit = summons[i].m_units[k];
							if (candidateUnit is null || candidateUnit.GetUnit().IsDestroyed())
								continue;
							
							if (oldestUnit is null)
							{
								@oldestUnit = candidateUnit;
								oldestGroupIndex = i;
								oldestUnitIndex = k;
							}
							else
							{
								// Compare by Unit ID (lower ID = older)
								if (candidateUnit.GetUnit().GetId() < oldestUnit.GetUnit().GetId())
								{
									@oldestUnit = candidateUnit;
									oldestGroupIndex = i;
									oldestUnitIndex = k;
								}
							}
						}
					}
					
					if (oldestUnit !is null && oldestGroupIndex != -1 && oldestUnitIndex != -1)
					{
						// Destroy the oldest unit found
						if (Network::IsServer())
							oldestUnit.Destroy();
						else
							(Network::Message("UnitDestroyed") << oldestUnit.GetUnit()).SendToHost();
						
						summons[oldestGroupIndex].m_units.removeAt(oldestUnitIndex);
						if (oldestUnitIndex < int(summons[oldestGroupIndex].m_weaponInfo.length()))
							summons[oldestGroupIndex].m_weaponInfo.removeAt(oldestUnitIndex);
						if (oldestUnitIndex < int(summons[oldestGroupIndex].m_save.length()))
							summons[oldestGroupIndex].m_save.removeAt(oldestUnitIndex);
						if (oldestUnitIndex < int(summons[oldestGroupIndex].m_saveData.length()))
							summons[oldestGroupIndex].m_saveData.removeAt(oldestUnitIndex);
						
						overflow--;
					}
					else
					{
						// Should not happen if overflow > 0 and counting was correct
						break;
					}
				}
			}
		}
	}
}

