//Credits to dtx12, jwm614, and xTurntUpLobbies
OverFlowFix()
{  
	level endon("game_ended");
	
    level.test = createServerFontString("default",1.5);
    level.test setText("xTUL");                
    level.test.alpha = 0;
   
    for(;;)
    {      
        level waittill("textset");
        if(level.result >= 50)
        {
        	level.test ClearAllTextAfterHudElem();
        	level.result = 0;
        	
        	foreach(player in level.players)
        	{
        		if(player isHost())
        		{
        			self thread RecreateText();
        		}
        	}
        }      
        wait 0.05;    
    }
}

RecreateText()
{
	self.toggleposition setText("Adjust Position"); level.result += 1; level notify("textset");
	self.togglescale setText("Adjust Scale"); level.result += 1; level notify("textset");
	self.currentshaderinfo setText("Current Shader Info"); level.result += 1; level notify("textset");
	self.currentshadernumber setText("Number:"); level.result += 1; level notify("textset");
  	self.currentshadername setText("Name:"); level.result += 1; level notify("textset");
  	self.currentshaderposition setText("Position:"); level.result += 1; level notify("textset");
   	self.currentshaderscale setText("Scale:"); level.result += 1; level notify("textset");
	self.shadernumberinfo setText(self.shadernumber); level.result += 1; level notify("textset");
	self.shadername setText(level.shader[self.shadernumber]); level.result += 1; level notify("textset");
	self.currentshaderpositionnum setText(self.shaderspawn.x + ", " + self.shaderspawn.y); level.result += 1; level notify("textset");
	self.currentshaderscalenum setText(self.shaderspawnwidth + ", " + self.shaderspawnheight); level.result += 1; level notify("textset");
	self.shadertext1 setText("Press [{+attack}]/[{+speed_throw}] To Change Shader"); level.result += 1; level notify("textset");
	self.shadertext2 setText("Press [{+usereload}] To Toggle Shader Color"); level.result += 1; level notify("textset");
	self.shadertext3 setText("Press [{+stance}] To Toggle Adjust Shader Position/Scale"); level.result += 1; level notify("textset");
	self.shadertext4 setText("Press [{+actionslot 1}]/[{+actionslot 2}]/[{+actionslot 3}]/[{+actionslot 4}] To Adjust Shader Position/Scale"); level.result += 1; level notify("textset");
}


