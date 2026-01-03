<unit netsync="none">
	<behavior class="NewProjectile">
		<string name="anim">default</string>
		<!-- <int name="ttl">10000</int> -->
		<string name="ttl-bind">vortex-ttl</string>
		<float name="speed">5</float>

		<int name="penetration">999</int>
		<!-- <bool name="penetrate-all">true</bool> -->
		<int name="bounces">999</int>
		<bool name="bounce-on-collide">false</bool>

		<array name="modifiers">
			<dict>
				<string name="class">Projectile::Speed</string>
				<float name="bounce-speed-mul">0</float>
			</dict>

			<dict>
				<string name="class">Projectile::GroundBouncing</string>
				<int name="period">1500</int>
				<int name="height">0</int>
				
				<bool name="hit-target">true</bool>
				
				<float name="speed-mul">0</float>
				<float name="height-mul">1</float>
				<float name="period-mul">1</float>
				
				<int name="bounces">100</int>
			</dict>

%if LIGHTNING
			<dict>
				<string name="class">Projectile::AttachedLoopingSound</string>
				<string name="sound">event:/SFX/Character/Classes/warlock/vortex_of_souls/vortex_of_souls_loop_lightning</string>
			</dict>
%else
			<dict>
				<string name="class">Projectile::AttachedLoopingSound</string>
				<string name="sound">event:/SFX/Character/Classes/warlock/vortex_of_souls/vortex_of_souls_loop</string>
			</dict>
%endif

<!-- 			<dict>
				<string name="class">Projectile::Speed</string>
				<float name="speed-delta">-6</float>
			</dict> -->

			<dict>
				<string name="class">Projectile::PeriodicEffect</string>
				<int name="freq">250</int>
				
				<array name="effects">
					<dict>
						<float name="self-dmg">0</float>
						<float name="team-dmg">0</float>
						<float name="enemy-dmg">1</float>
					</dict>
					<dict>
						<string name="class">Explode</string>
						<int name="radius">48</int>
						<float name="dist-scaling">1000</float>
						<array name="effects">
							<dict>
								<string name="class">PlayerDamage</string>
								<bool name="off-hand">false</bool>
								<string name="mul-bind">vortex-dmg</string>
							</dict>
						</array>
					</dict>

%if LIGHTNING
					<dict>
						<string name="class">SpawnUnit</string>
						<string name="unit">players/warlock/units/soul_vortex_lightning_bolt.unit</string>
						<float name="jitter">16 16</float>
					</dict>

<!-- 					<dict>
						<string name="class">HitscanRandomEnemy</string>
						<int name="range">90</int>
						<string name="shoot-fx">effects/generic/beams/lightning_bolt_2.effect</string>
						<bool name="ignore-target">true</bool>

						<array name="effects">
							<dict>
								<string name="class">Damage</string>
								<int name="lightning">10</int>
							</dict>
						</array>
					</dict> -->
%endif
				</array>
			</dict>
		</array>
	</behavior>

	<scenes start="default">
		<scene name="default">
			<collision static="false">
				<circle radius="10" projectile="true" />
			</collision>

			<effect src="players/warlock/effects/soul_vortex.effect" />
		</scene>
	</scenes>
</unit>