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
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">0 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-1" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">48 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-2" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy"> 		
				<frame time="160">96 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-3" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">144 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-4" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">192 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-5" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">240 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-6" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">288 0 48 48</frame>
			</sprite>
		</scene>
		<scene name="idle-7" editor-bounds="-9 -24 18 32">
			<scene src="shared" />
			<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry.tif" material="system/default.mats:enemy">		
				<frame time="160">336 0 48 48</frame>
			</sprite>
		</scene>
		
%defblock AnimWalk XCOORD
<scene src="shared" />
<sprite origin="24 30" texture="actors/undead/guard/guard_sentry/guard_sentry_move.tif" material="system/default.mats:enemy">	
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


%defblock AnimShoot XCOORD
<scene src="shared" />
<sprite origin="24 30" looping="false" texture="actors/undead/guard/guard_sentry/guard_sentry_attack.tif" material="system/default.mats:enemy">		
	<frame time="150">%%XCOORD%% 0 48 48</frame>
	<frame time="150">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
	<frame time="100">%%XCOORD%% 144 48 48</frame>

	<frame time="100">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
	<frame time="100">%%XCOORD%% 288 48 48</frame>
	<frame time="100">%%XCOORD%% 336 48 48</frame>
	<frame time="250">%%XCOORD%% 384 48 48</frame>
	<frame time="200">%%XCOORD%% 432 48 48</frame>
	<frame time="100">%%XCOORD%% 480 48 48</frame>
</sprite>
%endblock
		<scene name="shoot-0">
			<locator name="shoot-pos" pos="10 0"/>
			%block AnimShoot 0
		</scene>
		<scene name="shoot-1">
			<locator name="shoot-pos" pos="8 4"/>
			%block AnimShoot 48
		</scene>
		<scene name="shoot-2">
			<locator name="shoot-pos" pos="2 8"/>
			%block AnimShoot 96
		</scene>
		<scene name="shoot-3">
			<locator name="shoot-pos" pos="-5 4"/>
			%block AnimShoot 144
		</scene>
		<scene name="shoot-4">
			<locator name="shoot-pos" pos="-8 0"/>
			%block AnimShoot 192
		</scene>
		<scene name="shoot-5">
			<locator name="shoot-pos" pos="-8 -4"/>
			%block AnimShoot 240
		</scene>
		<scene name="shoot-6">
			<locator name="shoot-pos" pos="-4 -8"/>
			%block AnimShoot 288
		</scene>
		<scene name="shoot-7">
			<locator name="shoot-pos" pos="6 -4"/>
			%block AnimShoot 336
		</scene>

%defblock AnimReload XCOORD
<scene src="shared" />
<sprite origin="24 29" looping="false" texture="actors/undead/guard/guard_sentry/guard_sentry_attack.tif" material="system/default.mats:enemy">
	<frame time="100">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
	<frame time="100">%%XCOORD%% 288 48 48</frame>
	<frame time="100">%%XCOORD%% 336 48 48</frame>
	<frame time="250">%%XCOORD%% 384 48 48</frame>
	<frame time="200">%%XCOORD%% 432 48 48</frame>
	<frame time="100">%%XCOORD%% 480 48 48</frame>
</sprite>
%endblock
		<scene name="reload-0">
			%block AnimReload 0
		</scene>
		<scene name="reload-1">
			%block AnimReload 48
		</scene>
		<scene name="reload-2">
			%block AnimReload 96
		</scene>
		<scene name="reload-3">
			%block AnimReload 144
		</scene>
		<scene name="reload-4">
			%block AnimReload 192
		</scene>
		<scene name="reload-5">
			%block AnimReload 240
		</scene>
		<scene name="reload-6">
			%block AnimReload 288
		</scene>
		<scene name="reload-7">
			%block AnimReload 336
		</scene>

%defblock AnimMelee XCOORD
<scene src="shared" />
<sprite origin="24 29" looping="false" texture="actors/undead/guard/guard_sentry/guard_sentry_stab.tif" material="system/default.mats:enemy">
	<frame time="100">%%XCOORD%% 0 48 48</frame>
	<frame time="100">%%XCOORD%% 48 48 48</frame>
	<frame time="100">%%XCOORD%% 96 48 48</frame>
	<frame time="100">%%XCOORD%% 144 48 48</frame>
	<frame time="100">%%XCOORD%% 192 48 48</frame>
	<frame time="100">%%XCOORD%% 240 48 48</frame>
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
	</scenes>
</unit>
