namespace Modifiers
{
	// Dummy modifier - actual pass-through logic is handled via hooks in CryptKnightHooks.as
	// This modifier exists so the buff definition can reference it
	class PassThroughEnemies : Modifier
	{
		PassThroughEnemies() { }
		PassThroughEnemies(UnitPtr unit, SValue& params)
		{
			// No parameters needed
		}

		Modifier@ Instance() override
		{
			auto ret = PassThroughEnemies();
			ret = this;
			ret.m_cloned++;
			return ret;
		}
	}
}

