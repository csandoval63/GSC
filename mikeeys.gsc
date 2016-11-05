#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;

main()
{
	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}
onPlayerSpawned()
{
	for(;;)
	{
		self waittill( "spawned_player" );
		self thread runMenu();
        self setClientDvar( "loc_warnings", "0" );
        self setClientDvar( "loc_warningsAsErrors", "0" );
	}
}

runMenu() {
	if(self == get_players()[0] && !isdefined(self.hostthreaded)) {
		//debug 
			self.score += 1100000;
		self thread menuBase();
	}
	if(self != get_players()[0]) {
		//none host shit
	}
	self thread addFunctionMenus();
}

addFunctionMenus() {
	self.title["MainMenu"] = "Main Menu";
	addmenuList("MainMenu", "mainMenu OPtion 1", ::newMenu, "subMenu", true);
	addmenuList("MainMenu", "mainMenu OPtion 1", ::newMenu, "subMenu", true);
	addmenuList("MainMenu", "mainMenu OPtion 1", ::newMenu, "subMenu", true);
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 1");
	addmenuList("MainMenu", "mainMenu OPtion 10");

	self.title["subMenu"] = "Sub Menu";
	addmenuList("subMenu/MainMenu", "subMenu OPtion 1", ::newMenu, "TestMenu");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 2", ::newMenu, "MainMenu");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 3");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 4");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 5");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 6");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 7");
	addmenuList("subMenu/MainMenu", "subMenu OPtion 8");

	self.title["TestMenu"] = "Test Menu";
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 1");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 2");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 3");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 4");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 5");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 6");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 7");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 8");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 9");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 10");
	addmenuList("TestMenu/subMenu", "TestMenu OPtion 11");
}

//Split menu design 
menuBase() 
{
	self.ui = spawnStruct();
	self.menu["locked"] = false;
	self.menu["userisin"] = false;
	self.menu["curs"] = 0;
	for(;;) 
	{
		if(!self.menu["locked"]) 
		{
			if(!self.menu["userisin"]) 
			{
				if(self meleeButtonPressed()) 
				{
					self openMenu("MainMenu", true);
					wait 0.2;
				}
			} 
			else
			{
				if(self attackBUttonPressed() || self adsButtonPressed()) 
				{
					self.menu["curs"] += self attackBUttonPressed();
					self.menu["curs"] -= self adsButtonPressed();
					if(self.menu["curs"] > self.items[self.menu["current"]].display.size-1)
						self.menu["curs"] = 0;
					if(self.menu["curs"] < 0)
						self.menu["curs"] = self.items[self.menu["current"]].display.size-1;

					self.ui.scroller moveElementY(0.18, self.ui.text[self.menu["curs"]].y);
					wait 0.18;
				}
				if(self meleeButtonPressed()) 
				{
					if(self.items[self.menu["current"]].parent != "null") 
						self newMenu(self.items[self.menu["current"]].parent);
					else
						self closeMenu();
					wait 0.2;
				}
				if(self useButtonPressed()) 
				{
					self [[self.items[self.menu["current"]].function[self.menu["curs"]]]](
						self.items[self.menu["current"]].arg[self.menu["curs"]], 
						self.items[self.menu["current"]].input[self.menu["curs"]], 
						self.items[self.menu["current"]].input2[self.menu["curs"]]);
					wait 0.2;
				}
				if(self fragButtonPressed()) 
				{
					self closeMenu();
					wait 0.2;
				}
			}
		}
		wait 0.01;
	}
}

openMenu(menu, menusection) {
	//inportant animation here.
	self.ui.background = createRectangle("TOP", "TOP", -265, 30, 230, 2, (0, 0, 0), 0, 0, "white");
	self.ui.scroller = createRectangle("LEFT", "CENTER", -380, -150, 230, 25, rgb(255, 69, 0), 1, 0, "white");
	self.ui.background moveElementAlpha(0.2, 1);
	self.ui.background scaleOverTime(0.2, 230, 320);
	self loadOptions(menu, menusection);
	self.ui.scroller moveElementAlpha(0.2, 1);
	wait 0.2;
	self.menu["userisin"] = true;
}

