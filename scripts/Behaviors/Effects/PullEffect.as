class PullEffect : IEffect
{
	float m_force;

	PullEffect(UnitPtr unit, SValue& params)
	{
		m_force = GetParamFloat(unit, params, "force", false, 100.0f);
	}

	bool Apply(Actor@ owner, UnitPtr target, vec2 pos, vec2 dir, float intensity, bool husk) override
	{
		if (!target.IsValid())
			return false;

		auto body = target.GetPhysicsBody();
		if (body is null)
			return false;

		// Apply force towards owner
		vec2 ownerPos = xy(owner.m_unit.GetPosition());
		vec2 targetPos = xy(target.GetPosition());
		vec2 pullDir = normalize(ownerPos - targetPos);

		// Apply impulse (assuming ApplyLinearImpulse exists, otherwise try SetLinearVelocity or similar)
		body.SetLinearVelocity(pullDir * m_force * intensity);
		
		return true;
	}

	bool CanApply(Actor@ owner, UnitPtr target, vec2 pos, vec2 dir, float intensity) override
	{
		return target.IsValid();
	}

	void SetWeaponInformation(uint weapon) {}
	CanEvade IsEvadable(Actor@ attacker) { return CanEvade::Unevadable; }
}
