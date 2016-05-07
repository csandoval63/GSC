setVars(){
self.streak1Used = false;
self.streak2Used = false;
self.streak3Used = false;
self.streak4Used = false;
self.streak5Used = false;}

handler(){
	if(self actionSlotFourButtonPressed() && self.streak1 && !self.streak2 && !self.streak3 && !self.streak4 && !self.streak5 && !self.streak1Used){
		//self callEbolaBomb();
		self.streak1 = false;
		self.streak1Used = true;}
	if(self actionSlotFourButtonPressed() && self.streak2 && !self.streak3 && !self.streak4 && !self.streak5 && !self.streak2Used){
		self initMissileStrike();
		self.streak2 = false;
		self.streak2Used = true;}
	if(self actionSlotFourButtonPressed() && self.streak3 && !self.streak4 && !self.streak5 && !self.streak3Used){
		self thunGun();
		self.streak3 = false;
		self.streak3Used = true;}
	if(self actionSlotFourButtonPressed() && self.streak4 && !self.streak5 && !self.streak4Used){
		self initStrafeRun();
		self.streak4 = false;
		self.streak4Used = true;}
	if(self actionSlotFourButtonPressed() && self.streak5 && !self.streak5Used){
		self callEbolaBomb();
		self.streak5 = false;
		self.streak5Used = true;}}

