%define DEFAULT

%defblock Colorize
<array name="colorize">
		<!-- red -->
		<i>0</i><a><s>#20100cff</s><s>#613228ff</s><s>#b26656ff</s></a> <!-- skin -->
		<i>1</i><a><s>#491210ff</s><s>#7d1e1cff</s><s>#b03b38ff</s></a> <!-- mouth -->
		<i>2</i><a><s>#9e7151ff</s><s>#caa074ff</s><s>#e5c3a3ff</s></a> <!-- theeth -->
		<i>3</i><a><s>#644c41ff</s><s>#7c695cff</s><s>#aa9682ff</s></a> <!-- claws -->
		<i>4</i><a><s>#000000ff</s><s>#006e82ff</s><s>#00d7feff</s></a> <!-- eyes -->
</array>
%endblock

<!-- Replaced warlock fiend with Horde Soldier (Skeleton) sprites -->
<scenes start="idle-0 idle-1 idle-2 idle-3 idle-4 idle-5 idle-6 idle-7">
	<scene name="shared">
		<collision static="false">
			<circle radius="7" offset="0 0" aim-through="true" charge-through="true" />
			<circle radius="10" offset="0 -9" sensor="true" shoot-through="false" aim-through="true" />
		</collision>
		<scene src="special/shadow.unit:14"/>
		<scene src="special/minimap.unit:ally_minion"/> 
		
		<light pos="0 -10">
			<sprite texture="effects/lights/light2_L.png">
				<frame>0 0 128 128</frame>
			</sprite>
			<length value="50" />
			<overbright value="1" />
			<looping value="true" />
			<cast-shadows value="false" />
			<shadow-cast-pos value="0 0" />
			<shadow-cast-pos-jitter value="0 0 0 0" />
			<sizes>
				<size value="64" />
			</sizes>
			<colors>
				<color value="0 110 0 0" /> <!-- Greenish light for friendly undead -->
			</colors>
		</light>
	</scene>
	
	%defblock AnimIdle XCOORD
	<scene src="shared" />
	<sprite origin="36 42" texture="actors/undead/horde/horde_soldier/horde_soldier.tif" material="system/default.mats:player">
		<frame time="100">%%XCOORD%% 0 64 64</frame>
	</sprite>
	%endblock

	<scene name="idle-0"> %block AnimIdle 0 </scene>
	<scene name="idle-1"> %block AnimIdle 64 </scene>
	<scene name="idle-2"> %block AnimIdle 128 </scene>
	<scene name="idle-3"> %block AnimIdle 192 </scene>
	<scene name="idle-4"> %block AnimIdle 256 </scene>
	<scene name="idle-5"> %block AnimIdle 320 </scene>
	<scene name="idle-6"> %block AnimIdle 384 </scene>
	<scene name="idle-7"> %block AnimIdle 448 </scene>

	%defblock AnimWalk XCOORD
	<scene src="shared" />
	<sprite origin="36 42" texture="actors/undead/horde/horde_soldier/horde_soldier.tif" material="system/default.mats:player">
		<frame time="90">%%XCOORD%% 0 64 64</frame>
		<frame time="80">%%XCOORD%% 64 64 64</frame>
		<frame time="70">%%XCOORD%% 128 64 64</frame>
		<frame time="50">%%XCOORD%% 192 64 64</frame>
		<frame time="90">%%XCOORD%% 256 64 64</frame>
		<frame time="80">%%XCOORD%% 320 64 64</frame>
		<frame time="70">%%XCOORD%% 384 64 64</frame>
		<frame time="50">%%XCOORD%% 448 64 64</frame>
	</sprite>
	%endblock

	<scene name="walk-0"> %block AnimWalk 64 </scene>
	<scene name="walk-1"> %block AnimWalk 128 </scene>
	<scene name="walk-2"> %block AnimWalk 192 </scene>
	<scene name="walk-3"> %block AnimWalk 256 </scene>
	<scene name="walk-4"> %block AnimWalk 320 </scene>
	<scene name="walk-5"> %block AnimWalk 384 </scene>
	<scene name="walk-6"> %block AnimWalk 448 </scene>
	<scene name="walk-7"> %block AnimWalk 512 </scene>
	
	%defblock AnimMelee XCOORD
	<scene src="shared" />
	<sprite origin="36 42" looping="false" texture="actors/undead/horde/horde_soldier/horde_soldier.tif" material="system/default.mats:player">
		<frame time="100">%%XCOORD%% 512 64 64</frame>
		<frame time="100">%%XCOORD%% 576 64 64</frame>
		<frame time="300">%%XCOORD%% 640 64 64</frame>
		<frame time="50"> %%XCOORD%% 704 64 64</frame>
		<frame time="50">%%XCOORD%% 768 64 64</frame>
		<frame time="200">%%XCOORD%% 832 64 64</frame>
		<frame time="150">%%XCOORD%% 896 64 64</frame>
		<frame time="150">%%XCOORD%% 960 64 64</frame>
	</sprite>
	%endblock		

	<scene name="melee-0"> %block AnimMelee 0 </scene>
	<scene name="melee-1"> %block AnimMelee 64 </scene>
	<scene name="melee-2"> %block AnimMelee 128 </scene>
	<scene name="melee-3"> %block AnimMelee 192 </scene>
	<scene name="melee-4"> %block AnimMelee 256 </scene>
	<scene name="melee-5"> %block AnimMelee 320 </scene>
	<scene name="melee-6"> %block AnimMelee 384 </scene>
	<scene name="melee-7"> %block AnimMelee 448 </scene>

	<!-- Ranged Mappings (Using Melee as fallback) -->
	<scene name="ranged-0"> %block AnimMelee 0 </scene>
	<scene name="ranged-1"> %block AnimMelee 64 </scene>
	<scene name="ranged-2"> %block AnimMelee 128 </scene>
	<scene name="ranged-3"> %block AnimMelee 192 </scene>
	<scene name="ranged-4"> %block AnimMelee 256 </scene>
	<scene name="ranged-5"> %block AnimMelee 320 </scene>
	<scene name="ranged-6"> %block AnimMelee 384 </scene>
	<scene name="ranged-7"> %block AnimMelee 448 </scene>

</scenes>