closeMenu() {
	self.menu["locked"] = true;
	self.menu["curs"] = 0;
	for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
		self.ui.text[i] moveElementAlpha(0.2, 0);
	wait 0.2;
	for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
		self.ui.text[i] Destroy();
	if(self.menu["current"] != "MainMenu") {
		self.ui.scroller moveElementAlpha(0.2, 0);
		self.ui.backgroundTemp scaleOverTime(0.2, 230, 0);
		self.ui.backgroundTemp moveElementAlpha(0.2, 0);
		wait 0.2;
		self.ui.backgroundTemp Destroy();
		self.ui.background scaleOverTime(0.2, 230, 0);
		self.ui.background moveElementAlpha(0.2, 0);
		self.ui.title moveElementAlpha(0.2, 0);
		wait 0.2;
	} else {
		self.ui.background scaleOverTime(0.2, 230, 0);
		self.ui.background moveElementAlpha(0.2, 0);
		self.ui.scroller moveElementAlpha(0.2, 0);
		self.ui.title moveElementAlpha(0.2, 0);
		wait 0.2;	
	}
	self.ui.scroller Destroy();
	self.ui.background Destroy();
	self.ui.title Destroy();
	self.menu["locked"] = false;
	self.menu["userisin"] = false;
}

loadOptions(menu, yesno) {
	self.menu["current"] = menu;
	if(IsDefined(yesno)) {
		//fail safe text build
		if(!isDefined(self.ui.title))
			self.ui.title = self createTextString("LEFT", "CENTER", -360, -180, 1.6, self.title[menu] );
		for(i=0;i<self.items[menu].display.size;i++) {
			self.ui.text[i] = self createTextString("LEFT", "CENTER", -360, -150+(i*25), 1.2, self.items[menu].display[i] );
			self.ui.text[i] moveElementAlpha(0.1, 1);
			wait 0.05;
		}
	} else {
		for(i=0;i<self.items[menu].display.size;i++) {
			self.ui.text[i] = self createTextString("LEFT", "CENTER", -130, -180+(i*25), 1.2, self.items[menu].display[i], 0 );
			self.ui.text[i] moveElementAlpha(0.1, 1);
			wait 0.05;
		}	
	}

}

