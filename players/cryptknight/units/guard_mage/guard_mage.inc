	<scenes start="idle-0 idle-1 idle-2 idle-3 idle-4 idle-5 idle-6 idle-7">	
		<scene name="shared">
			<collision static="false">
				<circle radius="7" offset="0 0" aim-through="true" charge-through="true" />
				<circle radius="10" offset="0 -9" sensor="true" shoot-through="false" aim-through="true" />
			</collision>
			<scene src="special/shadow.unit:14"/>
%if ELITE
			<scene src="actors/shared/elite_marker.unit:16"/>
			<scene src="special/minimap.unit:enemy_normal_elite"/>
%else
			<scene src="special/minimap.unit:enemy_normal"/>
%endif
		</scene>
		
		<scene name="idle-0" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">0 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-1" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">48 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-2" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">96 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-3" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">144 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-4" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">192 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-5" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">240 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-6" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">288 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-7" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="23 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage.tif" material="system/default.mats:enemy">		
				<frame time="160">336 0 48 48</frame>
			</sprite>
		</scene>

%defblock AnimWalk XCOORD
<scene src="shared" />
<sprite origin="24 30" texture="actors/undead/guard/guard_mage/guard_mage_move.tif" material="system/default.mats:enemy">
	<frame time="100">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
	<frame time="100">%%XCOORD%% 144 48 48</frame>
	<frame time="100">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
	<frame time="100">%%XCOORD%% 288 48 48</frame>
	<frame time="100">%%XCOORD%% 336 48 48</frame>
</sprite>
%endblock
		<scene name="walk-0">
			%block AnimWalk 0
		</scene>
		<scene name="walk-1">
			%block AnimWalk 48
		</scene>
		<scene name="walk-2">
			%block AnimWalk 96
		</scene>
		<scene name="walk-3">
			%block AnimWalk 144
		</scene>
		<scene name="walk-4">
			%block AnimWalk 192
		</scene>
		<scene name="walk-5">
			%block AnimWalk 240
		</scene>
		<scene name="walk-6">
			%block AnimWalk 288
		</scene>
		<scene name="walk-7">
			%block AnimWalk 336
		</scene>


%defblock AnimShoot XCOORD POSX POSY MOVEDIR
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage_attack.tif" material="system/default.mats:enemy">		
	<frame time="150">%%XCOORD%% 288 48 48</frame>
	<frame time="250">%%XCOORD%% 336 48 48</frame>
	<frame time="300">%%XCOORD%% 384 48 48</frame>
	<frame time="100">%%XCOORD%% 432 48 48</frame>
	<frame time="100">%%XCOORD%% 480 48 48</frame>
</sprite>
<effect src="effects/generic/actor/actor_cast_avatar_shadow_energy_2.effect?posx=%%POSX%%&posy=%%POSY%%&movedir=%%MOVEDIR%%&cR=0.25&cG=0.25&cB=0.5&glowflames=0"/>
%endblock
		<scene name="shoot-0">
			<locator name="shoot-pos" pos="14 -5"/>
			%block AnimShoot 0		0	-8	0 
		</scene>
		<scene name="shoot-1">
			<locator name="shoot-pos" pos="15 -2"/>
			%block AnimShoot 48		6	-8	0.72
		</scene>
		<scene name="shoot-2">
			<locator name="shoot-pos" pos="5 4"/>
			%block AnimShoot 96		4	0	1.57
		</scene>
		<scene name="shoot-3">
			<locator name="shoot-pos" pos="-11 0"/>
			%block AnimShoot 144	-4	-4	2.2
		</scene>
		<scene name="shoot-4">
			<locator name="shoot-pos" pos="-14 -4"/>
			%block AnimShoot 192	-4	-3	3.14
		</scene>
		<scene name="shoot-5">
			<locator name="shoot-pos" pos="-15 -6"/>
			%block AnimShoot 240	-2	-2	3.6
		</scene>
		<scene name="shoot-6">
			<locator name="shoot-pos" pos="-6 -16"/>
			%block AnimShoot 288	-10	-4	5
		</scene>
		<scene name="shoot-7">
			<locator name="shoot-pos" pos="8 -10"/>
			%block AnimShoot 336	0	0	5.4
		</scene>


%defblock AnimBlast XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage_attack.tif" material="system/default.mats:enemy">		
	<frame time="150">%%XCOORD%% 0 48 48</frame>
	<frame time="450">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
	<frame time="150">%%XCOORD%% 144 48 48</frame>
	<frame time="150">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
</sprite>
<effect src="effects/generic/actor/actor_cast_avatar_shadow_energy_2.effect?cR=0.25&cG=0.25&cB=0.5&glowflames=0&movespeed=0&movedir=1.57&moverange=8"/>
%endblock
		<scene name="blast-0">
			%block AnimBlast 0
		</scene>
		<scene name="blast-1">
			%block AnimBlast 48
		</scene>
		<scene name="blast-2">
			%block AnimBlast 96
		</scene>
		<scene name="blast-3">
			%block AnimBlast 144
		</scene>
		<scene name="blast-4">
			%block AnimBlast 192
		</scene>
		<scene name="blast-5">
			%block AnimBlast 240
		</scene>
		<scene name="blast-6">
			%block AnimBlast 288
		</scene>
		<scene name="blast-7">
			%block AnimBlast 336
		</scene>
  

%defblock AnimCast XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_mage/guard_mage_attack.tif" material="system/default.mats:enemy">
	<frame time="150">%%XCOORD%% 288 48 48</frame>
	<frame time="200">%%XCOORD%% 336 48 48</frame>
	<frame time="200">%%XCOORD%% 432 48 48</frame>
	<frame time="100">%%XCOORD%% 480 48 48</frame>
</sprite>
%endblock
		<scene name="cast-0">
			%block AnimCast 0
		</scene>
		<scene name="cast-1">
			%block AnimCast 48
		</scene>
		<scene name="cast-2">
			%block AnimCast 96
		</scene>
		<scene name="cast-3">
			%block AnimCast 144
		</scene>
		<scene name="cast-4">
			%block AnimCast 192
		</scene>
		<scene name="cast-5">
			%block AnimCast 240
		</scene>
		<scene name="cast-6">
			%block AnimCast 288
		</scene>
		<scene name="cast-7">
			%block AnimCast 336
		</scene>
	</scenes>
</unit>