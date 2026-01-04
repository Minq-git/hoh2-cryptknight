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

		<scene name="shared-guard">
			<collision static="false">
				<circle radius="6" offset="0 0" aim-through="true" charge-through="false" density="100" />
				<circle radius="8" offset="0 -7" sensor="true" shoot-through="false" aim-through="true" />
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
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">0 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-1" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">48 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-2" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">96 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-3" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">144 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-4" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">192 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-5" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">240 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-6" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">288 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-7" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
				<frame time="160">336 0 48 48</frame>
			</sprite>
		</scene>
		

%defblock AnimWalk XCOORD
<scene src="shared" />
<sprite origin="24 30" texture="actors/undead/guard/guard_footman/guard_footman_move.tif" material="system/default.mats:enemy">		
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


%defblock AnimGuard XCOORD
<scene src="shared-guard" />
<sprite origin="24 30" loopback="100" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
</sprite>
%endblock
		<scene name="guard-0">
			%block AnimGuard 0
		</scene>
		<scene name="guard-1">
			%block AnimGuard 48
		</scene>
		<scene name="guard-2">
			%block AnimGuard 96
		</scene>
		<scene name="guard-3">
			%block AnimGuard 144
		</scene>
		<scene name="guard-4">
			%block AnimGuard 192
		</scene>
		<scene name="guard-5">
			%block AnimGuard 240
		</scene>
		<scene name="guard-6">
			%block AnimGuard 288
		</scene>
		<scene name="guard-7">
			%block AnimGuard 336
		</scene>

%defblock AnimGuardWalk XCOORD
<scene src="shared-guard" />
<sprite origin="24 30" loopback="100" texture="actors/undead/guard/guard_footman/guard_footman.tif" material="system/default.mats:enemy">		
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
</sprite>
%endblock
		<scene name="guard_walk-0">
			%block AnimGuardWalk 0
		</scene>
		<scene name="guard_walk-1">
			%block AnimGuardWalk 48
		</scene>
		<scene name="guard_walk-2">
			%block AnimGuardWalk 96
		</scene>
		<scene name="guard_walk-3">
			%block AnimGuardWalk 144
		</scene>
		<scene name="guard_walk-4">
			%block AnimGuardWalk 192
		</scene>
		<scene name="guard_walk-5">
			%block AnimGuardWalk 240
		</scene>
		<scene name="guard_walk-6">
			%block AnimGuardWalk 288
		</scene>
		<scene name="guard_walk-7">
			%block AnimGuardWalk 336
		</scene>


%defblock AnimMelee XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_footman/guard_footman_attack.tif" material="system/default.mats:enemy">		
	<frame time="50">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="300">%%XCOORD%% 96 48 48</frame>
	<frame time="50">%%XCOORD%% 144 48 48</frame>
	<frame time="50">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
	<frame time="200">%%XCOORD%% 288 48 48</frame>
</sprite>
%endblock
		<scene name="melee-0">
			%block AnimMelee 0
		</scene>
		<scene name="melee-1">
			%block AnimMelee 48
		</scene>
		<scene name="melee-2">
			%block AnimMelee 96
		</scene>
		<scene name="melee-3">
			%block AnimMelee 144
		</scene>
		<scene name="melee-4">
			%block AnimMelee 192
		</scene>
		<scene name="melee-5">
			%block AnimMelee 240
		</scene>
		<scene name="melee-6">
			%block AnimMelee 288
		</scene>
		<scene name="melee-7">
			%block AnimMelee 336
		</scene>


%defblock AnimMeleeGuard XCOORD
<scene src="shared-guard" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_footman/guard_footman_attack.tif" material="system/default.mats:enemy">		
	<frame time="50">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="300">%%XCOORD%% 96 48 48</frame>
	<frame time="50">%%XCOORD%% 144 48 48</frame>
	<frame time="50">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
	<frame time="100">%%XCOORD%% 288 48 48</frame>
</sprite>
%endblock
		<scene name="melee_guard-0">
			%block AnimMeleeGuard 0
		</scene>
		<scene name="melee_guard-1">
			%block AnimMeleeGuard 48
		</scene>
		<scene name="melee_guard-2">
			%block AnimMeleeGuard 96
		</scene>
		<scene name="melee_guard-3">
			%block AnimMeleeGuard 144
		</scene>
		<scene name="melee_guard-4">
			%block AnimMeleeGuard 192
		</scene>
		<scene name="melee_guard-5">
			%block AnimMeleeGuard 240
		</scene>
		<scene name="melee_guard-6">
			%block AnimMeleeGuard 288
		</scene>
		<scene name="melee_guard-7">
			%block AnimMeleeGuard 336
		</scene>
	</scenes>
</unit>