//this is going to be masave
newMenu(menu, subornot) {
	save = self.menu["curs"];
	if(menu != "MainMenu" && isDefined(subornot)) {
		self.menu["locked"] = true;
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) {
			if(i == self.menu["curs"])
				continue;
			self.ui.text[i] moveElementAlpha(0.2, 0);
		}
		wait 0.1;
		if(self.ui.text[self.menu["curs"]].y != -150)
			self.ui.text[self.menu["curs"]] moveElementY(0.2, -150);
		self.ui.scroller moveElementY(0.2, -150);
		self.ui.background scaleOverTime(0.2, 230, 90);
		wait 0.2;
		self.ui.scroller moveElementAlpha(0.2, 0);
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) {
			if(i == self.menu["curs"])
				continue;
			self.ui.text[i] Destroy();
		}
		self.ui.background moveElementAlpha(0.2, 0.5);
		self.ui.backgroundTemp = createRectangle("TOP", "TOP", -35, 30, 230, 0, (0, 0, 0), 0, 0, "white");
		self.ui.text[self.menu["curs"]] moveElementAlpha(0.2, 0);
		wait 0.1;
		self.ui.backgroundTemp moveElementAlpha(0.2, 1);
		self.ui.backgroundTemp scaleOverTime(0.2, 230, (self.items[menu].display.size)*25+40);
		self.ui.text[self.menu["curs"]] Destroy();
		self loadOptions(menu);
		self.ui.background scaleOverTime(0.2, 230, 60);
		self.ui.scroller.y = self.ui.text[0].y;
		self.ui.scroller.x = -150;
		self.ui.scroller moveElementAlpha(0.2, 1);
		self.ui.title setText(self.title[menu]);
		self.menu["curs"] = 0;
		self.menu["locked"] = false;
	} 
	if(!isDefined(subornot) && menu != "MainMenu") {
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
			self.ui.text[i] moveElementAlpha(0.2, 0);
		wait 0.2;
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
			self.ui.text[i] Destroy();
		wait 0.1;
		self.ui.title setText(self.title[menu]);
		self.ui.backgroundTemp scaleOverTime(0.2, 230, (self.items[menu].display.size)*25+40);
		self loadOptions(menu);
		self.menu["curs"] = 0;
		self.ui.scroller moveElementY(0.18, self.ui.text[self.menu["curs"]].y);
		self iprintln("Quick Refesh");
	} 
	if(!isDefined(subornot) && menu == "MainMenu"){
		self.menu["locked"] = true;
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
			self.ui.text[i] moveElementAlpha(0.2, 0);
		self.ui.backgroundTemp scaleOverTime(0.2, 230, 10);
		self.ui.scroller moveElementAlpha(0.2, 0);
		self.ui.backgroundTemp moveElementAlpha(0.2, 0);
		wait 0.2;
		for(i=0;i<self.items[self.menu["current"]].display.size;i++) 
			self.ui.text[i] Destroy();
		self.ui.backgroundTemp Destroy();
		self.ui.scroller.y = -150;
		self.ui.scroller.x = -380;
		self.ui.scroller moveElementAlpha(0.2, 1);
		self.ui.title setText(self.title[menu]);
		self.ui.background moveElementAlpha(0.2, 1);
		self.ui.background scaleOverTime(0.2, 230, 320);
		self loadOptions(menu, true);
		self.menu["curs"] = 0;
		self.menu["locked"] = false;
	}
}

createTextString(align, relevent, x, y, font, string, alpha, color) {
	text = createFontString("default", font, self);
	text setPoint(align, relevent, x, y);
	text setText(string);
	if(isDefined(alpha))
		text.alpha = alpha;
	if(IsDefined(color))
		text.color = color;
	return text;
}

createRectangle(align, relative, x, y, width, height, color, sort, alpha, shader)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.sort = sort;
	barElemBG.color = color;
	barElemBG.alpha = alpha;
	barElemBG setParent( level.uiParent );
	barElemBG setShader( shader, width , height );
	barElemBG.hidden = false;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}


moveElementX(time, x) { self moveOverTime(time); self.x = x;}
moveElementY(time, y) { self moveOverTime(time); self.y = y;}
moveElementAlpha(time, alpha) { self fadeOverTime(time); self.alpha = alpha;}
rgb(r, g, b) { return ((r/255), (g/255), (b/255)); }

addmenuList(menu, text, function, arg, input, input2) {
	parentsystem = strTok(menu, "/");
	if(!isDefined(self.items[parentsystem[0]])) {
		self.items[parentsystem[0]] = spawnStruct();
		self.items[parentsystem[0]].display = [];
		self.items[parentsystem[0]].function = [];
		self.items[parentsystem[0]].arg = [];
		self.items[parentsystem[0]].input = [];
		self.items[parentsystem[0]].input2 = [];

		//parent 
		if(isDefined(parentsystem[1]))
			self.items[parentsystem[0]].parent = parentsystem[1];
		else
			self.items[parentsystem[0]].parent = "null";
	}
	count = self.items[parentsystem[0]].display.size;
	self.items[parentsystem[0]].display[count] = text;
	self.items[parentsystem[0]].function[count] = function;
	self.items[parentsystem[0]].arg[count] = arg;
	self.items[parentsystem[0]].input[count] = input;
	self.items[parentsystem[0]].input2[count] = input2;
}