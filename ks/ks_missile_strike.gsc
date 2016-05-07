initMissileStrike(){
	level.waypointGreen = loadFX("misc/fx_equip_tac_insert_light_grn");
	level.waypointRed = loadFX("misc/fx_equip_tac_insert_light_red");
	missilesReady = 0;
	preTarg = (0, 0, 0);
	while(missilesReady != 3){
		target = locationSelector();
		iPrintlnBold("Select " + missiliesReady - 3 + " locations.");
		mFx = spawnFx(level.waypointGreen, target, (0, 0, 1), (1, 0, 0));
    	triggerFx(mFx);
		self thread spawnMissileStrike(target, mFx);
		missilesReady++;}
	self notify("launchMissiles");}

spawnMissileStrike(target, mFx){
    self waittill("launchMissiles");
    mFx delete();
    mFx = spawnFx(level.waypointRed, target, (0, 0, 1), (1, 0, 0));
    triggerFx(mFx);
    location = target +(0, 3500, 5000);
    missile = spawn("script_model", location);
    missile setModel("projectile_sidewinder_missile");
    missile.angles = missile.angles+(90, 90, 90);
    missile.killcament = missile;
    missile rotateto(VectorToAngles(target - missile.origin), 0.01);
    wait 0.01;
    endLocation = BulletTrace(missile.origin, target, false, self)["position"];
    missile moveto(endLocation, 3);
    wait 3;
    self playsound("wpn_rocket_explode");
    playFx(level.remote_mortar_fx["missileExplode"], missile.origin+(0, 0, 1));  
    RadiusDamage(missile.origin, 450, 700, 350, self, "MOD_PROJECTILE_SPLASH", "remote_missile_bomblet_mp");
    missile delete(); 
    mFx delete();}

