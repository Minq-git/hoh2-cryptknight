namespace Modifiers
{
	class CountSummons : Modifier
	{
		array<UnitProducer@> m_producers;
		string m_buffId;
		uint m_buffHash;

		CountSummons(UnitPtr unit, SValue& params)
		{
			m_buffId = GetParamString(unit, params, "buff", false);
			m_buffHash = HashString(m_buffId);
			
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
			int count = 0;
			auto@ summons = player.m_record.summons;
			
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
							count++;
					}
				}
			}
			
			auto buffList = player.m_record.actor.GetBuffList();
			if (buffList is null)
				return;

			// Find our buff stack
			for (uint i = 0; i < buffList.m_stacks.length(); i++)
			{
				auto stack = buffList.m_stacks[i];
				if (stack.m_def.m_buffDef.m_pathHash == m_buffHash)
				{
					if (stack.m_stacks != count)
					{
						int diff = count - stack.m_stacks;
						stack.AddStacks(player.m_record.actor, diff);
					}
					return;
				}
			}
			
			// If we have count > 0 but no buff, apply it
			if (count > 0)
			{
				player.m_record.actor.ApplyBuff(ActorBuff(player.m_record.actor, LoadActorBuff(m_buffId), 1.0f, false));
				
				// Re-find to set stacks
				@buffList = player.m_record.actor.GetBuffList();
				if (buffList !is null)
				{
					for (uint i = 0; i < buffList.m_stacks.length(); i++)
					{
						auto stack = buffList.m_stacks[i];
						if (stack.m_def.m_buffDef.m_pathHash == m_buffHash)
						{
							if (stack.m_stacks < count)
								stack.AddStacks(player.m_record.actor, count - stack.m_stacks);
							break;
						}
					}
				}
			}
		}
	}
}

