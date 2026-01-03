<unit netsync="none">
	<behavior class="NewProjectile">
		<string name="anim">default</string>
		<int name="ttl">450</int>
		<float name="speed">12</float>
		<int name="penetration">999</int>
		<int name="bounces">0</int>
		<bool name="bounce-on-collide">false</bool>
		<string name="destroyed-fx">players/cryptknight/effects/death_grip_chain_back.effect</string>

		<array name="modifiers">
			<dict>
				<string name="class">Projectile::GroundBouncing</string>
				<int name="period">450</int>
				<int name="height">2</int>
				<int name="bounces">1</int>
				<float name="speed-mul">0</float>
				<float name="height-mul">0</float>
				<float name="period-mul">0</float>
				<bool name="hit-target">false</bool>
			</dict>

			<dict>
				<string name="class">Projectile::Speed</string>
				<float name="hit-speed-mul">0.9</float>
				<float name="hit-intensity-mul">0.9</float>
			</dict>
		</array>

		<array name="hit-effects">
			<dict>
				<string name="class">PlaySound</string>
				<string name="sound">event:/sfx/player/classes/warrior/chain/chain_hit</string>
			</dict>
			<dict>
				<string name="class">Damage</string>
				<string name="physical-bind">chains-dmg</string>
				<bool name="shield-blockable">true</bool>
			</dict>
			<dict>
				<string name="class">ApplyBuff</string>
				<string name="buff">players/cryptknight/buffs/skills_buffs.sval:pull_effect</string>
			</dict>
			
			<!-- Pull Effect: Negative Knockback -->
			<dict>
				<string name="class">Knockback</string>
				<int name="strength">-300</int> 
				<!-- <int name="duration">300</int> -->
			</dict>
		</array>
		
		<array name="destroyed-effects">
			<dict>
				<string name="class">Explode</string>
				<int name="radius">24</int>
				<float name="dist-scaling">1000</float>
				<array name="effects">
					<dict>
						<string name="class">ApplyBuff</string>
						<string name="buff">players/cryptknight/buffs/skills_buffs.sval:pull_effect</string>
					</dict>
					<dict>
						<string name="class">Knockback</string>
						<int name="strength">-300</int>
					</dict>
				</array>
			</dict>
		</array>

		<dict name="effect-params">
			<float name="height">2</float>
		</dict>
	</behavior>
	
	<scenes>
		<scene name="default">
			<collision static="false">
				<circle projectile="true" radius="8"/>
			</collision>
			<effect src="players/cryptknight/effects/death_grip_chain.effect"/>
		</scene>
	</scenes>
</unit>
