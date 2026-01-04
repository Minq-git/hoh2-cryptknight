namespace Skills
{
	class DeathGripEvasionMod : Modifiers::Modifier
	{
		Skills::DeathGripHook@ m_grapple;

		DeathGripEvasionMod(Skills::DeathGripHook@ grapple)
		{
			@m_grapple = grapple;
		}

		Modifiers::ModDynamism HasEvasion() override { return Modifiers::ModDynamism::Dynamic; }
		bool Evasion(PlayerBase@ player, Actor@ enemy, float intensity) override { return m_grapple.m_durationC > 0; }
	}

	class DeathGripHook : ActiveSkill
	{
		EffectList@ m_effectList;
		EffectList@ m_hitEffects;

		int m_speed;
		int m_durationC;
		vec2 m_to;
		int m_range;
		
		int m_dustC;
		string m_dustFx;
		bool m_husk;
		UnitPtr m_hookedUnit;
		
		string m_hitFx;
		UnitScene@ m_chainFx;
		SoundEvent@ m_hitSnd;
		SoundEvent@ m_missSnd;

		array<Modifiers::IModifier@> m_mods;

		DeathGripHook(UnitPtr unit, SValue& params)
		{
			super(unit);
			m_mods.insertLast(DeathGripEvasionMod(this));
		}

		array<Modifiers::IModifier@>@ GetModifiers() override
		{
			return m_mods;
		}
		
		void Initialize(Actor@ owner, UnitPtr unit, array<SValue@>@ params, uint id) override
		{
			ActiveSkill::Initialize(owner, unit, params, id);
			
			@m_effectList = LoadEffects(unit, params);
			@m_hitEffects = LoadEffects(unit, params, "hit-");
			
			m_speed = GetParamInt(unit, params, "speed", false, 3);
			m_range = GetParamInt(unit, params, "range", false, 10);
			m_durationC = 0;
			
			m_dustFx = GetParamString(unit, params, "dust-fx", false);
			@m_chainFx = Resources::GetEffect(GetParamString(unit, params, "chain-fx", false));
			
			m_hitFx = GetParamString(unit, params, "hit-fx", false);
			@m_hitSnd = Resources::GetSoundEvent(GetParamString(unit, params, "hit-snd", false));
			@m_missSnd = Resources::GetSoundEvent(GetParamString(unit, params, "miss-snd", false));
			
			PropagateWeaponInformation(m_effectList, id);
			PropagateWeaponInformation(m_hitEffects, id);
			
			m_husk = false;
		}
		
		TargetingMode GetTargetingMode(TargetingParams@ params) override
		{
			return TargetingMode::Direction;
		}
		
		void MakeChain(vec2 from, vec2 to)
		{
			if (m_chainFx is null)
				return;
		
			int numChains = int(dist(from, to) / 4);
			vec2 d = normalize(to - from);
			
			for (int i = 1; i < numChains; i++)
			{
				auto u = PlayEffect(m_chainFx, from + d * 4 * i);
				auto fx = cast<EffectBehavior>(u.GetScriptBehavior());
				if (fx !is null)
					fx.m_ttl = int(i * 4.0f / m_speed * 33.0f);
			}
		}

		bool NeedNetParams() override { return true; }

		void DoActivate(SValueBuilder@ builder, vec2 target) override
		{
			auto from = xy(m_owner.m_unit.GetPosition());
			vec2 to = from + target * m_range;
			int toRadius = 0;
			UnitPtr hitUnit;
			bool hit = false;

			auto results = g_scene.Raycast(from, to, ~0, RaycastType::Shot);
			for (uint j = 0; j < results.length(); j++)
			{
				RaycastResult res = results[j];
				UnitPtr res_unit = res.FetchUnit(g_scene);
				
				auto actor = cast<Actor>(res_unit.GetScriptBehavior());
				if (actor !is null && actor.Team == m_owner.Team)
					continue;

				auto body = res_unit.GetPhysicsBody();
				if (body !is null)
					toRadius = body.GetEstimatedRadius();
				
				to = res.point;
				hitUnit = res_unit;
				hit = true;
				break;
			}

			builder.PushArray();
			builder.PushVector2(from);
			builder.PushVector2(to);
			builder.PushBoolean(hit);
			if (hitUnit.IsValid())
				builder.PushInteger(hitUnit.GetId());
			else
				builder.PushInteger(0);
			builder.PopArray();
			
			MakeChain(from, to);
		
			if (!hit)
			{
				PlaySound3D(m_missSnd, xyz(from));
				return;
			}
			
			PlaySound3D(m_hitSnd, xyz(from));
			if (hitUnit.IsValid())
			{
				ApplyEffects(m_effectList, m_owner, hitUnit, to, target, 1.0f, m_husk);
				
				// Pull logic init
				m_hookedUnit = hitUnit;
				float ds = dist(from, to) - (toRadius + 4);
				if (ds > 3.5f)
				{
					// Duration based on distance and speed
					m_durationC = int(ds / m_speed * 33.f);
					m_to = to;
					PlaySkillEffect(target);
					cast<PlayerBase>(m_owner).SetCharging(true);
				}
			}
		}
		
		void CancelCharge()
		{
			m_durationC = 0;
			m_hookedUnit = UnitPtr();
			cast<PlayerBase>(m_owner).SetCharging(false);
		}

		void NetDoActivate(SValue@ param, vec2 target) override
		{
			auto arr = param.GetArray();
			vec2 from = arr[0].GetVector2();
			vec2 to = arr[1].GetVector2();
			bool hasHit = arr[2].GetBoolean();
			int unitId = arr[3].GetInteger();
			UnitPtr hitUnit = g_scene.GetUnit(unitId);

			MakeChain(from, to);

			if (!hasHit)
			{
				PlaySound3D(m_missSnd, xyz(from));
				return;
			}

			PlaySound3D(m_hitSnd, xyz(from));

			if (hitUnit.IsValid())
			{
				m_hookedUnit = hitUnit;
				// Estimate duration from client side or trust visual sync
				float ds = dist(from, to); 
				m_durationC = int(ds / m_speed * 33.f);
				
				cast<PlayerBase>(m_owner).SetCharging(true);
				PlaySkillEffect(target);
			}
		}
		
		void OnCollide(UnitPtr unit, vec2 pos, vec2 normal, Fixture@ fxOther) override
		{
			// Collision logic for owner - maybe stop if we hit something?
			// For death grip, we usually stand still.
		}
		
		vec2 GetMoveDir(vec2 currMoveDir) override 
		{
			// Do NOT move the owner
			return vec2(); 
		}
		
		void DoUpdate(int dt) override
		{
			if (m_durationC <= 0)
				return;
		
			m_owner.SetUnitScene(m_animation, false);
			
			// Visuals
			m_dustC -= g_deltaTime;
			if (m_dustC <= 0)
			{
				m_dustC += randi(66) + 33;
				PlayEffect(m_dustFx, xy(m_owner.m_unit.GetPosition()));
			}
			
			// Pull Logic
			if (m_hookedUnit.IsValid())
			{
				vec2 ownerPos = xy(m_owner.m_unit.GetPosition());
				vec2 targetPos = xy(m_hookedUnit.GetPosition());
				float d = dist(ownerPos, targetPos);
				
				if (d <= 10.0f) // Close enough
				{
					CancelCharge();
					return;
				}

				auto body = m_hookedUnit.GetPhysicsBody();
				if (body !is null)
				{
					vec2 pullDir = normalize(ownerPos - targetPos);
					// Pull speed - make it fast
					float pullSpeed = float(m_speed) * 2.0f; // Multiplier to make it snappy
					
					// Override velocity directly
					body.SetLinearVelocity(pullDir * pullSpeed);
				}
				else
				{
					// If no body, can't pull
					CancelCharge();
					return;
				}
			}
			else
			{
				// Target died or lost
				CancelCharge();
				return;
			}
			
			m_durationC -= g_deltaTime;
			if (m_durationC <= 0)
				CancelCharge();
		}
	}
}

