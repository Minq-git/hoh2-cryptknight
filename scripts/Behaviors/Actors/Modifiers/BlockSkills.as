namespace Modifiers
{
	class BlockSkills : Modifier
	{
		array<uint> m_blockedSkillIds;
		array<PlayerSkillType> m_blockedSkillTypes;
		
		BlockSkills(UnitPtr unit, SValue& params)
		{
			// Load blocked skill IDs
			auto skillIds = GetParamArray(unit, params, "block-skill-ids", false);
			if (skillIds !is null)
			{
				for (uint i = 0; i < skillIds.length(); i++)
				{
					string skillId = skillIds[i].GetString();
					m_blockedSkillIds.insertLast(HashString(skillId));
				}
			}
			
			// Load blocked skill types
			auto skillTypes = GetParamArray(unit, params, "block-skill-types", false);
			if (skillTypes !is null)
			{
				for (uint i = 0; i < skillTypes.length(); i++)
				{
					string typeStr = skillTypes[i].GetString();
					PlayerSkillType type = PlayerSkillType::MainHand;
					if (typeStr == "spell")
						type = PlayerSkillType::Spell;
					else if (typeStr == "dash")
						type = PlayerSkillType::Dash;
					else if (typeStr == "mod")
						type = PlayerSkillType::Mod;
					else if (typeStr == "combo")
						type = PlayerSkillType::Combo;
					else if (typeStr == "melee" || typeStr == "mainhand")
						type = PlayerSkillType::MainHand;
					else if (typeStr == "offhand")
						type = PlayerSkillType::OffHand;
					m_blockedSkillTypes.insertLast(type);
				}
			}
		}
		
		// This modifier doesn't modify stats, it's just a marker
		// The actual blocking will be done via hooks
	}
}

