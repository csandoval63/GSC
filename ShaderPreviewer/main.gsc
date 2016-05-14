//Include GSC From Original Game Files
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/_scoreevents;
#include maps/mp/teams/_teams;
#include maps/mp/gametypes/_rank;
#include maps/mp/gametypes/_hud;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/gametypes/_hud_message;
#include maps/mp/gametypes/_globallogic_score;
#include maps/mp/gametypes/_globallogic_utils;
#include maps/mp/gametypes/_spawnlogic;
#include maps/mp/gametypes/_spawning;

//Made By CoolJay
Init()
{
	level.result = 0;

	level thread Shaders();
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        player thread onPlayerLeave();
        wait 0.05;
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	
    self waittill("spawned_player");
    
    self freezecontrols(false);
    
    self SetActionSlot(1, "");
	self SetActionSlot(2, "");
	self SetActionSlot(3, "");
	self SetActionSlot(4, "");
	
	if(isFirstSpawn)
	{
		if(self isHost())
	    {
			thread OverFlowFix();
	        isFirstSpawn = false;
      	}
	}
	
	//Only Host Can See Shaders
	if(self isHost())
	{
		self.toggleshadercolor = false;
    	self.togglepositionandsize = true;
    	self EnableInvulnerability();
		self thread TextLayout();
		self thread SwitchShaders();
	}
}

onPlayerLeave()
{
	for(;;)
	{
		self waittill("disconnect");
		
		if (self isHost())
	  	{
			self.shaderspawn destroy(); 
			self.toggleposition destroy();  
			self.togglescale destroy();  
			self.currentshaderinfo destroy(); 
			self.currentshadernumber destroy();  
			self.shadernumberinfo destroy();  
			self.currentshadername destroy(); 
			self.shadername destroy();  
			self.currentshaderposition destroy();
			self.currentshaderpositionnum destroy(); 
			self.currentshaderscale destroy();  
			self.currentshaderscalenum destroy();  
			self.shadertext1 destroy();
			self.shadertext2 destroy();
			self.shadertext3 destroy();
			self.shadertext4 destroy();
		}
		wait 0.05;
	}
}

