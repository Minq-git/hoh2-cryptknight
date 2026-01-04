namespace CryptKnight
{
	[Hook]
	void PlayerRefreshScene(PlayerBase@ player)
	{
		Actor@ actor = cast<Actor>(player);
		if (actor is null) return;

		auto buffList = actor.GetBuffList();
		if (buffList is null) return;

		// Hash of the buff ID "players/cryptknight/stacks_cryptknight_boneshield.sval:bone_shield"
		uint buffHash = HashString("players/cryptknight/stacks_cryptknight_boneshield.sval:bone_shield");

		for (uint i = 0; i < buffList.m_stacks.length(); i++)
		{
			auto stack = buffList.m_stacks[i];
			if (stack.m_def.m_idHash == buffHash)
			{
				if (stack.m_effect !is null)
				{
					stack.m_effect.SetParam("real_stacks", float(stack.m_stacks));
				}
				return;
			}
		}
	}
}
