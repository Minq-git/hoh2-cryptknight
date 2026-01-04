	<scenes start="idle-0 idle-1 idle-2 idle-3 idle-4 idle-5 idle-6 idle-7" post_e="idle-0" post_s="idle-2" post_w="idle-4" post_n="idle-6">
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
		
		<scene name="idle-0" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">
				<frame time="100">0 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-1" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">48 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-2" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">96 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-3" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">144 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-4" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">192 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-5" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">240 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-6" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">288 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-7" editor-bounds="-8 -18 16 25">
			<scene src="shared" />
			<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_defender/guard_defender.tif" material="system/default.mats:enemy">		
				<frame time="100">336 0 48 48</frame>
			</sprite>
		</scene>
		

%defblock AnimWalk XCOORD
<scene src="shared" />
<sprite origin="24 30" texture="actors/undead/guard/guard_defender/guard_defender_move.tif" material="system/default.mats:enemy">		
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
<scene src="shared" />
<sprite origin="24 30" loopback="100" texture="actors/undead/guard/guard_defender/guard_defender_attack.tif" material="system/default.mats:enemy">		
	<frame time="100">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
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
<scene src="shared" />
<sprite origin="24 30" texture="actors/undead/guard/guard_defender/guard_defender_guard_move.tif" material="system/default.mats:enemy">		
	<frame time="150">%%XCOORD%% 0 48 48</frame>
	<frame time="250">%%XCOORD%% 48 48 48</frame>
	<frame time="150">%%XCOORD%% 96 48 48</frame>
	<frame time="250">%%XCOORD%% 144 48 48</frame>
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



%defblock AnimMeleeLunge XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="./guard_defender/guard_defender_attack.tif" material="system/default.mats:enemy">		
	<frame time="100">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="250">%%XCOORD%% 96 48 48</frame>
	<frame time="400">%%XCOORD%% 144 48 48</frame>
	<frame time="50">%%XCOORD%% 192 48 48</frame>
	<frame time="200">%%XCOORD%% 240 48 48</frame>
	<frame time="100">%%XCOORD%% 288 48 48</frame>
</sprite>
%endblock
		<scene name="melee_lunge-0">
			%block AnimMeleeLunge 0
		</scene>
		<scene name="melee_lunge-1">
			%block AnimMeleeLunge 48
		</scene>
		<scene name="melee_lunge-2">
			%block AnimMeleeLunge 96
		</scene>
		<scene name="melee_lunge-3">
			%block AnimMeleeLunge 144
		</scene>
		<scene name="melee_lunge-4">
			%block AnimMeleeLunge 192
		</scene>
		<scene name="melee_lunge-5">
			%block AnimMeleeLunge 240
		</scene>
		<scene name="melee_lunge-6">
			%block AnimMeleeLunge 288
		</scene>
		<scene name="melee_lunge-7">
			%block AnimMeleeLunge 336
		</scene>

%defblock AnimMeleeStab XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="./guard_defender/guard_defender_attack.tif" material="system/default.mats:enemy">
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="200">%%XCOORD%% 96 48 48</frame>
	<frame time="50">%%XCOORD%% 144 48 48</frame>
	<frame time="50">%%XCOORD%% 192 48 48</frame>
	<frame time="150">%%XCOORD%% 240 48 48</frame>
</sprite>
%endblock
		<scene name="melee_stab-0">
			%block AnimMeleeStab 0
		</scene>
		<scene name="melee_stab-1">
			%block AnimMeleeStab 48
		</scene>
		<scene name="melee_stab-2">
			%block AnimMeleeStab 96
		</scene>
		<scene name="melee_stab-3">
			%block AnimMeleeStab 144
		</scene>
		<scene name="melee_stab-4">
			%block AnimMeleeStab 192
		</scene>
		<scene name="melee_stab-5">
			%block AnimMeleeStab 240
		</scene>
		<scene name="melee_stab-6">
			%block AnimMeleeStab 288
		</scene>
		<scene name="melee_stab-7">
			%block AnimMeleeStab 336
		</scene>
	</scenes>
</unit>