TextLayout()
{
	self endon("disconnect");
	level endon("game_ended");
	
	self.shadernumber = level.shadersstart;	
	shadersstarttt = level.shadersstart;
	shadersstarttt -= 1;
	level.shadersstartt = shadersstarttt;
	shadersenddd = level.shadersend;
	shadersenddd += 1;
	level.shadersendd = shadersenddd;
	
	self.shaderspawnx = 0;
	self.shaderspawny = 0;
	self.shaderspawnwidth = 100;
	self.shaderspawnheight = 100;
	
	self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, "white");
	self.shaderspawn.alpha = 0; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
	self.currentshaderinfo = self createText("default", 2, "Current Shader Info", "CENTER", "CENTER", -300, -60, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.currentshadernumber = self createText("default", 1.5, "Number:", "LEFT", "CENTER", -369, -30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
  	self.currentshadername = self createText("default", 1.5, "Name:", "LEFT", "CENTER", -369, -10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
  	self.currentshaderposition = self createText("default", 1.5, "Position:", "LEFT", "CENTER", -369, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
   	self.currentshaderscale = self createText("default", 1.5, "Scale:", "LEFT", "CENTER", -369, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadernumberinfo = self createText("default", 1.5, self.shadernumber, "LEFT", "CENTER", -320, -30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadername = self createText("default", 1.5, level.shader[self.shadernumber], "LEFT", "CENTER", -332, -10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.currentshaderpositionnum = self createText("default", 1.5, self.shaderspawn.x + ", " + self.shaderspawn.y, "LEFT", "CENTER", -320, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.currentshaderscalenum = self createText("default", 1.5, self.shaderspawnwidth + ", " + self.shaderspawnheight, "LEFT", "CENTER", -332, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadertext1 = self createText("default", 1.5, "Press [{+attack}]/[{+speed_throw}] To Change Shader", "CENTER", "CENTER", 0, 155, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadertext2 = self createText("default", 1.5, "Press [{+usereload}] To Toggle Shader Color", "CENTER", "CENTER", 0, 175, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadertext3 = self createText("default", 1.5, "Press [{+stance}] To Toggle Adjust Shader Position/Scale", "CENTER", "CENTER", 0, 195, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
	self.shadertext4 = self createText("default", 1.5, "Press [{+actionslot 1}]/[{+actionslot 2}]/[{+actionslot 3}]/[{+actionslot 4}] To Adjust Shader Position/Scale", "CENTER", "CENTER", 0, 215, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
}
		
SwitchShaders()
{
	self endon("disconnect");
	level endon("game_ended");
	
	for(;;)
	{
		if(self attackbuttonpressed())//R1
		{
			self.shadernumber += 1;
			if(self.shadernumber == level.shadersstartt)
			{
				self.shadernumber = level.shadersend;
			}
			if(self.shadernumber == level.shadersendd)
			{
				self.shadernumber = level.shadersstart;
			}
			self PlaySoundToPlayer("wpn_satchel_click_plr",self);
			self.shaderspawn destroy();
			self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
			self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
			self.shadernumberinfo destroy();
			self.shadernumberinfo = self createText("default", 1.5, self.shadernumber, "LEFT", "CENTER", -320, -30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
			self.shadername destroy();
			self.shadername = self createText("default", 1.5, level.shader[self.shadernumber], "LEFT", "CENTER", -332, -10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
			wait 0.2;
	    }
	    if(self adsbuttonpressed())//L1
		{
			self.shadernumber -= 1;
			if(self.shadernumber == level.shadersstartt)
			{
				self.shadernumber = level.shadersend;
			}
			if(self.shadernumber == level.shadersendd)
			{
				self.shadernumber = level.shadersstart;
			}
			self PlaySoundToPlayer("wpn_satchel_click_plr",self);
			self.shaderspawn destroy();
			self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
			self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
			self.shadernumberinfo destroy();
			self.shadernumberinfo = self createText("default", 1.5, self.shadernumber, "LEFT", "CENTER", -320, -30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
			self.shadername destroy();
			self.shadername = self createText("default", 1.5, level.shader[self.shadernumber], "LEFT", "CENTER", -332, -10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
			wait 0.2;
		
	    }
	    if(self UseButtonPressed())//Square
	    {
	    	if(self.toggleshadercolor == false)
			{
		    	self.shaderspawn destroy();
		    	self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn setColor(0, 0, 0, 0); self.shaderspawn.archived = true; self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.toggleshadercolor = true;
				wait 0.1;
			}
			else
			{
				self.shaderspawn destroy();
		    	self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.toggleshadercolor = false;
				wait 0.1;
			}
	    }
	   	if(self stancebuttonpressed())//Circle
	  	{
	    	if(self.togglepositionandsize == false)
			{
				self.toggleposition = self createText("bigfixed", 1, "Adjust Position", "CENTER", "CENTER", 0, -200, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.5;
		    	self.toggleposition fadeOverTime(0.5);
		    	self.toggleposition.alpha = 0;
		    	wait 0.5;
		    	self.toggleposition destroy();
				self.togglepositionandsize = true;
			}
			else
			{
				self.togglescale = self createText("bigfixed", 1, "Adjust Scale", "CENTER", "CENTER", 0, -200, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.5;
		    	self.togglescale fadeOverTime(0.2);
		    	self.togglescale.alpha = 0;
		    	wait 0.5;
		    	self.togglescale destroy();
				self.togglepositionandsize = false;
			}
		}
		//Position Toggle
	    if(self actionSlotFourButtonPressed())//Dpad Right
	    {
	    	if(self.togglepositionandsize == true)
			{
		    	self.shaderspawnx += 6;
		    	self.shaderspawn.x = self.shaderspawnx; 
		    	self.currentshaderpositionnum destroy();
		    	self.currentshaderpositionnum = self createText("default", 1.5, self.shaderspawn.x + ", " + self.shaderspawn.y, "LEFT", "CENTER", -320, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
			}
	    	
	    }
	   	if(self actionSlotThreeButtonPressed())//Dpad Left
	    {
	    	if(self.togglepositionandsize == true)
			{
		    	self.shaderspawnx -= 6;
		    	self.shaderspawn.x = self.shaderspawnx; 
		    	self.currentshaderpositionnum destroy();
		    	self.currentshaderpositionnum = self createText("default", 1.5, self.shaderspawn.x + ", " + self.shaderspawn.y, "LEFT", "CENTER", -320, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
			}
	    }
	    if(self actionSlotOneButtonPressed())//Dpad Up
	    {
	    	if(self.togglepositionandsize == true)
			{
		    	self.shaderspawny -= 6;
		    	self.shaderspawn.y = self.shaderspawny; 
		    	self.currentshaderpositionnum destroy();
		    	self.currentshaderpositionnum = self createText("default", 1.5, self.shaderspawn.x + ", " + self.shaderspawn.y, "LEFT", "CENTER", -320, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
			}
	    }
	    if(self actionSlotTwoButtonPressed())//Dpad Down
	    {
	    	if(self.togglepositionandsize == true)
			{
		    	self.shaderspawny += 6;
		    	self.shaderspawn.y = self.shaderspawny; 
		    	self.currentshaderpositionnum destroy();
		    	self.currentshaderpositionnum = self createText("default", 1.5, self.shaderspawn.x + ", " + self.shaderspawn.y, "LEFT", "CENTER", -320, 10, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
			}
	    }
		//Scale Toggle
		if(self.togglepositionandsize == false)
		{
	    	if(self actionSlotFourButtonPressed())//Dpad Right
		    {
		    	self.shaderspawnwidth += 10;
		    	self.shaderspawn destroy();
				self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.currentshaderscalenum destroy();
				self.currentshaderscalenum = self createText("default", 1.5, self.shaderspawnwidth + ", " + self.shaderspawnheight, "LEFT", "CENTER", -332, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
		    }
		    if(self actionSlotThreeButtonPressed())//Dpad Left
		    {
		    	self.shaderspawnwidth -= 10;
		    	self.shaderspawn destroy();
				self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.currentshaderscalenum destroy();
				self.currentshaderscalenum = self createText("default", 1.5, self.shaderspawnwidth + ", " + self.shaderspawnheight, "LEFT", "CENTER", -332, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
		    }
		    if(self actionSlotOneButtonPressed())//Dpad Up
		    {
		    	self.shaderspawnheight += 10;
		    	self.shaderspawn destroy();
				self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.currentshaderscalenum destroy();
				self.currentshaderscalenum = self createText("default", 1.5, self.shaderspawnwidth + ", " + self.shaderspawnheight, "LEFT", "CENTER", -332, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
		    }
		    if(self actionSlotTwoButtonPressed())//Dpad Down
		    {
		    	self.shaderspawnheight -= 10;
		    	self.shaderspawn destroy();
				self.shaderspawn = createRectangle("CENTER", "CENTER", 0, 0, self.shaderspawnwidth, self.shaderspawnheight, 1337, level.shader[self.shadernumber]);
				self.shaderspawn.alpha = 1; self.shaderspawn.x = self.shaderspawnx; self.shaderspawn.y = self.shaderspawny;
				self.currentshaderscalenum destroy();
				self.currentshaderscalenum = self createText("default", 1.5, self.shaderspawnwidth + ", " + self.shaderspawnheight, "LEFT", "CENTER", -332, 30, 1, true, 1, (1, 1, 1), 1, (0, 0, 0));
				wait 0.1;
		    }
		}
	    wait 0.05;
	}
}


