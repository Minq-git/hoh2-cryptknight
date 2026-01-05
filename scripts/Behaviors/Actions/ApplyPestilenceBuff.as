// Custom action: Applies pestilence buff with duration based on skill level
// Base duration: 6 seconds (6000ms)
// Increase per level: 4 seconds (4000ms)
// Level 1: 6s, Level 2: 10s, Level 3: 14s, Level 4: 18s, Level 5: 22s
class ApplyPestilenceBuff : IAction
{
	ActorBuffDef@ m_buff;
	bool m_targetSelf;
	
	ApplyPestilenceBuff(UnitPtr unit, SValue& params)
	{
		string buffName = GetParamString(unit, params, "buff", false, "players/cryptknight/buffs/skills_buffs.sval:pestilence_buff");
		@m_buff = LoadActorBuff(buffName);
		m_targetSelf = GetParamBool(unit, params, "target-self", false, true);
	}
	
	void Update(int dt, int cooldown) {}
	void CancelAction() {}
	bool NeedNetParams() { return false; }
	void SetWeaponInformation(uint weapon) {}
	
	bool DoAction(SValueBuilder@ builder, Actor@ owner, Actor@ target, vec2 pos, vec2 dir, float intensity)
	{
		if (m_buff is null)
			return false;
		
		Player@ player = cast<Player>(owner);
		if (player is null)
			return false;
		
		// Get the pestilence skill level
		uint skillLevel = 1;
		if (player.m_record.pickedSkills.exists("pestilence"))
			skillLevel = uint(player.m_record.pickedSkills["pestilence"]);
		
		// Calculate duration: base 6 seconds + 4 seconds per level above 1
		// Level 1: 6000ms, Level 2: 10000ms, Level 3: 14000ms, Level 4: 18000ms, Level 5: 22000ms
		int duration = 6000 + int(skillLevel - 1) * 4000;
		
		// Get the target actor
		Actor@ targetActor = null;
		if (m_targetSelf)
			@targetActor = owner;
		else if (target !is null)
			@targetActor = target;
		
		if (targetActor is null)
			return false;
		
		// Temporarily modify the buff definition's duration
		int originalDuration = m_buff.m_duration;
		m_buff.m_duration = duration;
		
		// Create and apply the buff
		auto buff = ActorBuff(owner, m_buff, 1.0f, false);
		buff.m_duration = duration; // Also set instance duration explicitly
		
		bool result = targetActor.ApplyBuff(buff);
		
		// Restore original duration
		m_buff.m_duration = originalDuration;
		
		// Ensure the buff instance has the correct duration after application
		auto buffList = targetActor.GetBuffList();
		if (buffList !is null)
		{
			uint buffHash = m_buff.m_pathHash;
			for (uint i = 0; i < buffList.m_buffs.length(); i++)
			{
				if (buffList.m_buffs[i].m_def.m_pathHash == buffHash)
				{
					buffList.m_buffs[i].m_duration = duration;
					break;
				}
			}
		}
		
		return result;
	}
	
	bool NetDoAction(SValue@ param, Actor@ owner, vec2 pos, vec2 dir)
	{
		// For network, use default duration (will be corrected by DoAction on host)
		if (m_buff is null)
			return false;
		
		Player@ player = cast<Player>(owner);
		if (player is null)
			return false;
		
		uint skillLevel = 1;
		if (player.m_record.pickedSkills.exists("pestilence"))
			skillLevel = uint(player.m_record.pickedSkills["pestilence"]);
		
		int duration = 6000 + int(skillLevel - 1) * 4000;
		
		int originalDuration = m_buff.m_duration;
		m_buff.m_duration = duration;
		
		auto buff = ActorBuff(owner, m_buff, 1.0f, false);
		buff.m_duration = duration;
		
		bool result = owner.ApplyBuff(buff);
		
		m_buff.m_duration = originalDuration;
		
		// Ensure the buff instance has the correct duration
		auto buffList = owner.GetBuffList();
		if (buffList !is null)
		{
			uint buffHash = m_buff.m_pathHash;
			for (uint i = 0; i < buffList.m_buffs.length(); i++)
			{
				if (buffList.m_buffs[i].m_def.m_pathHash == buffHash)
				{
					buffList.m_buffs[i].m_duration = duration;
					break;
				}
			}
		}
		
		return result;
	}
}

