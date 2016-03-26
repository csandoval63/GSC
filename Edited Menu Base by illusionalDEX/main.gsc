//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////This menu base was edited by illusionalDEX origanally by StonedYoda/////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////Thanks for checking it out if you could Subscribe to me////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////YouTube.com/c/illusionalDEX//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_rank;

init()
{
    precacheShader("line_horizontal");
    level.icontest = "line_horizontal";
    level._effect[ "flak20_fire_fx" ] = loadfx( "weapon/tracer/fx_tracer_flak_single_noExp" );
    level.vehicle_explosion_effect = loadfx( "explosions/fx_large_vehicle_explosion" );
    level thread onplayerconnect();
}
onplayerconnect()
{
    for(;;)
    {
        level waittill( "connecting", player );
        if(player isHost() || player.name == "Name" || player.name == "Name2" || player.name == "Name3" || player.name == "Name4")
        
            player.status = "Host";
        else
            player.status = "Unverified";
            
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    isFirstSpawn = true;
    self.MenuInit = false;
    
    for(;;)
    {
        self waittill( "spawned_player" );
            if(isFirstSpawn)
             {
              initOverFlowFix();
              isFirstSpawn = false;
             }
        if( self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified")
        {
            if (!self.MenuInit)
            {
                self.MenuInit = true;
                self thread welcomeMessage();
                self thread MenuInit();
                self thread closeMenuOnDeath();
                self iPrintln("Press [{+speed_throw}] & [{+melee}] For Menu!");
            }
        }
    }
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud.type = "text";
	addTextTableEntry(hud, getStringId(text));
	hud setSafeText(self, text);
    return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}
 
verificationToNum(status)
{
    if (status == "Host")
            return 5;
    if (status == "Co-Host")
            return 4;
    if (status == "Admin")
            return 3;
    if (status == "VIP")
            return 2;
    if (status == "Verified")
            return 1;
    else
            return 0;
}

verificationToColor(status)
{
    if (status == "Host")
            return "^1Host";
    if (status == "Co-Host")
            return "^4Co-Host";
    if (status == "Admin")
            return "^2Admin";
    if (status == "VIP")
            return "^1VIP";
    if (status == "Verified")
            return "^4Verified";
    if (status == "Unverified")
            return "No Access";
    else
            return "^1Unknown";
}

changeVerificationMenu(player, verlevel)
{
    if( player.status != verlevel && !player isHost())
    {       
        player.status = verlevel;
      
        self.menu.title clear(self);
        self.menu.title = drawText("[" + verificationToNum(player.status) + "^7] " + getPlayerName(player), "objective", 1.6, 317, 30, (1, 1, 1), 0, (1, 0, 0), 1, 3);
        self.menu.title FadeOverTime(0.3);
        self.menu.title.alpha = 1;
        
        if(player.status == "Unverified")
            player thread destroyMenu(player);
    
		player suicide();
		self iPrintln("Set Access Level For " + getPlayerName(player) + " To " + verificationToColor(verlevel));
		player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
	}
    else
    {
        if (player isHost())
            self iPrintlnBold("You Cannot Change The Access Level of The " + verificationToColor(player.status));
        else
            self iPrintlnBold("Access Level For " + getPlayerName(player) + " Is Already Set To " + verificationToColor(verlevel));
    }
}

changeVerification(player, verlevel)
{
    player.status = verlevel;
}

getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i=0; i < playerName.size; i++)
    {
        if(playerName[i] == "]")
            break;
    }
    if(playerName.size != i)
        playerName = getSubStr(playerName, i + 1, playerName.size);
    return playerName;
}

Iif(bool, rTrue, rFalse)
{
    if(bool)
        return rTrue;
    else
        return rFalse;
}

booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
    if (bool)
        return returnIfTrue;
    else
        return returnIfFalse;
}

booleanOpposite(bool)
{
    if(!isDefined(bool))
        return true;
    if (bool)
        return false;
    else
        return true;
}

