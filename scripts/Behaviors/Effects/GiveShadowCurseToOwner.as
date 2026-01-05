// Custom effect: Gives shadow curse to the owner (caster) when projectile hits an enemy
class GiveShadowCurseToOwner : IEffect
{
	vec2 m_num;
	SoundEvent@ m_snd;
	string m_fx;
	int m_ngpLimit;

	GiveShadowCurseToOwner(UnitPtr unit, SValue& params)
	{
		m_num = GetParamVec2(unit, params, "num", false);
		@m_snd = Resources::GetSoundEvent(GetParamString(unit, params, "snd", false, "event:/sfx/player/shadow_curse"));
		m_fx = GetParamString(unit, params, "fx", false, "effects/generic/actor/gain_shadowcurse.effect");
		m_ngpLimit = GetParamInt(unit, params, "ngp", false, 1);
	}

	CanEvade IsEvadable(Actor@ attacker) { return CanEvade::Neither; }
	void SetWeaponInformation(uint weapon) {}

	bool Apply(Actor@ owner, UnitPtr target, vec2 pos, vec2 dir, float intensity, bool husk)
	{
		// Give shadow curse to the owner (the player who cast the ability)
		// This is called when the projectile hits an enemy
		if (owner is null)
			return false;
		
		Player@ plr = cast<Player>(owner);
		if (plr is null)
			return false;
		
		if (int(g_ngp + 0.5f) >= m_ngpLimit)
		{
			if (plr.m_record.GiveShadowCurse(owner, Modifiers::lerp(m_num, intensity)) > 0)
			{
				if (!husk)
					PlaySound2D(m_snd);
				PlayEffect(m_fx, owner.m_unit);
			}
		}
		
		return true;
	}

	bool CanApply(Actor@ owner, UnitPtr target, vec2 pos, vec2 dir, float intensity) override
	{
		// Only apply if owner is a player
		if (owner is null)
			return false;
		
		Player@ plr = cast<Player>(owner);
		if (plr is null)
			return false;
		
		return true;
	}
}

