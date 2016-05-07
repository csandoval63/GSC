callEbolaBomb(){
	if(!level.awaitingEbolaBomb){
		self iPrintln("Ebola Bomb Got!");
		level.awaitingEbolaBomb = true;
		thread ebolaThink(self);
		level.awaitingEbolaBomb = false;}else{}}

ebolaThink(owner){
	level endon("game_ended");
	if(!isDefined(owner))
		return;
	thread ebolaTime();
	wait 10;
	thread ebolaKill();
	self notify("EbolaInjected");}

ebolaTime(){
	self endon("EbolaInjected");
	time = 10;
	for(time = 10;time > 0; time--){
		foreach(player in level.players)
			iPrintlnBold("Ebola Bomb will be active in " + time);
		wait 1;}}

ebolaKill(){
	self endon("EbolaInjected");
	for(i = 0; i < level.players.size; i++){
	 	level.players[i] thread [[level.callbackPlayerDamage]](self, self, 2147483600, 8, "MOD_SUICIDE", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_head", 0, 0 );}}
