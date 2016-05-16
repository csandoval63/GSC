/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : Erbil
*	 Project : CCM_BASE
*    Mode : Multiplayer
*	 Date : 2016.05.11 - 12:50:28
*
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

init()
{
  level.ccmMember = 0;
  level thread onplayerconnect();
  precacheshader("compass_emp");
  precacheshader("ui_host");
}
onplayerconnect()
{
  for( ;; )
  {
  level waittill( "connecting", player );
  if( player ishost() )
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
 
  self.MenuFirstRun = 0;
  isFirstSpawn = 1;
 
  for( ;; )
  {
  self waittill( "spawned_player" );
  if( self isV() )
  {
  if( !self.MenuFirstRun )
  {
 	self.MenuFirstRun = 1;
  	self thread ButtonMonitor();
  }
  if( isFirstSpawn && self ishost(  ) )
  {
  	StringFixer();
  	isFirstSpawn = 0;
  }
  }
  }
}
drawText( text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort )
{
  hud = self createFontString( font, fontScale );
  hud setText( text );
  hud setPoint( "LEFT", "TOP", x, y );
  hud.color = color;
  hud.alpha = alpha;
  hud.glowColor = glowColor;
  hud.glowAlpha = glowAlpha;
  hud.sort = sort;
  hud.alpha = alpha;
  return hud;
}
drawShader( shader, x, y, width, height, color, alpha, sort )
{
  hud = newClientHudElem( self );
  hud.elemtype = "icon";
  hud.color = color;
  hud.alpha = alpha;
  hud.sort = sort;
  hud.children = [];
  hud setParent( level.uiParent );
  hud setShader( shader, width, height );
  hud.x = x;
  hud.y = y;
  return hud;
}
verificationToColor( status )
{
  if ( status == "Host" )
  return "^2Host";
  if ( status == "Co-Host" )
  return "^5Co-Host";
  if ( status == "Admin" )
  return "^1Admin";
  if ( status == "Verified" )
  return "^3Verified";
  if ( status == "Unverified" )
  return "^1-";
}
changeVerificationMenu( player, verlevel )
{
  if( player.status != verlevel && !player ishost())
  { 
  player.status = verlevel;

  if( player.status == "Unverified" )
  self thread destroyMenu( player );
  else
  player ButtonMonitor();
  }
  else
  {
  if( player ishost() )
  self iprintln( "You Cannot Change The Access Level Of The Host" );
  else
  self iprintln( "Access Level For " + player.name + " Is Already Set To " + player.status );
  }
}
isH()
{
  if( self.status == "Co-Host" || self.status == "Host" )
  return 1;
  else
  return 0;
}
isA()
{
  if( self.status == "Admin" || self.status == "Co-Host" || self.status == "Host" )
  return 1;
  else
  return 0;
}
isV()
{
  if( self.status == "Verified" || self.status == "Admin" || self.status == "Co-Host" || self.status == "Host" )
  return 1;
  else
  return 0;
}

CreateMenu()
{
  self.bkg = drawShader( "compass_emp", 700, -30, 200, 55, ( 0, 0, 0 ), 1, 1 );
  self.bg = drawShader( "black", 200, 25, 200, 0, ( .7, .7, .7 ), 0, 1 );
  self.scroller = drawShader( "black", 185, 65, 230, 25, ( .7, .7, .7 ), 0, 1 );
  self.scrollerEmblem = drawShader( "ui_host", 87, 67, 20, 20, ( 0, .45, .01 ), 0, 1 );
  self.scrollerEmblem.foreground = true;
  
  self add_menu( "Main Menu", undefined );
 
  if( self isV() )// If user = VIP
  {
  self add_option( "Main Menu", "Sub Menu 1", ::submenu, "SubMenu1", "Sub Menu 1" );
  self add_menu( "SubMenu1", "Main Menu" );
  self add_option( "SubMenu1", "Option 1" );
   self add_option( "SubMenu1", "Option 2" );
    self add_option( "SubMenu1", "Option 3" );
     self add_option( "SubMenu1", "Option 4" );
  
  self add_option( "Main Menu", "Sub Menu 2", ::submenu, "SubMenu2", "Sub Menu 2" );
  self add_menu( "SubMenu2", "Main Menu" );
  self add_option( "SubMenu2", "Option 1" );
   self add_option( "SubMenu2", "Option 2" );
    self add_option( "SubMenu2", "Option 3" );
     self add_option( "SubMenu2", "Option 4" );
  
  self add_option( "Main Menu", "Sub Menu 3", ::submenu, "SubMenu3", "Sub Menu 3" );
  self add_menu( "SubMenu3", "Main Menu" );
  self add_option( "SubMenu3", "Option 1" );
   self add_option( "SubMenu3", "Option 2" );
    self add_option( "SubMenu3", "Option 3" );
     self add_option( "SubMenu3", "Option 4" );
  }
  if( self isA() ) // If user = Admin
  {
  self add_option( "Main Menu", "Sub Menu 4", ::submenu, "SubMenu4", "Sub Menu 4" );
  self add_menu( "SubMenu4", "Main Menu" );
  self add_option( "SubMenu4", "Option 1" );
  self add_option( "SubMenu4", "Option 2" );
  self add_option( "SubMenu4", "Option 3" );
  self add_option( "SubMenu4", "Option 4" );
  self add_option( "SubMenu4", "Option 5" );
  self add_option( "SubMenu4", "Option 6" );
  self add_option( "SubMenu4", "Option 7" );
  self add_option( "SubMenu4", "Option 8" );
  self add_option( "SubMenu4", "Option 9" );
  self add_option( "SubMenu4", "Option 10" );
  
  self add_option( "Main Menu", "Sub Menu 5", ::submenu, "SubMenu5", "Sub Menu 5" );
  self add_menu( "SubMenu5", "Main Menu" );
  self add_option( "SubMenu5", "Option 1" );
   self add_option( "SubMenu5", "Option 2" );
    self add_option( "SubMenu5", "Option 3" );
     self add_option( "SubMenu5", "Option 4" );
  
  self add_option( "Main Menu", "Sub Menu 6", ::submenu, "SubMenu6", "Sub Menu 6" );
  self add_menu( "SubMenu6", "Main Menu" );
  self add_option( "SubMenu6", "Option 1" );
  self add_option( "SubMenu6", "Option 2" );
  self add_option( "SubMenu6", "Option 3" );
  self add_option( "SubMenu6", "Option 4" );
  }
  if( self isH() )// If user = Host
  {
  self add_option( "Main Menu", "Client Menu", ::submenu, "PlayersMenu", "Players" ); 
  self add_menu( "PlayersMenu", "Main Menu");
  for ( i = 0; i < 12; i++ )
  {
  self add_menu( "pOpt " + i, "PlayersMenu");
  }
  self add_option( "Main Menu", "All Client Menu", ::submenu, "allPlayersMenu", "All Players" ); 
  self add_menu( "allPlayersMenu", "Main Menu" );
  self add_option( "allPlayersMenu", "Kill All Clients", ::killAll );
  self add_option( "allPlayersMenu", "Kick All Clients", ::kickAll );
  }
}

Pulser()
{
	self notify("stop_pulser");
	self endon("stop_pulser");
	self endon("menu_closed");
	self endon("death");
	
	self.Pulsing = true;
	while(true)
	{
		self fadeovertime( 0.3 );
		self.alpha = 0.3;
		wait 0.2;
		self fadeovertime( 0.3 );
		self.alpha = 1;
		wait 0.4;
		continue;
	}
}

stopPulser()
{
	if(self.Pulsing)
	{
		self notify("stop_pulser");
		self.alpha = 0.7;
		self.pulsing = false;
	}
}

Fontscaler(value, time)
{
	self changeFontScaleOverTime(time);
	self.fontScale = value;
}

updatePlayersMenu()
{
  self.menu.menucount["PlayersMenu"] = 0;
  for ( i = 0; i < 12; i++ )
  {
  player = level.players[i];
  name = player.name;
  playersizefixed = level.players.size - 1;
  if( self.menu.curs["PlayersMenu"] > playersizefixed )
  {
  self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
  self.menu.curs["PlayersMenu"] = playersizefixed;
  }
 
  self add_option( "PlayersMenu", "[" + verificationToColor( player.status ) + "^7] " + player.name, ::submenu, "pOpt " + i, "[" + verificationToColor( player.status ) + "^7] " + player.name );
 
  self add_menu( "pOpt " + i, "PlayersMenu" );
  self add_option( "pOpt " + i, "Give Co-Host Menu", ::changeVerificationMenu, player, "Co-Host" );
  self add_option( "pOpt " + i, "Give Admin Menu", ::changeVerificationMenu, player, "Admin" );
  self add_option( "pOpt " + i, "Give Verified Menu", ::changeVerificationMenu, player, "Verified" );
  self add_option( "pOpt " + i, "Remove Menu", ::changeVerificationMenu, player, "Unverified" );
  }
}
add_menu( Menu, prevmenu )
{
  self.menu.getmenu[Menu] = Menu;
  self.menu.scrollerpos[Menu] = 0;
  self.menu.curs[Menu] = 0;
  self.menu.menucount[Menu] = 0;
  self.menu.previousmenu[Menu] = prevmenu;
}
add_option( Menu, Text, Func, arg1, arg2 )
{
  Menu = self.menu.getmenu[Menu];
  Num = self.menu.menucount[Menu];
  self.menu.menuopt[Menu][Num] = Text;
  self.menu.menufunc[Menu][Num] = Func;
  self.menu.menuinput[Menu][Num] = arg1;
  self.menu.menuinput1[Menu][Num] = arg2;
  self.menu.menucount[Menu] += 1;
}
openAnim()
{
	self.bkg.alpha = 1;
	self.bkg moveovertime(.4);
  	self.bkg.x = 200;
  	wait .4;
  	self.bg fadeovertime(.2);
  	self.bg.alpha = .55;
  	self.scroller fadeovertime(.2);
  	self.scroller.alpha = 1;
  	self.scrollerEmblem fadeovertime(.2);
  	self.scrollerEmblem.alpha = 1;
  	self.bg scaleOverTime(.1,200,((self.menu.menuopt[self.menu.currentmenu].size*21)+50));
}
scrollAnim()
{
	self.scroller MoveOverTime(0.12);
	self.scrollerEmblem MoveOverTime(0.12);
	self.scroller.y = 65 + (21 * self.menu.curs[self.menu.currentmenu]);
	self.scrollerEmblem.y = 67 + (21 * self.menu.curs[self.menu.currentmenu]);
}
openMenu()
{
  self notify("menu_opened");
  self freezeControls( 0 );
  self text( "Main Menu", "Main Menu" );
  self setClientUiVisibilityFlag( "hud_visible", 0 );
  self openAnim();
  self.menu.open = 1;
}
closeMenu()
{
  self notify("menu_closed");
  self.bkg moveOvertime(.4);
  self.bkg.x = 650;
  self.text["current"] fadeovertime(.2);
  self.devText fadeovertime(.2);
  self.bg scaleovertime(.2, 200, 1);
  self.Menuname fadeovertime(.2);
  self.text["current"].alpha = 0;
  self.devText.alpha = 0;
  self.Menuname.alpha = 0;
  self.menu.open = 0;
  wait .4;
  for( i = 0; i < self.text["option"].size; i++ )
  {
  		self.text["option"][i].alpha = 0;
  		self.text["option"][i] destroy();
  }
  self setClientUiVisibilityFlag( "hud_visible", 1 );
 // self setblur( 0, .2 );
  self.scroller fadeovertime(.1);
  self.scroller.alpha = 0;
  self.scrollerEmblem fadeovertime(.1);
  self.scrollerEmblem.alpha = 0;
  self.bg fadeovertime(.1);
  self.bg.alpha = 0;
}
destroyMenu( player )
{
  player closeMenu();
  wait 1;
  player.text["option"] destroy();
  player.text["current"] destroy();
  player.ran = 0;
  player notify( "menuDestroyed" );
}
scroll()
{
  for( R = 0; R < self.menu.menuopt[self.menu.currentmenu].size; R++ )
  {
  if( self.menu.curs[self.menu.currentmenu] < 0 )
  self.menu.curs[self.menu.currentmenu] = self.menu.menuopt[self.menu.currentmenu].size - 1;
 
  if( self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size - 1 )
  self.menu.curs[self.menu.currentmenu] = 0;
 
  if( R == self.menu.curs[self.menu.currentmenu] )
  {
  self.text["option"][R].glowcolor = (0, .45, .01);
  self.text["option"][R].glowalpha = 1;
  self.text["option"][R] Fontscaler(2, .12);
  self.text["option"][R] thread Pulser();
  }
  else
  {
  self.text["option"][R].glowalpha = 0;
  self.text["option"][R] Fontscaler(1.6, .07);
  self.text["option"][R] thread stopPulser();
  }
 	 self scrollAnim();
  }
}
text( menu, title )
{
  self.menu.currentmenu = menu;
  glow = ( 1,0,1 );
  self.text["current"] destroy();
  self.devText destroy();
  self.Menuname destroy();
  self.text["current"] = drawText( title, "objective", 1.7, 115, 40, ( 1, 1, 1 ), 1, glow, 0, 2 );
  self.devText = drawText( "Developed by StonedYoda", "objective", 1.2, 115, 11, ( 1, 1, 0 ), 1, (0, 0, 0), 0, 2 );
  self.Menuname = drawText( "CabconModding.com", "objective", 2.1, 115, -6, ( 1, 1, 1 ), 1, (0, .45, .01), 0, 2 );
  self.Menuname.glowalpha = .3;
  self.Menuname.alpha = 1;
  self.Menuname fadeovertime( .05 );
 
  for( i = 0; i < self.menu.menuopt[menu].size; i++ )
  {
  self.text["option"][i] destroy();
  self.text["option"][i] = drawText( self.menu.menuopt[menu][i], "objective", 1.6, 115, 77 + ( i*21 ), ( 1, 1, 1 ), 0, ( 0, 0, 0 ), 0, 2 );
  self.text["option"][i] fadeovertime( .3 );
  self.text["option"][i].alpha = 1;
  self scroll();
  }
  self.bg scaleOverTime(.1,200,((self.menu.menuopt[self.menu.currentmenu].size*21)+50));// thx to Extinct
}
ButtonMonitor()
{
  self endon ( "menuDestroyed" );
  self endon ( "disconnected" );
 
  self.menu = spawnstruct();
  self.menu.open = 0;

  self CreateMenu();
 
  for(;;)
  {
  if( self MeleeButtonPressed() && self adsbuttonpressed() && !self.menu.open )
  {
  	openMenu();
  	wait .2;
  }
  if( self.menu.open )
  {
  if( self MeleeButtonPressed() )
  {
  if( isDefined( self.menu.previousmenu[self.menu.currentmenu] ) )
  self submenu( self.menu.previousmenu[self.menu.currentmenu] );
  else
  closeMenu();
  wait .3;
  }
  if( self adsbuttonpressed() )
  {
  self.menu.curs[self.menu.currentmenu]--;
  self scroll();
  wait 0.123;
  }
  if( self attackbuttonpressed() )
  {
  self.menu.curs[self.menu.currentmenu]++;
  self scroll();
  wait 0.123;
  }
  if( self Usebuttonpressed() )
  {
  	  self.scrollerEmblem scaleovertime(.123, 10, 10);
  	  wait .1;
  	  self.scrollerEmblem scaleovertime(.123, 20, 20);
  	  self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]] (self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]] );
 	  wait .15;
  }
  }
  wait .05;
  }
}
submenu( input, title )
{
  for( i = 0; i < self.text["option"].size; i++ )
  { self.text["option"][i] destroy(); }
 
  if( input == "Main Menu" )
  self thread text( input, "Main Menu" );
  else if ( input == "PlayersMenu" )
  {
  self updatePlayersMenu();
  self thread text( input, "Players" );
  }
  else
  self thread text( input, title );
 
  self.currenttitle = title;
 
  self.menu.scrollerpos[input] = self.menu.curs[input];
  self.menu.curs[input] = self.menu.scrollerpos[input];
}

StringFixer()//String overflow fix
{
  level endon( "game_ended" );
   
  level.CabConModding = createServerFontString( "default", 1.5 );
  level.CabConModding setText( "ccm" );
  level.CabConModding.alpha = 0;
  
  for(;;)
  {
     level waittill( "textset" );
  	 if(level.ccmMember >= 45)
 	 {
		  level.CabConModding ClearAllTextAfterHudElem();
 		  level.ccmMember = 0;
          foreach( player in level.players )
          	if( player.menu.open )
            	player thread submenu( self.menu.currentmenu, self.currenttitle );
  	 }
     wait .01;
 }
}

S(i)
{
	self iprintln(i);
}

debugexit()
{
	self S("^1WARNING^7: Exiting Level...");
	wait 2;
	exitlevel(false);
}




killAll()
{
	foreach(stoner in level.players)
	{
		if(!stoner isHost())
		{
			stoner suicide();
		}
	}
	self S("All Players ^2Killed");
}

kickAll()
{
	foreach(stoner in level.players)
	{
		if(!stoner isHost())
		{
			kick(stoner getentitynumber());
		}
	}
	self S("All Players ^2Kicked");
}
