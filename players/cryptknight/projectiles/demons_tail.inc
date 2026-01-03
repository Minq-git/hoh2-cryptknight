<unit netsync="none">
	<behavior class="NewProjectile">
		<string name="anim">default</string>
		<float name="speed">12</float>
		<int name="ttl">500</int>
		<int name="penetration">999</int>
		<int name="bounces">0</int>
		<bool name="bounce-on-collide">false</bool>
%if LIGHTNING
		<string name="destroyed-fx">players/warlock/effects/demon_tail_back.effect?lightning=1</string>
%elif FIRE
		<string name="destroyed-fx">players/warlock/effects/demon_tail_back.effect</string>
%else
		<string name="destroyed-fx">players/warlock/effects/demon_tail_back.effect</string>
%endif
<!-- 		<int name="ray-num">3</int>
		<int name="ray-width">12</int> -->

		<array name="modifiers">
			<dict>
				<string name="class">Projectile::GroundBouncing</string>
				<int name="period">500</int>
				<int name="height">0</int>
				<bool name="hit-target">true</bool>
				<int name="bounces">0</int>
			</dict>
			<dict>
				<string name="class">Projectile::Speed</string>
				<float name="bounce-speed-mul">0</float>
			</dict>
			<dict>
				<string name="class">Projectile::TimeToLive</string>
				<float name="bounce-ttl-mul">0</float>
			</dict>

%if LIGHTNING
			<dict>
				<string name="class">Projectile::PeriodicEffect</string>
				<int name="freq">50</int>
				
				<array name="effects">
<!-- 					<dict>
						<string name="class">ShootProjectileFan</string>
						<string name="projectile">players/warlock/projectiles/demons_tail_lash_lightning.unit</string>
						<int name="projectiles">2</int>
						<int name="spread">180</int>
					</dict> -->

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
								<!-- <string name="lightning-bind">lightning-dmg</string> -->
								<string name="lightning-bind">whip-dmg</string>
							</dict>
							<dict>
								<string name="class">PlaySound</string>
								<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_crackling_lash</string>
							</dict>
						</array>
					</dict>
				</array>
			</dict>
%elif FIRE
 			<dict>
				<string name="class">Projectile::Lurker</string>
				<string name="fx">players/warlock/projectiles/demons_tail_lash_fire.effect</string>
				<int name="freq">32</int>
				<float name="spread">0</float>
			</dict>
			<dict>
				<string name="class">Projectile::PeriodicEffect</string>
				<int name="freq">32</int>
				
				<array name="effects">
					<dict>
						<string name="class">SpawnUnit</string>
						<string name="unit">players/warlock/projectiles/demons_tail_lash_fire.unit</string>
					</dict>
					<dict>
						<string name="class">PlaySound</string>
						<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_fiery_lash</string>
					</dict>
				</array>
			</dict>
%endif
		</array>

		<array name="hit-effects">
			<dict>
				<string name="class">Damage</string>
				<string name="physical-bind">whip-dmg</string>
				<bool name="shield-blockable">true</bool>
			</dict>
			<dict>
				<string name="class">ApplyBuff</string>
				<string name="buff">tweak/buffs/status_effects.sval:slow</string>
			</dict>
			<dict>
				<string name="class">SpawnEffect</string>
				<string name="effect">effects/generic/impacts/impact_blunt_2.effect</string>
			</dict>
			<dict>
				<string name="class">PlaySound</string>
%if LIGHTNING
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_impact</string>
%elif FIRE
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_impact</string>
%else
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_impact</string>
%endif
			</dict>
		</array>

		<array name="destroyed-effects">
<!-- 			<dict>
				<vec2 name="pos-rotated">32 0</vec2>
			</dict> -->
			<dict>
				<string name="class">PlaySound</string>
%if LIGHTNING
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_crackling_impact</string>
%elif FIRE
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_fiery_impact</string>
%else
				<string name="sound">event:/sfx/player/classes/warlock/demons_tail/demons_tail_impact</string>
%endif
			</dict>
			<dict>
				<string name="class">SpawnEffect</string>
				<string name="effect">players/warlock/effects/demon_tail_impact.effect?radius=32</string>
			</dict>
			<dict>
				<string name="class">Explode</string>
				<int name="radius">28</int>
				<int name="min-radius">6</int>
				<float name="dist-scaling">1000</float>
				
				<array name="effects">
					<dict>
						<float name="self-dmg">0</float>
						<float name="team-dmg">0</float>
						<float name="enemy-dmg">1</float>
					</dict>
					<dict>
						<string name="class">Damage</string>
						<string name="physical-bind">whip-dmg</string>
						<bool name="shield-blockable">true</bool>
					</dict>
					<dict>
						<string name="class">ApplyBuff</string>
						<string name="buff">tweak/buffs/status_effects.sval:slow</string>
					</dict>
					<dict>
						<string name="class">ApplyBuff</string>
						<string name="buff-bind">buff-stun</string>
					</dict>
				</array>
			</dict>
		</array>

		<dict name="effect-params">
		
		</dict>
	</behavior>

	<scenes start="default">
		<scene name="default">
			<collision static="false">
				<circle radius="16" projectile="true" />
			</collision>
%if LIGHTNING
				<effect src="players/warlock/effects/demon_tail_out.effect?lightning=1" />
%elif FIRE
				<effect src="players/warlock/effects/demon_tail_out.effect?fire=1" />
%else
				<effect src="players/warlock/effects/demon_tail_out.effect" />
%endif
		</scene>
	</scenes>
</unit>