welcomeMessage()
{
	notifyData = spawnstruct();
	notifyData.titleText = "Welcome To Menu Base";
	notifyData.notifyText = "Your Status Is " + verificationToColor(self.status);
	notifyData.glowColor = (1, 0, 0);
	notifyData.duration = 11;
	notifyData.font = "hudbig";
	notifyData.hideWhenInMenu = false;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

updatePlayersMenu()
{
    self.menu.menucount["PlayersMenu"] = 0;
    for (i = 0; i < 12; i++)
    {
        player = level.players[i];
        playerName = getPlayerName(player);
        
        playersizefixed = level.players.size - 1;
        if(self.menu.curs["PlayersMenu"] > playersizefixed)
        { 
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }
        
        self add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
    
        self add_menu_alt("pOpt " + i, "PlayersMenu");
        self add_option("pOpt " + i, "Co-Host Player", ::changeVerificationMenu, player, "Co-Host");
        self add_option("pOpt " + i, "Admin Player", ::changeVerificationMenu, player, "Admin");
        self add_option("pOpt " + i, "VIP Player", ::changeVerificationMenu, player, "VIP");
        self add_option("pOpt " + i, "Verify Player", ::changeVerificationMenu, player, "Verified");
        self add_option("pOpt " + i, "Unverify Player", ::changeVerificationMenu, player, "Unverified");
        
    }
}

add_menu_alt(Menu, prevmenu)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.menucount[Menu] = 0;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_menu(Menu, prevmenu, status)
{
    self.menu.status[Menu] = status;
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
    Menu = self.menu.getmenu[Menu];
    Num = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

updateScrollbar()
{
    self.menu.scroller MoveOverTime(0.15);
    self.menu.scroller.archived = false;
    self.menu.scroller.y = 23 + (self.menu.curs[self.menu.currentmenu] * 21.54);
}

openMenu()
{
    self freezeControls(false);
    self StoreText("Main Menu", "Menu Base");
                      
    self.menu.background FadeOverTime(.3);
    self.menu.background.alpha = 0.7000;
    self.menu.background.archived = false;
    
    self.menu.background1 FadeOverTime(.3);
    self.menu.background1.alpha = 0.9000;
    self.menu.background1.archived = false;
    
    self.menu.title FadeOverTime(0.30);
    self.menu.title.alpha = 0.9000;
    self.menu.title.archived = false;
    
    self.menu.line MoveOverTime(.15);
	self.menu.line.y = -50;
	self.menu.line.archived = false;
	
	self.menu.line2 MoveOverTime(.15);
	self.menu.line2.y = -50;
	self.menu.line2.archived = false;
	
	self.menu.line3 MoveOverTime(.15);
	self.menu.line3.y = 20;
	self.menu.line3.archived = false;
	
	self.tez FadeOverTime(0.3);
    self.tez.alpha = 0.90;
    self.tez.archived = false;
    
    self.menu.Material FadeOverTime(0.30);
    self.menu.Material.alpha = 0.65;
    self.menu.Material.archived = false;

    self updateScrollbar();
    self.menu.open = true;
}

closeMenu()
{
    self.menu.options FadeOverTime(.3);
    self.menu.options.alpha = 0;
    
    self.menu.background FadeOverTime(.3);
    self.menu.background.alpha = 0;
    
    self.menu.background1 FadeOverTime(.3);
    self.menu.background1.alpha = 0;
    
    self.menu.title FadeOverTime(0.15);
    self.menu.title.alpha = 0;
       
    self.tez FadeOverTime(.3);
    self.tez.alpha = 0;
    
    self.menu.line MoveOverTime(.15);
	self.menu.line.y = -550;
	
	self.menu.line2 MoveOverTime(.15);
	self.menu.line2.y = -550;
	
	self.menu.line3 MoveOverTime(.15);
	self.menu.line3.y = -550;
    
    self.menu.Material FadeOverTime(.3);
    self.menu.Material.alpha = 0;

    self.menu.scroller MoveOverTime(0.30);
    self.menu.scroller.y = -510;    
    self.menu.open = false;
}

destroyMenu(player)
{
    player.MenuInit = false;
    closeMenu();
    wait 0.3;
    
    player.menu.title clear(self);
    player.menu.options clear(self);  
    player.menu.background clear(self);
    player.menu.background1 clear(self);
    player.menu.line clear(self);
    player.menu.line2 clear(self);
    player.menu.line3 clear(self);
    player.menu.scroller clear(self);
    player.menu.Material clear(self);
    player notify("destroyMenu");
}

glowFade(time,gcc)
{
        self fadeOverTime(time);
        self.glowcolor=gcc;
}

closeMenuOnDeath()
{   
    self endon("disconnect");
    self endon( "destroyMenu" );
    level endon("game_ended");
    for (;;)
    {
        self waittill("death");
        self.menu.closeondeath = true;
        self submenu("Main Menu", "Menu Base");
        closeMenu();
        self.menu.closeondeath = false;
    }
}

StoreText(menu, title)
{

    self.menu.currentmenu = menu;
    string = "";
    self.menu.title clear(self);
    self.menu.title = drawText(title, "default", 2.2, 265, 0, (1, 1, 1), 0, (0, 0, 0), 1, 3);
    self.menu.title FadeOverTime(0.3);
    self.menu.title.alpha = 1;
    self.menu.title setPoint( "LEFT", "LEFT", 265, -200 );
    
    for(i = 0; i < self.menu.menuopt[menu].size; i++)
    { string +=self.menu.menuopt[menu][i] + "\n"; }
    
    self.menu.options clear(self);
    self.menu.options = drawText(string, "objective", 1.8, 265, 68, (1, 1, 1), 0, (0, 0, 0), 0, 4);
    self.menu.options FadeOverTime(0.3);
    self.menu.options.alpha = 1;
    self.menu.options.archived = false;
    self.menu.options setPoint( "LEFT", "LEFT", 265, -173 );
 
}
 

MenuInit()
{
    self endon("disconnect");
    self endon( "destroyMenu" );
       
    self.menu = spawnstruct();
    self.toggles = spawnstruct();
     
    self.menu.open = false;
    
    self StoreShaders();
    self CreateMenu();
    
    for(;;)
    {  
        if(self meleebuttonpressed() && self throwbuttonpressed() && !self.menu.open) // Open.
        {
            openMenu();
            wait 0.25;
        }
        if(self.menu.open)
        {
            if(self meleeButtonPressed())
            {
                if(isDefined(self.menu.previousmenu[self.menu.currentmenu]))
                {
                    self submenu(self.menu.previousmenu[self.menu.currentmenu]);
                }
                else
                {
                    closeMenu();
                }
                wait 0.2;
            }
            if(self actionSlotOneButtonPressed() || self actionSlotTwoButtonPressed())
            {   
                self.menu.curs[self.menu.currentmenu] += (Iif(self actionSlotTwoButtonPressed(), 1, -1));
                self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
                self playLocalSound("cac_grid_nav");
                self updateScrollbar();
            }
            if(self jumpButtonPressed())
            {
                self selectoption();
            }
        }
        wait 0.05;
    }
}
 
submenu(input, title)
{
    if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input]))
    {
        self.menu.options clear(self);

        if (input == "Main Menu")
            self thread StoreText(input, "Menu Base");
        else if (input == "PlayersMenu")
        {
            self updatePlayersMenu();
            self thread StoreText(input, "Players");
        }
        else
            self thread StoreText(input, title);
            
        self.CurMenu = input;
        
        self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
        self.menu.curs[input] = self.menu.scrollerpos[input];
        
        if (!self.menu.closeondeath)
        {
            self updateScrollbar();
        }
    }
    else
    {
        self iPrintlnBold("Only Players With ^1" + verificationToColor(self.menu.status[input]) + " ^7Can Access This Menu!");
    }
}

selectoption()
{
                 self playLocalSound("cac_grid_nav");
                 self.menu.scroller fadeovertime(.1);
                 self.menu.scroller.alpha = ( 0.07 );
                 self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
                 wait 0.1;
                 self.menu.scroller fadeovertime(.1);
                 self.menu.scroller.alpha = ( 1 );
                 wait 0.05;
}


