	<scenes start="idle-0 idle-1 idle-2 idle-3 idle-4 idle-5 idle-6 idle-7">
		<scene name="shared">
			<collision static="false">
				<circle radius="10" offset="0 0" aim-through="true" charge-through="true" density="100"/>
				<circle radius="14" sensor="true" offset="0 -14" shoot-through="false" aim-through="true" charge-through="true"/>
			</collision>
			<scene src="special/shadow.unit:24"/>
%if ELITE
			<scene src="special/minimap.unit:enemy_normal_elite"/>
			<scene src="actors/shared/elite_marker.unit:20"/>
%else
			<scene src="special/minimap.unit:enemy_normal"/>
%endif
		</scene>

		<scene name="idle-0" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">0 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-1" editor-bounds="-12 -39 21 48">
			<scene src="shared" /> 
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">64 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-2" editor-bounds="-12 -39 21 48">
		<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">128 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-3" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">192 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-4" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">256 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-5" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">320 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-6" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">384 0 64 64</frame>
			</sprite>
		</scene>
		<scene name="idle-7" editor-bounds="-12 -39 21 48">
			<scene src="shared" />
			<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">
				<frame time="100">448 0 64 64</frame>
			</sprite>
		</scene>


%defblock AnimWalk XCOORD
<scene src="shared" />
<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight_move.tif" material="system/default.mats:enemy">	
	<frame time="250">%%XCOORD%% 0 64 64</frame>
	<frame time="250">%%XCOORD%% 64 64 64</frame>
	<frame time="250">%%XCOORD%% 128 64 64</frame>
	<frame time="250">%%XCOORD%% 192 64 64</frame>
</sprite>
%endblock
		<scene name="walk-0">
			%block AnimWalk 0
		</scene>
		<scene name="walk-1">
			%block AnimWalk 64
		</scene>
		<scene name="walk-2">
			%block AnimWalk 128
		</scene>
		<scene name="walk-3">
			%block AnimWalk 192
		</scene>
		<scene name="walk-4">
			%block AnimWalk 256
		</scene>
		<scene name="walk-5">
			%block AnimWalk 320
		</scene>
		<scene name="walk-6">
			%block AnimWalk 384
		</scene>
		<scene name="walk-7">
			%block AnimWalk 448
		</scene>


%defblock AnimGuard XCOORD
<scene src="shared" />
<sprite origin="32 46" texture="actors/undead/guard/guard_knight/guard_knight.tif" material="system/default.mats:enemy">	
	<frame time="100">%%XCOORD%% 64 64 64</frame>
</sprite>
%endblock
		<scene name="guard-0">
			%block AnimGuard 0
		</scene>
		<scene name="guard-1">
			%block AnimGuard 64
		</scene>
		<scene name="guard-2">
			%block AnimGuard 128
		</scene>
		<scene name="guard-3">
			%block AnimGuard 192
		</scene>
		<scene name="guard-4">
			%block AnimGuard 256
		</scene>
		<scene name="guard-5">
			%block AnimGuard 320
		</scene>
		<scene name="guard-6">
			%block AnimGuard 384
		</scene>
		<scene name="guard-7">
			%block AnimGuard 448
		</scene>


%defblock AnimMelee XCOORD
<scene src="shared" />
<sprite origin="40 54" looping="false" texture="actors/undead/guard/guard_knight/guard_knight_melee.tif" material="system/default.mats:enemy">	
	<frame time="100">%%XCOORD%% 0 80 80</frame>
	<frame time="300">%%XCOORD%% 80 80 80</frame>
	<frame time="50">%%XCOORD%% 160 80 80</frame>
	<frame time="50">%%XCOORD%% 240 80 80</frame>
	<frame time="50">%%XCOORD%% 320 80 80</frame>
	<frame time="50">%%XCOORD%% 400 80 80</frame>
	<frame time="50">%%XCOORD%% 480 80 80</frame>
	<frame time="300">%%XCOORD%% 560 80 80</frame>
	<frame time="300">%%XCOORD%% 640 80 80</frame>
</sprite>
%endblock
		<scene name="melee-0">
			%block AnimMelee 0
		</scene>
		<scene name="melee-1">
			%block AnimMelee 80
		</scene>
		<scene name="melee-2">
			%block AnimMelee 160
		</scene>
		<scene name="melee-3">
			%block AnimMelee 240
		</scene>
		<scene name="melee-4">
			%block AnimMelee 320
		</scene>
		<scene name="melee-5">
			%block AnimMelee 400
		</scene>
		<scene name="melee-6">
			%block AnimMelee 480
		</scene>
		<scene name="melee-7">
			%block AnimMelee 560
		</scene>


