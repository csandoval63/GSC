#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_spawning;
#include maps\mp\killstreaks\_turret_killstreak;

init(){
	level.clientid = 0;
    level thread onPlayerConnect();}

onPlayerConnect(){
	for(;;){
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player.clientid = level.clientid;
		level.clientid++;}}

onPlayerSpawned(){
    self endon("disconnect");
	level endon("game_ended");
	isFirstSpawn = true;
    for(;;){
        self waittill("spawned_player");
        self.killstreakCount = 0;
        self.currentKills = self.pers["kills"];
        if(isFirstSpawn){
        	welcomeMessage("", "Welcome to FineNerds' Custom Killstreak Lobby", "hud_ks_emp_drop");
        	isFirstSpawn = false;}
        if(self isHost())
       		self freezecontrols(false);
        self thread ksMonitor();
        self thread resetStuff();
        self thread setVars();}}
 
ksMonitor(){
	level endon("game_ended");
	self endon("disconnected");
	self endon("death");
	for(;;){
		if(self.pers["kills"] != self.currentKills){
			self.currentKills = self.pers["kills"];
			self.killstreakCount++;
			self iprintln("Killstreak is: " + self.killstreakCount);
			thread callCustomStreaks();}
        self thread handler();
        wait 0.01;}}

