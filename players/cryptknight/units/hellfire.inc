<unit layer="0">
	<behavior class="BombBehavior">
		<int name="delay">900</int>

		<array name="actions">
			<dict>
				<string name="class">Explode</string>
				<string name="fx">effects/generic/explosions/explosion_fire_3.effect?radius=24</string>
				<int name="radius">24</int>
				<int name="min-radius">8</int>
				<float name="dist-scaling">1000</float>

				<array name="effects">
					<dict>
						<string name="class">Damage</string>
						<int name="fire">FIRE_DMG</int>
						<!-- <string name="fire-bind">hellfire-dmg</string> -->
					</dict>
				</array>
			</dict>
			
			<dict>
				<string name="class">PlaySound</string>
				<string name="sound">event:/SFX/Character/Classes/warlock/demonic_possession/demonic_possessoin_hellfire_impact</string>
			</dict>
		</array>
	</behavior>
	
	<scenes>
		<scene>
			<effect src="players/warlock/effects/hellfire.effect" />
		</scene>
	</scenes>
</unit>