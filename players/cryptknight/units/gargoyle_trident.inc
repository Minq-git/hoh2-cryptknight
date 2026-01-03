<unit netsync="none" layer="1">
	<behavior class="NewProjectile">
		<string name="anim">default</string>
		<float name="speed">9</float>
		<int name="ttl">900</int>
		<int name="penetration">3</int>
		
%if LIGHTNING
		<array name="modifiers">
			<dict>
				<string name="class">Projectile::PeriodicEffect</string>
				<int name="freq">150</int>
				
				<array name="effects">
					<dict>
						<string name="class">HitscanRandomEnemy</string>
						<int name="range">60</int>
						<string name="shoot-fx">effects/generic/raycast/lightning_beam_2.effect</string>
						<string name="hit-fx">effects/generic/impacts/lightning_impact_1.effect</string>
						<int name="penetrating">0</int>
						<bool name="ignore-target">true</bool>

						<array name="effects">
							<dict>
								<string name="intensity-mul-bind">lightning-dmg-mul</string>
							</dict>
							<dict>
								<string name="class">Damage</string>
								<string name="lightning-bind">gargoyle-dmg</string>
							</dict>
							<dict>
								<string name="class">PlaySound</string>
								<string name="sound">event:/sfx/player/classes/warlock/summon_gargoyle/gargoyle_trident_lightning</string>
							</dict>
						</array>
					</dict>
				</array>
			</dict>
		</array>
%endif

		<array name="hit-effects">
			<dict>
				<string name="class">Damage</string>
				<string name="physical-bind">gargoyle-dmg</string>
			</dict>
			<dict>
				<string name="class">SpawnEffect</string>
				<string name="effect">effects/generic/impacts/blunt_impact_1.effect</string>
			</dict>
			<dict>
				<string name="class">PlaySound</string>
				<string name="sound">event:/sfx/player/classes/warlock/summon_gargoyle/gargoyle_trident_hit</string>
			</dict>
		</array>

		<array name="destroyed-effects">
			<dict>
				<string name="class">SpawnEffect</string>
				<string name="effect">effects/generic/impacts/blunt_impact_1.effect</string>
			</dict>
			<dict>
				<string name="class">PlaySound</string>
				<string name="sound">event:/sfx/player/classes/warlock/summon_gargoyle/gargoyle_trident_hit</string>
			</dict>
		</array>

		<dict name="effect-params">
			<float name="height">10</float>
		</dict>
	</behavior>

	<scenes>
		<scene name="default">
%if LIGHTNING
			<effect src="./gargoyle_trident.effect?lightning=1" />
%else
			<effect src="./gargoyle_trident.effect" />
%endif
			<collision static="false">
				<circle projectile="true" radius="4" />
			</collision>		
		</scene>
	</scenes>
</unit>