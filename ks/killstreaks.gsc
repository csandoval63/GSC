resetStuff(){
	self.streak1 = false;
	self.streak2 = false;
	self.streak3 = false;
	self.streak4 = false;
	self.streak5 = false;
}

callCustomStreaks(){
	if(self.killstreakCount == 1 && !self.streak1)
		self.streak1 = true;
	if(self.killstreakCount == 7 && !self.streak2){
		self.streak2 = true;
		self iPrintlnBold("^5Missile Strike Ready!");}
	if(self.killstreakCount == 9 && !self.streak3){
		self.streak3 = true;
		self iPrintlnBold("^5Thunder Gun Ready!");}
	if(self.killstreakCount == 11 && !self.streak4){
		self.streak4 = true;
		self iPrintlnBold("^5Strafe Run Ready!");}
	if(self.killstreakCount == 30 && !self.streak5){
		self.streak5 = true;
		self iPrintlnBold("^5Ebola Bomb Ready!");}}

locationSelector(){
	 self endon("disconnect");
	 self endon("death");
	 self beginLocationSelection( "map_mortar_selector" ); 
	 self giveWeapon( "killstreak_remote_turret_mp" );
	 self switchToWeapon( "killstreak_remote_turret_mp" );
	 self disableoffhandweapons();
	 self.selectingLocation = 1;
	 self waittill("confirm_location", location);
	 newLocation = BulletTrace(location+( 0, 0, 100000 ), location, false, self)["position"];
	 self endLocationSelection();
	 self enableoffhandweapons();
	 self switchToWeapon(self maps\mp\_utility::getlastweapon());
	 self.selectingLocation = undefined;
	 return newLocation;}
	 
vector_scal(vec, scale){
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;}

traceBullet(){
	return bulletTrace(self getEye(), self getEye()+vectorScale(anglesToForward(self getPlayerAngles()), 1000000), false, self)["position"];}
