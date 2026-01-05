// Custom action: Gives shadow curse to the player when a skill is cast
class GiveShadowCurseToSelf : IAction
{
	vec2 m_num;
	SoundEvent@ m_snd;
	string m_fx;
	int m_ngpLimit;

	GiveShadowCurseToSelf(UnitPtr unit, SValue& params)
	{
		m_num = GetParamVec2(unit, params, "num", false);
		@m_snd = Resources::GetSoundEvent(GetParamString(unit, params, "snd", false, "event:/sfx/player/shadow_curse"));
		m_fx = GetParamString(unit, params, "fx", false, "effects/generic/actor/gain_shadowcurse.effect");
		m_ngpLimit = GetParamInt(unit, params, "ngp", false, 1);
	}

	void Update(int dt, int cooldown) {}
	void CancelAction() {}
	bool NeedNetParams() { return false; }
	void SetWeaponInformation(uint weapon) {}

	bool DoAction(SValueBuilder@ builder, Actor@ owner, Actor@ target, vec2 pos, vec2 dir, float intensity)
	{
		PrintError("[GiveShadowCurseToSelf] DoAction called");
		
		// Give shadow curse to the owner (the player who cast the ability)
		if (owner is null)
		{
			PrintError("[GiveShadowCurseToSelf] owner is null");
			return false;
		}
		
		Player@ plr = cast<Player>(owner);
		if (plr is null)
		{
			PrintError("[GiveShadowCurseToSelf] owner is not a Player");
			return false;
		}
		
		PrintError("[GiveShadowCurseToSelf] Player found, NGP: " + int(g_ngp + 0.5f) + ", limit: " + m_ngpLimit);
		PrintError("[GiveShadowCurseToSelf] Current shadow curse: " + plr.m_record.shadowCurses);
		PrintError("[GiveShadowCurseToSelf] m_num vec2: (" + m_num.x + ", " + m_num.y + "), intensity: " + intensity);
		
		if (int(g_ngp + 0.5f) >= m_ngpLimit)
		{
			float shadowCurseAmount = Modifiers::lerp(m_num, intensity);
			PrintError("[GiveShadowCurseToSelf] Attempting to give " + shadowCurseAmount + " shadow curse");
			
			// Pass null as curser to avoid the "same curser" check that blocks repeated applications
			// Use skipGainMod=true to bypass scaling and give exactly the amount we want
			int result = plr.m_record.GiveShadowCurse(null, shadowCurseAmount, true);
			PrintError("[GiveShadowCurseToSelf] GiveShadowCurse returned " + result + ", new shadow curse: " + plr.m_record.shadowCurses);
			
			if (result > 0)
			{
				PrintError("[GiveShadowCurseToSelf] Successfully gave shadow curse, playing sound and effect");
				PlaySound2D(m_snd);
				PlayEffect(m_fx, owner.m_unit);
			}
			else
			{
				PrintError("[GiveShadowCurseToSelf] GiveShadowCurse returned 0 or negative");
			}
		}
		else
		{
			PrintError("[GiveShadowCurseToSelf] NGP check failed (" + int(g_ngp + 0.5f) + " < " + m_ngpLimit + ")");
		}
		
		return true;
	}

	bool NetDoAction(SValue@ param, Actor@ owner, vec2 pos, vec2 dir)
	{
		PrintError("[GiveShadowCurseToSelf] NetDoAction called");
		
		// Give shadow curse to the owner (the player who cast the ability)
		if (owner is null)
		{
			PrintError("[GiveShadowCurseToSelf] NetDoAction: owner is null");
			return false;
		}
		
		Player@ plr = cast<Player>(owner);
		if (plr is null)
		{
			PrintError("[GiveShadowCurseToSelf] NetDoAction: owner is not a Player");
			return false;
		}
		
		if (int(g_ngp + 0.5f) >= m_ngpLimit)
		{
			float shadowCurseAmount = Modifiers::lerp(m_num, 1.0f);
			PrintError("[GiveShadowCurseToSelf] NetDoAction: Attempting to give " + shadowCurseAmount + " shadow curse");
			
			// Pass null as curser to avoid the "same curser" check that blocks repeated applications
			// Use skipGainMod=true to bypass scaling and give exactly the amount we want
			int result = plr.m_record.GiveShadowCurse(null, shadowCurseAmount, true);
			PrintError("[GiveShadowCurseToSelf] NetDoAction: GiveShadowCurse returned " + result);
			
			if (result > 0)
			{
				PrintError("[GiveShadowCurseToSelf] NetDoAction: Successfully gave shadow curse");
				PlaySound2D(m_snd);
				PlayEffect(m_fx, owner.m_unit);
			}
		}
		
		return true;
	}
}

