#include maps\mp\gametypes\_globallogic_score;
#include maps\mp\gametypes\_globallogic_utils;
#include maps\mp\_scoreevents;
#include maps\mp\teams\_teams;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_spawnlogic;
#include maps\mp\gametypes\_spawning;
#include maps\mp\killstreaks\_turret_killstreak;
#include maps\mp\killstreaks\_killstreaks;

init()
{
    level thread onPlayerConnect();
    level thread adslel();
    level itemPrices();
    level levelHuds();
    
    level.spawnCash = 100;
    level.moneyPerKill = 50;
    level.moneyPerDeath = 20;
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        
        player.money = level.spawnCash;
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
    for(;;)
    {
        self waittill("spawned_player");
		
		self thread hudMonitor();
		self thread buttonMonitoring();
		
		self takeAllWeapons();
		self giveWeapon("knife_held_mp");
		self switchToWeapon("knife_held_mp");
		self SetActionSlot(1, "");
		self SetActionSlot(2, "");
		self SetActionSlot(3, "");
		self SetActionSlot(4, "");
    }
}

hudMonitor()
{
	self endon("disconnect");
	self endon("endHudMonitor");
	
	self storeHuds();
	
	self.currentkills = self.pers["kills"];
	self.currentdeaths = self.pers["deaths"];
	self.currentassists = self.pers["assists"];
	
	for(;;)
	{
		if(self.pers["kills"] != self.currentkills)
		{
			self.money += level.moneyPerKill;
			self.currentkills = self.pers["kills"];
		}
		if(self.pers["deaths"] != self.currentdeaths)
		{
			self.money += level.moneyPerDeath;
			self.currentdeaths = self.pers["deaths"];
		}
		self.moneyValue setValue(self.money);
		wait 0.01;
	}
}

buttonMonitoring()
{
	self endon("disconnect");
	self endon("death");
	self endon("endButtonMonitoring");
	
	for(;;)
	{
		if(self adsButtonPressed() && self actionSlotOneButtonPressed())//dpadUp ASSAULT
			self buyWeapon("Assault");
		if(self adsButtonPressed() && self actionSlotFourButtonPressed())//dpadRight SMG
			self buyWeapon("SMG");
		if(self adsButtonPressed() && self actionSlotTwoButtonPressed())//dpadDown SHOTGUN
			self buyWeapon("Shotgun");
		if(self adsButtonPressed() && self actionSlotThreeButtonPressed())//dpadLeft LMG
			self buyWeapon("Pistol");
			
		if(self isHost() && self getStance() == "prone" && self actionSlotFourButtonPressed())
			self thread forceHost();
		wait 0.01;
	}
}


