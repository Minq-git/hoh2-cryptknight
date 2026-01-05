namespace Modifiers
{
	class CountSummons : Modifier
	{
		array<UnitProducer@> m_producers;
		string m_buffId;
		uint m_stackIdHash;
		ActorBuffStackDef@ m_stackDef;

		CountSummons(UnitPtr unit, SValue& params)
		{
			m_buffId = GetParamString(unit, params, "buff", false);
			@m_stackDef = ActorBuffStackDef::Get(m_buffId);
			if (m_stackDef !is null)
				m_stackIdHash = m_stackDef.m_idHash;
			
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
			// Validate player is valid
			if (player is null || player.m_record is null)
				return;
			
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
						auto unit = summons[i].m_units[k];
						if (unit !is null && !unit.GetUnit().IsDestroyed())
						{
							// Verify ownership - critical for multiplayer
							auto ownedUnit = cast<IOwnedUnit>(unit);
							if (ownedUnit !is null && ownedUnit.GetOwner() is player)
								count++;
						}
					}
				}
			}
			
			auto buffList = player.m_record.actor.GetBuffList();
			if (buffList is null)
				return;

			if (m_stackDef is null)
				return;
			
			// Find our buff stack by ID hash
			for (uint i = 0; i < buffList.m_stacks.length(); i++)
			{
				auto stack = buffList.m_stacks[i];
				if (stack.m_def.m_idHash == m_stackIdHash)
				{
					if (stack.m_stacks != count)
					{
						int diff = count - stack.m_stacks;
						stack.AddStacks(player.m_record.actor, diff);
					}
					return;
				}
			}
			
			// If we have count > 0 but no buff, apply it using AddStacks
			if (count > 0)
			{
				player.m_record.actor.AddStacks(player.m_record.actor, m_stackDef, count, 0);
			}
		}
	}
}

