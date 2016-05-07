initStrafeRun(){ 
	if (!level.AwaitingPreviousStrafe){
	Location = locationSelector();
	level.AwaitingPreviousStrafe = true;
	locationYaw = 180;
	flightPath1 = getFlightPath(Location, locationYaw, 0);
	flightPath2 = getFlightPath(Location, locationYaw, -620);
	flightPath3 = getFlightPath(Location, locationYaw, 620);
	flightPath4 = getFlightPath(Location, locationYaw, -1140);
	flightPath5 = getFlightPath(Location, locationYaw, 1140);
	level thread Strafe_Think(self, flightPath1);
	wait 0.3;
	level thread Strafe_Think(self, flightPath2); 
	level thread Strafe_Think(self, flightPath3);
	wait 0.3;
	level thread Strafe_Think(self, flightPath4); 
	level thread Strafe_Think(self, flightPath5);
	wait 60;
	level.AwaitingPreviousStrafe = false;}}
	
Strafe_Think(owner, flightPath){
	 level endon("game_ended");
	 if (!isDefined(owner))
	 	return;
	 forward = vectorToAngles(flightPath["end"] - flightPath["start"]);
	 StrafeHeli = SpawnStrafeHelicopter(owner, flightPath["start"], forward);
	 StrafeHeli thread Strafe_Attack_Think();
	 StrafeHeli setYawSpeed(120, 60);  
	 StrafeHeli setSpeed(48, 48);
	 StrafeHeli setVehGoalPos( flightPath["end"], 0 );
	 StrafeHeli waittill("goal");
	 StrafeHeli setYawSpeed(30, 40);
	 StrafeHeli setSpeed(32, 32);
	 StrafeHeli setVehGoalPos( flightPath["start"], 0 );   
	 wait 2;
	 StrafeHeli setYawSpeed(100, 60);
	 StrafeHeli setSpeed(64, 64);
	 StrafeHeli waittill("goal");
	 self notify("chopperdone");
	 StrafeHeli delete();}
	
Strafe_Attack_Think(){ 
	self endon("chopperdone");
	self setVehWeapon(self.defaultweapon);
	for(;;){
		for (i = 0; i < level.players.size; i++){
				if(CanTargetPlayer(level.players[i])){
						self setturrettargetent(level.players[i]);
						self FireWeapon("tag_flash", level.players[i]);}}
		wait 0.5;}}
	
SpawnStrafeHelicopter(owner, origin, angles){
	 Team = owner.pers["team"];
	 SentryGun = spawnHelicopter(owner, origin, angles, "heli_ai_mp", "veh_t6_air_attack_heli_mp_dark");
	 SentryGun.team = Team;
	 SentryGun.pers["team"] = Team;
	 SentryGun.owner = owner;
	 SentryGun.currentstate = "ok";
	 SentryGun setdamagestage(4);
	 SentryGun.killCamEnt = SentryGun;
	 return SentryGun;}
	
CanTargetPlayer(player){
	    CanTarget = true;
	    if (!IsAlive(player) || player.sessionstate != "playing")
	        return false; 
	    if (Distance(player.origin, self.origin ) > 5000)
	        return false; 
	    if (!isDefined(player.pers["team"]))
	        return false;   
	    if (level.teamBased && player.pers["team"] == self.team)
	        return false;   
	    if (player == self.owner)
	        return false;  
	    if (player.pers["team"] == "spectator")
	        return false;   
	    if (!BulletTracePassed(self getTagOrigin("tag_origin"), player getTagOrigin("j_head"), false, self))
	        return false;
	    return CanTarget;}
	 
getFlightPath(location, locationYaw, rightOffset){
	 location = location * (1, 1, 0);
	 initialDirection = (0, locationYaw, 0); 
	 planeHalfDistance = 12000; 
	 flightPath = [];
	 if (isDefined(rightOffset) && rightOffset != 0)
	  location = location + (AnglesToRight(initialDirection ) * rightOffset ) + (0, 0, RandomInt(300));
	 startPoint = (location + (AnglesToForward(initialDirection) * (-1 * planeHalfDistance))); 
	 endPoint = (location + (AnglesToForward(initialDirection) * planeHalfDistance));
	 flyheight = 1500;
	 if (isDefined(maps/mp/killstreaks/_airsupport::getminimumflyheight()))
	  flyheight = maps/mp/killstreaks/_airsupport::getminimumflyheight();
	 flightPath["start"] = startPoint + ( 0, 0, flyHeight );
	 flightPath["end"] = endPoint + ( 0, 0, flyHeight );
	 return flightPath;}
