<unit layer="-10">
	<behavior class="DangerAreaRitualBehaviorP">
		<int name="freq">500</int>
		<int name="ttl">3000</int>
		<int name="cancel-radius">80</int>

		<string name="ritual-cancel-fx">players/warlock/effects/war_ritual_cancel.effect</string>
%if FIRE
		<string name="ritual-end-fx">players/warlock/effects/war_ritual_end.effect?conflagration=1</string>
		<string name="start-snd">event:/sfx/player/classes/warlock/dark_ritual/dark_ritual_fire</string>
%else
		<string name="ritual-end-fx">players/warlock/effects/war_ritual_end.effect</string>
		<string name="start-snd">event:/sfx/player/classes/warlock/dark_ritual/dark_ritual</string>
%endif
		
		<array name="effects">
			<dict>
				<float name="enemy-dmg">1</float>
				<bool name="only-actors">true</bool>
			</dict>
%if FIRE
			<dict>
				<string name="class">Damage</string>
				<string name="fire-bind">area-dmg</string>
			</dict>
%else
			<dict>
				<string name="class">Damage</string>
				<string name="physical-bind">area-dmg</string>
			</dict>
%endif
			<dict>
				<string name="class">AddStacks</string>
				<string name="buff">tweak/buffs/stacks_actors.sval:bleeding</string>
				<string name="stacks-bind">bleeding-stacks</string>
				<string name="chance-bind">bleeding-chance</string>
			</dict>
			<dict>
				<float name="self-dmg">1</float>
				<float name="team-dmg">1</float>
				<float name="enemy-dmg">0</float>
				<bool name="only-actors">true</bool>
			</dict>
			<dict>
				<string name="class">ApplyBuff</string>
				<string name="buff-bind">area-buff-leech</string>
			</dict>
		</array>

		<array name="ritual-effects">
			<dict>
				<string name="class">PlaySound</string>
%if FIRE
				<string name="sound">event:/sfx/player/classes/warlock/dark_ritual/dark_ritual_fire_explode</string>
%else
				<string name="sound">event:/sfx/player/classes/warlock/dark_ritual/dark_ritual_explode</string>
%endif
			</dict>
			<dict>
				<string name="class">Explode</string>
				<int name="radius">80</int>
				<float name="dist-scaling">1000</float>
				<bool name="split-effect-intensity">false</bool>

				<array name="effects">
%if FIRE
					<dict>
						<string name="intensity-mul-bind">area-fire-end-dmg-mul</string>
					</dict>
					<dict>
						<string name="class">Damage</string>
						<string name="fire-bind">area-dmg</string>
					</dict>
%else
					<dict>
						<string name="intensity-mul-bind">area-end-dmg-mul</string>
					</dict>
					<dict>
						<string name="class">Damage</string>
						<string name="physical-bind">area-dmg</string>
					</dict>
%endif
				</array>
			</dict>
		</array>

		<dict name="effect-params">
			<float name="radius">70</float>
		</dict>
	</behavior>
	
	<scenes default="default">
		<scene name="default">
			<collision static="true">
				<circle sensor="true" aim-through="true" shoot-through="true" radius="80"/>
			</collision>
%if FIRE
			<effect src="players/warlock/effects/war_ritual.effect?conflagration=1" />
%else
			<effect src="players/warlock/effects/war_ritual.effect" />
%endif
		</scene>
	</scenes>
</unit>