%defblock AnimCastHeal XCOORD
<scene src="shared" />
<sprite origin="32 56" looping="false" texture="actors/undead/guard/guard_knight/guard_knight_cast.tif" material="system/default.mats:enemy">	
	<frame time="150">%%XCOORD%% 640 64 64</frame>
	<frame time="200">%%XCOORD%% 0 64 64</frame>
	<frame time="50">%%XCOORD%% 64 64 64</frame>
	<frame time="100">%%XCOORD%% 128 64 64</frame>
	<frame time="500">%%XCOORD%% 192 64 64</frame>
	<frame time="150">%%XCOORD%% 0 64 64</frame>
</sprite>
%endblock
		<scene name="heal-0">
			%block AnimCastHeal 0
		</scene>
		<scene name="heal-1">
			%block AnimCastHeal 64
		</scene>
		<scene name="heal-2">
			%block AnimCastHeal 128
		</scene>
		<scene name="heal-3">
			%block AnimCastHeal 192
		</scene>
		<scene name="heal-4">
			%block AnimCastHeal 256
		</scene>
		<scene name="heal-5">
			%block AnimCastHeal 320
		</scene>
		<scene name="heal-6">
			%block AnimCastHeal 384
		</scene>
		<scene name="heal-7">
			%block AnimCastHeal 448
		</scene>

%defblock AnimCast XCOORD POSX POSY
<scene src="shared" />
<sprite origin="32 56" looping="false" texture="actors/undead/guard/guard_knight/guard_knight_cast.tif" material="system/default.mats:enemy">	
	<frame time="100">%%XCOORD%% 640 64 64</frame>
	<frame time="100">%%XCOORD%% 0 64 64</frame>
	<frame time="300">%%XCOORD%% 192 64 64</frame>
	<frame time="100">%%XCOORD%% 256 64 64</frame>
	<frame time="100">%%XCOORD%% 320 64 64</frame>
	<frame time="50">%%XCOORD%% 384 64 64</frame>
	<frame time="150">%%XCOORD%% 448 64 64</frame>
	<frame time="300">%%XCOORD%% 512 64 64</frame>
	<frame time="150">%%XCOORD%% 576 64 64</frame>
</sprite> 
<effect src="effects/generic/actor/actor_cast_avatar_shadow_energy_2.effect?posx=%%POSX%%&posy=%%POSY%%&movedir=-1.57&cR=0.25&cG=0.25&cB=0.5&glowflames=0&moverange=42"/>
%endblock
		<scene name="cast-0">
			%block AnimCast 0	8	-6
		</scene>
		<scene name="cast-1">
			%block AnimCast 64	0	0
		</scene>
		<scene name="cast-2">
			%block AnimCast 128	-12	0
		</scene>
		<scene name="cast-3">
			%block AnimCast 192	-16	-4
		</scene>
		<scene name="cast-4">
			%block AnimCast 256	-12	-4 
		</scene>
		<scene name="cast-5">
			%block AnimCast 320	-4	-6
		</scene>
		<scene name="cast-6">
			%block AnimCast 384	6	-4
		</scene>
		<scene name="cast-7">
			%block AnimCast 448	8	0
		</scene>

		<scene name="barrier">
			<collision static="true">
				<circle radius="8" offset="0 0" sensor="true" shoot-through="false" />
			</collision>
			<scene src="special/shadow.unit:24"/>
			<sprite origin="32 56" looping="false" texture="actors/undead/guard/guard_knight/guard_knight_cast.tif" material="system/default.mats:enemy">	
				<frame time="100">512 0 64 64</frame>
				<frame time="100">512 64 64 64</frame>
				<frame time="600">512 128 64 64</frame>
				<frame time="100">512 192 64 64</frame>
				<frame time="150">512 256 64 64</frame>
				<frame time="500">512 320 64 64</frame>
				<frame time="100">512 0 64 64</frame>
			</sprite>
			<locator name="poi-pos1" pos="12 12"/>
			<locator name="poi-pos2" pos="-12 12"/>
			<locator name="poi-pos3" pos="-12 -12"/>
			<locator name="poi-pos4" pos="12 -12"/>
		</scene>
	</scenes>
</unit>