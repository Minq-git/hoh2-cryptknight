namespace Modifiers
{
	class SharedSummonCap : Modifier
	{
		ivec2 m_maxSummons;
		array<UnitProducer@> m_producers;

		SharedSummonCap(UnitPtr unit, SValue& params)
		{
			m_maxSummons = GetParamIVec2(unit, params, "max-summons", false, ivec2(1));
			auto bind = GetParamString(unit, params, "max-summons-bind", false);
			if (!bind.isEmpty())
				m_maxSummons = GetParamIVec2(unit, params, bind, false, ivec2(1));

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
			int maxCount = lerp(m_maxSummons, intensity);
			int currentCount = 0;
			
			auto@ summons = player.m_record.summons;
			
			// First pass: Count total summons of our tracked types
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
					// Set individual max high so they don't self-destruct individually
					summons[i].m_maxSummons = 1000; 
					
					// Count valid units only
					for (uint k = 0; k < summons[i].m_units.length(); k++)
					{
						if (summons[i].m_units[k] !is null && !summons[i].m_units[k].GetUnit().IsDestroyed())
							currentCount++;
					}
				}
			}
			
			// Second pass: Remove oldest if over cap
			int overflow = currentCount - maxCount;
			if (overflow > 0)
			{
				// Remove oldest across all tracked types.
				// PlayerRecord doesn't strictly order groups by time, but units within a group are ordered.
				// We iterate repeatedly, finding the oldest unit (by creation time if possible, or just index) across all tracked groups.
				
				while (overflow > 0)
				{
					// Find the oldest unit among tracked groups
					IOwnedUnit@ oldestUnit = null;
					int oldestGroupIndex = -1;
					
					for (uint i = 0; i < summons.length(); i++)
					{
						// Skip empty or untracked groups
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

						// Found a candidate group with units
						auto candidateUnit = summons[i].m_units[0];
						
						if (oldestUnit is null)
						{
							@oldestUnit = candidateUnit;
							oldestGroupIndex = i;
						}
						else
						{
							// Compare creation time. 
							// Since IOwnedUnit doesn't expose it directly, we use Unit ID as a proxy for age (lower ID = older).
							// This works reliably within a single session as IDs increment.
							if (candidateUnit.GetUnit().GetId() < oldestUnit.GetUnit().GetId())
							{
								@oldestUnit = candidateUnit;
								oldestGroupIndex = i;
							}
						}
					}
					
					if (oldestUnit !is null && oldestGroupIndex != -1)
					{
						// Destroy the oldest unit found
						if (Network::IsServer())
							oldestUnit.Destroy();
						else
							(Network::Message("UnitDestroyed") << oldestUnit.GetUnit()).SendToHost();
						
						summons[oldestGroupIndex].m_units.removeAt(0);
						summons[oldestGroupIndex].m_weaponInfo.removeAt(0);
						summons[oldestGroupIndex].m_save.removeAt(0);
						summons[oldestGroupIndex].m_saveData.removeAt(0);
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

