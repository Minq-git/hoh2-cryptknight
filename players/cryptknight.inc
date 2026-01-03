%defblock SharedStats
	<int name="base-str">10</int>
	<int name="base-dex">5</int>
	<int name="base-int">3</int>
	<int name="base-foc">5</int>
	<int name="base-vit">10</int>
	
	<int name="level-str">2</int>
	<int name="level-dex">1</int>
	<int name="level-int">0</int>
	<int name="level-foc">1</int>
	<int name="level-vit">2</int>
	
	<int name="int-spellpwr">0</int>
	<int name="str-spellpwr">1</int>
	
	<int name="base-health">100</int>
	<int name="base-mana">60</int>
	<int name="level-health">10</int>
	<int name="level-mana">2</int>
	
	<float name="base-health-regen">1.5</float>
	<float name="base-mana-regen">0.5</float>
	<float name="level-health-regen">0.1</float>
	<float name="level-mana-regen">0.05</float>
	
	<int name="base-armor">5</int>
	<int name="base-fire-res">0</int>
	<int name="base-ice-res">10</int>
	<int name="base-lightning-res">0</int>
	<int name="base-poison-res">10</int>
	
	<float name="level-armor">0.5</float>
	<float name="level-fire-res">0</float>
	<float name="level-ice-res">0.5</float>
	<float name="level-lightning-res">0</float>
	<float name="level-poison-res">0.5</float>
	
	<string name="panel-style">warrior</string>
	<string name="panel-color-tint">#303030ff</string>
	<string name="portrait-class">paladin</string>
	<string name="title">Crypt Knight</string>

	<array name="waypoint">
		<string>gui/icons.png</string>
		<int>100</int><vec4>208 242 14 14</vec4>
	</array>

	<array name="starting-equipment">
		<string>chest_plate_t1</string>
		<string>feet_plate_t1</string>
		<string>twohanded_maul_01</string>
	</array>
%endblock

%defblock cryptknight
<dict>
	<string name="id">cryptknight</string>
	<string name="name">Crypt Knight</string>
	<string name="description">An undead knight raised to serve again.</string>

	<array name="icon">
		<string>players/class_showcase.png</string>
		<int>100</int><vec4>0 32 32 32</vec4>
	</array>

	<array name="skills">
		<string>players/attacks/dash.sval</string>

		<string>players/cryptknight/skills/death_grip.sval</string>
		<string>players/cryptknight/skills/bone_shield.sval</string>
		
		<string>players/cryptknight/skills/raise_dead.sval</string>
	</array>

	%block SharedStats
</dict>

<dict>
	<string name="parent">cryptknight</string>
	<string name="id">cryptknight_summoning</string>
	<string name="name">Plaguebearer</string>
	<string name="description">Master of disease and decay.</string>

	<array name="icon"><s>players/cryptknight/icons_skills.png</s><i>100</i><vec4>48 168 24 24</vec4></array>

	<array name="skills">
		<string>players/attacks/dash.sval</string>
		
		<string>players/cryptknight/skills/pestilence.sval</string>
		<string>players/cryptknight/skills/bone_shield.sval</string>
		
		<string>players/cryptknight/skills/raise_dead.sval</string>
		<string>players/cryptknight/skills/sickly.sval</string>
	</array>

	%block SharedStats
</dict>

<dict>
	<string name="parent">cryptknight</string>
	<string name="id">cryptknight_souls</string>
	<string name="name">Void Knight</string>
	<string name="description">Empowered by Shadow Curse.</string>

	<array name="icon"><s>players/cryptknight/icons_skills.png</s><i>100</i><vec4>48 168 24 24</vec4></array>

	<array name="skills">
		<string>players/attacks/dash.sval</string>
		
		<string>players/cryptknight/skills/void_funnel.sval</string>
		<string>players/cryptknight/skills/bone_shield.sval</string>
		
		<string>players/cryptknight/skills/raise_dead.sval</string>
		<string>players/cryptknight/skills/cursed.sval</string>
	</array>

	%block SharedStats
</dict>

<dict>
	<string name="parent">cryptknight</string>
	<string name="id">cryptknight_chaos</string>
	<string name="name">Armoured Husk</string>
	<string name="description">An unstoppable undead juggernaut.</string>

	<array name="icon"><s>players/cryptknight/icons_skills.png</s><i>100</i><vec4>48 168 24 24</vec4></array>

	<array name="skills">
		<string>players/attacks/dash.sval</string>
		
		<string>players/cryptknight/skills/death_grip.sval</string>
		<string>players/cryptknight/skills/bone_shield.sval</string>
		
		<string>players/cryptknight/skills/raise_dead.sval</string>
		<string>players/cryptknight/skills/stronger_together.sval</string>
		<string>players/cryptknight/skills/unwaivering_oath.sval</string>
	</array>

	%block SharedStats
</dict>
%endblock
