thunGun(){
    self endon("disconnect");
    self endon ("death");
    level.bettydestroyedfx = loadfx( "weapon/bouncing_betty/fx_betty_destroyed" );
    self giveWeapon("ksg_mp", 7, false);
    if(!self getCurrentWeapon() == "killstreak_remote_turret_mp")
    	self switchToWeapon("ksg_mp");
    self setWeaponAmmoStock("ksg_mp", 0);
    self setWeaponAmmoClip("ksg_mp", 1);
    self iPrintlnBold("^2ForceBlast Ready! ^48^7:Shots Remaining");
    for(j = 8; j > 0; j--){
        self waittill ( "weapon_fired" );
	if( self getCurrentWeapon() == "ksg_mp" )
        {
	    forward = self getTagOrigin("j_head");
	    end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
	    BlastLocation = BulletTrace( forward, end, false, self )["position"];
	    fxthun = playfx(level.bettydestroyedfx, self getTagOrigin("tag_weapon_right"));
	    fxthun.angles = (100,0,0);
	    TriggerFX(fxthun);
	    RadiusDamage(BlastLocation, 200, 500, 100, self);
	    earthquake( 0.9, 0.9, self.origin, 600 );
	    PlayRumbleOnPosition( "grenade_rumble", self.origin );
	    foreach(player in level.players){
	    	if(player.team != self.team){
	    		if(Distance(self.origin, player.origin) < 600)
	    			player thread thunDamage();}}
	    self switchToWeapon("ksg_mp");
	    wait 1.3;
	    bulletz = (j - 1);
	    self iPrintlnBold("^2ForceBlast Ready. ^4" + bulletz + "^7:Shots Remaining");
	    self setWeaponAmmoStock("ksg_mp", 0);
	    self setWeaponAmmoClip("ksg_mp", 1);
	    self switchToWeapon("ksg_mp");}else{j++;}}
	self takeWeapon( "ksg_mp" );
	wait 2;
	self notify ("THUNGONE");}

thunDamage(){
    self endon("disconnect");
    for(m = 4; m > 0; m--){	
        self setvelocity(self getvelocity()+(250,250,250));
		wait .1;}
    self setvelocity(0,0,0);
    wait 7;}
