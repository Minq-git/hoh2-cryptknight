namespace Modifiers
{
	class SetStackMax : Modifier
	{
		ActorBuffStackDef@ m_buff;
		string m_buffName;
		string m_maxBind;
		
		SetStackMax(UnitPtr unit, SValue& params)
		{
			m_buffName = GetParamString(unit, params, "buff");
			@m_buff = ActorBuffStackDef::Get(m_buffName);
			m_maxBind = GetParamString(unit, params, "max-bind", false, "");
		}
		
		ModDynamism HasModifyStacks() override { return ModDynamism::Dynamic; }
		void ModifyStacks(PlayerBase@ player, float intensity) override
		{
			if (m_buff is null)
			{
				@m_buff = ActorBuffStackDef::Get(m_buffName);
				if (m_buff is null)
				{
					PrintError("[SetStackMax] ERROR: Failed to load buff: " + m_buffName);
					return;
				}
			}
			
			int maxStacks = 0;
			
			// Get from bone_shield skill level and map to max stacks
			auto@ boneShieldDef = player.m_record.playerClass.GetSkillDef(HashString("bone_shield"));
			if (boneShieldDef !is null)
			{
				uint skillLevel = player.m_record.GetSkillLevel(boneShieldDef);
				
				// Map skill level to max stacks: 1->3, 2->3, 3->5, 4->5, 5->7
				if (skillLevel <= 2)
					maxStacks = 3;
				else if (skillLevel <= 4)
					maxStacks = 5;
				else
					maxStacks = 7;
			}
			else
			{
				maxStacks = 3;
			}
			
			if (maxStacks <= 0)
				maxStacks = 3;
			
			auto mod = player.m_record.GetModifiedStack(m_buff, true);
			if (mod is null)
				return;
			
			mod.m_maxStacks = maxStacks;
			
			// Also enforce the cap on existing stacks if they exceed the new max
			auto actor = cast<Actor>(player);
			if (actor !is null)
			{
				auto buffList = actor.GetBuffList();
				if (buffList !is null)
				{
					for (uint i = 0; i < buffList.m_stacks.length(); i++)
					{
						auto stack = buffList.m_stacks[i];
						if (stack.m_def is m_buff)
						{
							if (stack.m_stacks > maxStacks)
								stack.m_stacks = maxStacks;
							break;
						}
					}
				}
			}
		}
	}
}

