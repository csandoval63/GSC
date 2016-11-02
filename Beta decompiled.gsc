//Decompiled with SeriousHD-'s GSC Decompiler
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes/_hud;
#include maps/mp/gametypes/_rank;
#include maps/mp/gametypes/_weapons;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/gametypes/_rank;
#include maps/mp/killstreaks/_ai_tank;
#include maps/mp/gametypes/_globallogic;
#include maps/mp/gametypes/_globallogic_player;
#include maps/mp/gametypes/_globallogic_score;
#include maps/mp/killstreaks/_remotemissile;
#include maps/mp/killstreaks/_killstreaks;
init()
{
	level.strings = [];
	level.menutitle = "The Conception";
	if( getdvar( "stealthMenu" ) == "1" )
	{
		level.stealthmenu = 1;
	}
	if( getdvar( "smoothColor" ) == "1" )
	{
		level.color = 1;
	}
	precachelocationselector( "hud_medals_default" );
	shaders = strtok( "progress_bar_fg,faction_seals,faction_pmc", ";" );
	array_precache( shaders, "shader" );
	models = strtok( "veh_t6_air_fa38_killstreak,projectile_sidewinder_missile,t6_wpn_supply_drop_ally,projectile_cbu97_clusterbomb", ";" );
	array_precache( models, "model" );
	level thread onplayerconnect();

}

onplayerconnect()
{
	for(;;)
	{
	level waittill( "connected", player );
	if( player getplayername() == "Candy" )
	{
		player.status = "Creator";
	}
	else
	{
		if( player ishost() )
		{
			player.status = "Host";
		}
		else
		{
			if( isincohostlist( player ) )
			{
				player.status = "Co-Host";
			}
			else
			{
			}
		}
	}
	player thread onplayerspawned();
	}

}

onplayerspawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	isfirstspawn = 0;
	self resetbooleans();
	sy_aftergamemessage( "Big text at top", "", "" );
	for(;;)
	{
	self waittill( "spawned_player" );
	if( IsDefined( level.superjump ) )
	{
		self setperk( "specialty_fallheight" );
	}
	if( !(IsDefined( level.overflowfixthreaded )) )
	{
		level.overflowfixthreaded = 1;
		level thread overflowfix();
	}
	if( self isverified() && !(IsDefined( self.hasmenu )) )
	{
		self.hasmenu = 1;
		self thread menuinit();
		self thread closemenuondeath();
		self thread closemenuongameend();
	}
	if( !(isfirstspawn) )
	{
		isfirstspawn = 1;
		if( self ishost() )
		{
			setdvar( "sv_cheats", 1 );
			setdvar( "developer", 0 );
			self resetdvars();
		}
	}
	if( !(IsDefined( self.superjumpbool ))IsDefined( self.superjumpbool ) &&  )
	{
		self thread loopsuperjump();
	}
	}

}

resetdvars()
{
	setdvar( "g_speed", 190 );
	setdvar( "player_MeleeRange", 64 );
	setdvar( "g_knockback", 5 );

}

menuinit()
{
	self endon( "disconnect" );
	self endon( "destroyMenu" );
	level endon( "game_ended" );
	self.menu = spawnstruct();
	self.menu.curmenu = level.menutitle;
	self.menu.curtitle = level.menutitle;
	self.aio = spawnstruct();
	self.aio.shader = [];
	self.aio.string = [];
	self.aio.options = [];
	self initialmenusetup();
	if( self.stilllocked && IsDefined( self.stilllocked ) )
	{
		self.stilllocked = 0;
		self.menu.locked = 1;
	}
	self thread storeinfobarelem();
	self createmenu();
	self thread menuplayersinfo();
	if( !(IsDefined( self.menu.locked ))IsDefined( self.menu.locked ) &&  )
	{
		if( !(IsDefined( self.menu.open ))IsDefined( self.menu.open ) && self meleebuttonpressed() &&  )
		{
			self _openmenu();
			wait 0.2;
		}
		if( self inmenu() )
		{
			if( self stancebuttonpressed() )
			{
				self _closemenu();
			}
			else
			{
				if( self meleebuttonpressed() )
				{
					if( IsDefined( self.menu.previousmenu[ self.menu.curmenu] ) )
					{
						self submenu( self.menu.previousmenu[ self.menu.curmenu], self.menu.subtitle[ self.menu.previousmenu[ self.menu.curmenu]] );
						self playlocalsound( "fly_fnp45_mag_in" );
					}
					else
					{
						self _closemenu();
					}
					wait 0.2;
				}
				else
				{
					if( self actionslottwobuttonpressed() || self actionslotonebuttonpressed() )
					{
						if( !(self actionslottwobuttonpressed())self actionslottwobuttonpressed() ||  )
						{
							self playlocalsound( "fly_shotgun_push" );
							self.menu.curs[self.menu.curmenu] += self attackbuttonpressed();
							self.menu.curs[self.menu.curmenu] -= self adsbuttonpressed();
							self updatescrollbar();
							wait 0.13;
						}
					}
					else
					{
						if( self usebuttonpressed() )
						{
							if( IsDefined( self.menu.menuinput1[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]] ) && IsDefined( self.menu.menuinput[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]] ) )
							{
								self thread [[  ]]( self.menu.menuinput[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]], self.menu.menuinput1[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]] );
							}
							else
							{
								if( IsDefined( self.menu.menuinput[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]] ) )
								{
									self thread [[  ]]( self.menu.menuinput[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu]] );
								}
								else
								{
									self thread [[  ]]();
								}
							}
							self playlocalsound( "fly_beretta93r_slide_forward" );
							wait 0.2;
						}
					}
				}
			}
		}
	}
	wait 0.05;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

initialmenusetup()
{
	self.menudesign = [];
	col = strtok( "^0|^1|^2|^3|^4|^5|^6|^7", "|" );
	self.menudesign["titleAnimColor"] = col[ 3];
	self.menudesign["menuX"] = 100;
	self.menudesign["menuY"] = 0;
	self.menudesign["Halloween_Color"] = ( 0.976, 0.486, 0 );
	self.menudesign["Information_Color"] = ( 0, 0, 0 );
	self.menudesign["Scrollbar_Color"] = ( 0.922, 0.349, 0.004 );
	self.menudesign["Background_Color"] = dividecolor( 255, 255, 255 );
	self.menudesign["Backgroundouter_Color"] = dividecolor( 0, 0, 0 );
	self.menudesign["Title_Color"] = dividecolor( 255, 255, 255 );
	self.menudesign["TabInfo_Color"] = dividecolor( 255, 255, 255 );
	self.menudesign["Options_Color"] = dividecolor( 255, 255, 255 );

}

initialmenusetup()
{
	if( !(isconsole()) )
	{
		self.aiodesign["safeArea_X"] = 0;
	}
	if( !(isconsole()) )
	{
		self.aiodesign["safeArea_Y"] = 0;
	}
	if( isconsole() )
	{
		self.aiodesign["safeArea_X"] = -13;
	}
	if( isconsole() )
	{
		self.aiodesign["safeArea_Y"] = 12;
	}

}

verificationtocolor( status )
{
	if( status == "Creator" )
	{
		return "^6Creator^7";
	}
	if( status == "Host" )
	{
		return "^2Host^7";
	}
	if( status == "Co-Host" )
	{
		return "^5Co-Host^7";
	}
	if( status == "Admin" )
	{
		return "^1Admin^7";
	}
	if( status == "VIP" )
	{
		return "^4VIP^7";
	}
	if( status == "Verified" )
	{
		return "^3Verified^7";
	}
	if( status == "None" )
	{
		return "None";
	}

}

setplayerverification( player, which )
{
	if( player.status != which && !(player ishost())player ishost() &&  )
	{
		if( player isverified() )
		{
			player destroymenu();
		}
		player.status = which;
		if( player isverified() )
		{
			player.hasmenu = 1;
			player thread menuinit();
			player thread closemenuondeath();
			player thread closemenuongameend();
		}
		self iprintlnbold( player.name + ( " Verification Set To " + verificationtocolor( which ) ) );
		player iprintlnbold( "Verification Set To " + verificationtocolor( which ) );
	}
	else
	{
		if( player.status == which )
		{
			self iprintlnbold( player.name + ( " Verification Is Already Set To " + verificationtocolor( which ) ) );
		}
	}

}

getplayername()
{
	name = self.name;
	if( name[ 0] != "[" )
	{
		return name;
	}
	a -= 1;
	while( a >= 0 )
	{
		if( name[ a] == "]" )
		{
			break;
		}
		else
		{
			a++;
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	return getsubstr( name, a + 1 );

}

isverified()
{
	if( self.status != "None" )
	{
		return 1;
	}
	return 0;

}

cohostlist( player, action )
{
	dvar = getdvar( "coHostList" );
	name = player getplayername();
	if( action == 1 )
	{
		if( dvar == "" )
		{
			dvar = dvar + name;
		}
		else
		{
		}
	}
	if( action == 0 )
	{
		array = strtok( dvar, "," );
		dvar = "";
		i = 0;
		while( i < array.size )
		{
			if( array[ i] != name )
			{
				if( i == 0 )
				{
					dvar = dvar + array[ i];
				}
				else
				{
				}
			}
			i++;
		}
	}
	setdvar( "coHostList", dvar );
	self refreshmenuallplayers();

}

isincohostlist( who )
{
	if( getdvar( "coHostList" ) == "" )
	{
		return 0;
	}
	array = strtok( getdvar( "coHostList" ), "," );
	i = 0;
	while( i < array.size )
	{
		if( array[ i] == who getplayername() )
		{
			return 1;
		}
		i++;
	}
	return 0;

}

quickmenu()
{
	if( !(IsDefined( self.menu.quick )) )
	{
		self.menu.quickcheck = 1;
		self.menu.quick = 1;
	}
	else
	{
		self.menu.quickcheck = undefined;
	}
	self refreshmenu();

}

togglescrollbar()
{
	if( !(IsDefined( self.menu.scrollbar )) )
	{
		self.menu.scrollbarcheck = 1;
		self.menu.scrollbar = 1;
		self.aio.shader[ "Scrollbar"] setshader( "white", 2, 25 );
	}
	else
	{
		self.menu.scrollbarcheck = undefined;
		self.menu.scrollbar = undefined;
		self.aio.shader[ "Scrollbar"] setshader( "white", 160, 20 );
	}
	self refreshmenu();

}

stealthmenu()
{
	if( getdvar( "stealthMenu" ) == "" )
	{
		setdvar( "stealthMenu", "1" );
	}
	else
	{
		if( getdvar( "stealthMenu" ) == "1" )
		{
			setdvar( "stealthMenu", "0" );
		}
		else
		{
			setdvar( "stealthMenu", "1" );
		}
	}
	self quickrestart();

}

menucoloreditor( id, factory )
{
	self thread lockmenu( "EDITOR" );
	self.rgbeditor = [];
	self.menueditindex = [];
	a = 0;
	while( a < 3 )
	{
		self.rgbeditor[a] *= 255;
		self.menueditindex[a] *= 255;
		a++;
	}
	self.rgbeditordefaulttext += factory[ 0] + ( "," + ( factory[ 1] + ( "," + ( factory[ 2] + ")" ) ) ) );
	self.rgbeditor["Default"] = self createtext( self.rgbeditordefaulttext, self getfont( 1 ), 1, "CENTER", ( self.aio.string[ "title"].x + 160 ) / ( 2 - 80 ), self.menudesign[ "menuY"] - 50, undefined, 1, 2 );
	self.rgbeditor[3] = self createrectangle( "LEFT", self.rgbeditor[ "Default"].x - 60, self.menudesign[ "menuY"] - 30, 130, 1, ( 1, 1, 1 ), "white", 6, 1 );
	self.rgbeditor[4] = self createrectangle( "CENTER", self.rgbeditor[ 3].x + self.rgbeditor[ 0] * ( 130 / 255 ), self.rgbeditor[ 3].y, 2, 10, ( 1, 1, 1 ), "white", 6, 1 );
	self.rgbeditor[5] = self createtext( "^1R:", self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 3].x - 12, self.rgbeditor[ 3].y, undefined, 1, 6 );
	self.rgbeditor[6] = self createtext( self.rgbeditor[ 0], self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 5].x, self.menudesign[ "menuY"] + 50, undefined, 1, 6, undefined, 1 );
	self.rgbeditor[ 6].label = &"Red: ";
	self.rgbeditor[7] = self createrectangle( "LEFT", self.rgbeditor[ 3].x, self.menudesign[ "menuY"], 130, 1, ( 1, 1, 1 ), "white", 4, 1 );
	self.rgbeditor[8] = self createrectangle( "CENTER", self.rgbeditor[ 3].x + self.rgbeditor[ 1] * ( 130 / 255 ), self.rgbeditor[ 7].y, 2, 10, ( 1, 1, 1 ), "white", 4, 1 );
	self.rgbeditor[9] = self createtext( "^2G:", self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 3].x - 12, self.rgbeditor[ 7].y, undefined, 1, 4 );
	self.rgbeditor[10] = self createtext( self.rgbeditor[ 1], self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 5].x, self.menudesign[ "menuY"] + 60, undefined, 1, 4, undefined, 1 );
	self.rgbeditor[ 10].label = &"Green: ";
	self.rgbeditor[11] = self createrectangle( "LEFT", self.rgbeditor[ 3].x, self.menudesign[ "menuY"] + 30, 130, 1, ( 1, 1, 1 ), "white", 4, 1 );
	self.rgbeditor[12] = self createrectangle( "CENTER", self.rgbeditor[ 3].x + self.rgbeditor[ 2] * ( 130 / 255 ), self.rgbeditor[ 11].y, 2, 10, ( 1, 1, 1 ), "white", 4, 1 );
	self.rgbeditor[13] = self createtext( "^4B:", self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 3].x - 12, self.rgbeditor[ 11].y, undefined, 1, 4 );
	self.rgbeditor[14] = self createtext( self.rgbeditor[ 2], self getfont( 1 ), 1, "LEFT", self.rgbeditor[ 5].x, self.menudesign[ "menuY"] + 70, undefined, 1, 4, undefined, 1 );
	self.rgbeditor[ 14].label = &"Blue: ";
	if( id == "TabInfo" || id == "Options" )
	{
		self.rgbeditor[15] = self createtext( "Preview:", self getfont( 1 ), 1, "CENTER", self.rgbeditor[ "Default"].x + 30, self.rgbeditor[ 6].y, undefined, 1, 10 );
		self.rgbeditor[16] = self createrectangle( "CENTER", self.rgbeditor[ 15].x, self.rgbeditor[ 14].y, 60, 20, dividecolor( self.rgbeditor[ 0], self.rgbeditor[ 1], self.rgbeditor[ 2] ), "white", 12, 1 );
	}
	slider = 0;
	self thread updatemenucoloreditor( id, self.rgbeditor );
	while( isverified() && isalive( self ) )
	{
		if( self attackbuttonpressed() || self adsbuttonpressed() )
		{
			self.menueditindex[slider] += self attackbuttonpressed();
			self.menueditindex[slider] -= self adsbuttonpressed();
			if( self.menueditindex[ slider] > 255 )
			{
				self.menueditindex[slider] = 0;
			}
			if( self.menueditindex[ slider] < 0 )
			{
				self.menueditindex[slider] = 255;
			}
			self thread editcolor( self.rgbeditor, self getmenuhud( id ), slider, id );
			if( id == "TabInfo" || id == "Options" )
			{
				self.rgbeditor[ 16] fadeovertime( 0.2 );
				self.rgbeditor[ 16].color = dividecolor( self.menueditindex[ 0], self.menueditindex[ 1], self.menueditindex[ 2] );
			}
			break;
		}
		else
		{
			if( self fragbuttonpressed() )
			{
				a = 0;
				while( a < 2 )
				{
					b = slider * 4 + 3;
					while( ( b < slider ) * ( 4 + 7 ) )
					{
						self.rgbeditor[ b].sort += a * 4;
						b++;
					}
					if( a > 0 )
					{
						break;
					}
					else
					{
						slider++;
						if( slider > 2 )
						{
							slider = 0;
						}
						a++;
						?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
					}
				}
				wait 0.15;
				break;
			}
			else
			{
				if( self meleebuttonpressed() )
				{
					break;
				}
			}
		}
		wait 0.05;
	}
	self notify( "UPDATE_MENU_COLOR_OVER" );
	self destroyall( self.rgbeditor );
	wait 0.1;
	if( isverified() )
	{
		self unlockmenu( "unlockEditor" );
	}

}

updatemenucoloreditor( id, editor )
{
	self notify( "UPDATE_MENU_COLOR_OVER" );
	self endon( "UPDATE_MENU_COLOR_OVER" );
	while( IsDefined( editor[ 3] ) )
	{
		a = 0;
		while( a < 3 )
		{
			self.menueditindex[a] *= 255;
			editor[ ( a + 1 ) * 4] thread hudmovex( editor[ 3].x + self.menueditindex[ a] * ( 130 / 255 ), 0.15 );
			editor[ 6 + a * 4] setvalue( self.menueditindex[ a] );
			a++;
		}
		if( id == "TabInfo" || id == "Options" )
		{
			editor[ 16] fadeovertime( 0.2 );
			editor[ 16].color = dividecolor( self.menueditindex[ 0], self.menueditindex[ 1], self.menueditindex[ 2] );
		}
		wait 0.1;
	}

}

setmenucolor( hud, id, color, editor )
{
	self.menudesign[id + "_Color"] = color;
	self.aio.shader[ hud] fadeovertime( 0.2 );
	self.aio.shader[ hud].color = color;

}

sethudcolor( id, color )
{
	self.menudesign[id + "_Color"] = color;
	self.aio.shader[ id] fadeovertime( 0.2 );
	self.aio.shader[ id].color = color;

}

editcolor( editor, hud, slider, id )
{
	editor[ ( slider + 1 ) * 4] thread hudmovex( editor[ 3].x + self.menueditindex[ slider] * ( 130 / 255 ), 0.05 );
	if( IsDefined( id ) )
	{
		self setmenucolor( hud, id, dividecolor( self.menueditindex[ 0], self.menueditindex[ 1], self.menueditindex[ 2] ), 1 );
	}
	editor[ 6 + slider * 4] setvalue( self.menueditindex[ slider] );

}

getmenuhud( id )
{
	if( id == "Topbar" )
	{
		return "Topbar";
	}
	if( id == "Scrollbar" )
	{
		return "Scrollbar";
	}
	if( id == "Background" )
	{
		return "Background";
	}
	if( id == "Backgroundouter" )
	{
		return "Backgroundouter";
	}

}

colormode()
{
	if( !(IsDefined( self.color )) )
	{
		self.color = 1;
		self.aio.shader[ "Scrollbar"] thread alwayscolorful();
		self.aio.shader[ "Topbar"] thread alwayscolorful();
	}
	else
	{
		self.color = undefined;
	}
	self refreshmenu();

}

godmode()
{
	if( !(IsDefined( self.godmode )) )
	{
		self.godmode = 1;
		self enableinvulnerability();
	}
	else
	{
		self.godmode = undefined;
		self disableinvulnerability();
	}
	self refreshmenu();

}

toggleuav()
{
	if( !(IsDefined( self.toggleuav )) )
	{
		self.toggleuav = 1;
		self setclientuivisibilityflag( "g_compassShowEnemies", 1 );
	}
	else
	{
		self.toggleuav = undefined;
		self setclientuivisibilityflag( "g_compassShowEnemies", 0 );
	}
	self refreshmenu();

}

doperks()
{
	if( !(IsDefined( self.doperks )) )
	{
		self.doperks = 1;
		self setperk( "specialty_additionalprimaryweapon" );
		self setperk( "specialty_armorpiercing" );
		self setperk( "specialty_armorvest" );
		self setperk( "specialty_bulletaccuracy" );
		self setperk( "specialty_bulletdamage" );
		self setperk( "specialty_bulletflinch" );
		self setperk( "specialty_bulletpenetration" );
		self setperk( "specialty_deadshot" );
		self setperk( "specialty_delayexplosive" );
		self setperk( "specialty_detectexplosive" );
		self setperk( "specialty_disarmexplosive" );
		self setperk( "specialty_earnmoremomentum" );
		self setperk( "specialty_explosivedamage" );
		self setperk( "specialty_extraammo" );
		self setperk( "specialty_fallheight" );
		self setperk( "specialty_fastads" );
		self setperk( "specialty_fastequipmentuse" );
		self setperk( "specialty_fastladderclimb" );
		self setperk( "specialty_fastmantle" );
		self setperk( "specialty_fastmeleerecovery" );
		self setperk( "specialty_fastreload" );
		self setperk( "specialty_fasttoss" );
		self setperk( "specialty_fastweaponswitch" );
		self setperk( "specialty_finalstand" );
		self setperk( "specialty_fireproof" );
		self setperk( "specialty_flakjacket" );
		self setperk( "specialty_flashprotection" );
		self setperk( "specialty_gpsjammer" );
		self setperk( "specialty_grenadepulldeath" );
		self setperk( "specialty_healthregen" );
		self setperk( "specialty_holdbreath" );
		self setperk( "specialty_immunecounteruav" );
		self setperk( "specialty_immuneemp" );
		self setperk( "specialty_immunemms" );
		self setperk( "specialty_immunenvthermal" );
		self setperk( "specialty_immunerangefinder" );
		self setperk( "specialty_killstreak" );
		self setperk( "specialty_longersprint" );
		self setperk( "specialty_loudenemies" );
		self setperk( "specialty_marksman" );
		self setperk( "specialty_movefaster" );
		self setperk( "specialty_nomotionsensor" );
		self setperk( "specialty_noname" );
		self setperk( "specialty_nottargetedbyairsupport" );
		self setperk( "specialty_nokillstreakreticle" );
		self setperk( "specialty_nottargettedbysentry" );
		self setperk( "specialty_pin_back" );
		self setperk( "specialty_pistoldeath" );
		self setperk( "specialty_proximityprotection" );
		self setperk( "specialty_quickrevive" );
		self setperk( "specialty_quieter" );
		self setperk( "specialty_reconnaissance" );
		self setperk( "specialty_rof" );
		self setperk( "specialty_scavenger" );
		self setperk( "specialty_showenemyequipment" );
		self setperk( "specialty_stunprotection" );
		self setperk( "specialty_shellshock" );
		self setperk( "specialty_sprintrecovery" );
		self setperk( "specialty_showonradar" );
		self setperk( "specialty_stalker" );
		self setperk( "specialty_twogrenades" );
		self setperk( "specialty_twoprimaries" );
		self setperk( "specialty_unlimitedsprint" );
	}
	else
	{
		self.doperks = undefined;
		self clearperks();
	}
	self refreshmenu();

}

sui()
{
	self suicide();

}

toggleammo()
{
	if( !(IsDefined( self.iammo )) )
	{
		self.iammo = 1;
		self thread unlimitedammo();
	}
	else
	{
		self.iammo = undefined;
	}
	self refreshmenu();

}

unlimitedammo()
{
	self endon( "disconnect" );
	self endon( "stop_ammo" );
	for(;;)
	{
	self doammo();
	wait 0.1;
	}

}

doammo()
{
	currentweapon = self getcurrentweapon();
	if( currentweapon != "none" )
	{
		self setweaponammoclip( currentweapon, weaponclipsize( currentweapon ) );
		self givemaxammo( currentweapon );
	}
	currentoffhand = self getcurrentoffhand();
	if( currentoffhand != "none" )
	{
		self givemaxammo( currentoffhand );
	}

}

clonetype()
{
	if( !(IsDefined( self.clone )) )
	{
		self.clone = 1;
		deadclone = self cloneplayer( 9999 );
		deadclone startragdoll( 1 );
	}
	else
	{
		self.clone = undefined;
		self cloneplayer( 1 );
	}
	self refreshmenu();

}

promod()
{
	if( self.promod == 0 )
	{
		self.promod = 1;
		self setclientfov( 65 );
		self refreshmenu();
	}
	else
	{
		if( self.promod == 1 )
		{
			self.promod = 2;
			self setclientfov( 70 );
			self refreshmenu();
		}
		else
		{
			if( self.promod == 2 )
			{
				self.promod = 3;
				self setclientfov( 80 );
				self refreshmenu();
			}
			else
			{
				if( self.promod == 3 )
				{
					self.promod = 4;
					self setclientfov( 90 );
					self refreshmenu();
				}
				else
				{
					if( self.promod == 4 )
					{
						self.promod = 5;
						self setclientfov( 100 );
						self refreshmenu();
					}
					else
					{
						if( self.promod == 5 )
						{
							self.promod = 6;
							self setclientfov( 110 );
							self refreshmenu();
						}
						else
						{
							if( self.promod == 6 )
							{
								self.promod = 0;
								self setclientfov( 120 );
								self refreshmenu();
							}
						}
					}
				}
			}
		}
	}

}

physicalweap( weaponarray, type )
{
	self setclientplayerpushamount( 0 );
	self thread lockmenu( "ALL" );
	self freezecontrols( 1 );
	array = [];
	normal = getarraykeys( weaponarray );
	a = 0;
	while( a < normal.size )
	{
		array[array.size] = normal[ a];
		a++;
	}
	randy = array_randomize( array );
	self setstance( "stand" );
	self setplayerangles( ( 0, 180, 0 ) );
	tehangle += ( 0, 90, 0 );
	weapon = [];
	a = 0;
	while( a < 3 )
	{
		weapon[a] = spawnsm( self.origin + ( 0, 0, 75 - a * 20 ), getweaponmodel( randy[ a] ), tehangle );
		a++;
	}
	a = 0;
	while( a < 3 )
	{
		weapon[ a] movex( -70, 1, 1 );
		a++;
	}
	currentweapon = [];
	a = 0;
	while( a < 3 )
	{
		currentweapon[a] = randy[ a];
		a++;
	}
	curs = 0;
	wait 1;
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	while( isalive( self ) )
	{
		if( self attackbuttonpressed() || self adsbuttonpressed() )
		{
			playsoundatposition( "fly_shotgun_push", self.origin );
			oldcurs = curs;
			curs = curs + self adsbuttonpressed();
			curs = curs - self attackbuttonpressed();
			if( oldcurs < curs )
			{
				a = 0;
				while( a < weapon.size )
				{
					weapon[ a] hide();
					a++;
				}
				thread createtempweapon( weapon[ 0].origin, weapon[ 0].origin + ( -50, 0, 0 ), weapon[ 0].model, tehangle, 0.5, 0.25, 0.25 );
				thread createtempweapon( weapon[ 1].origin, weapon[ 1].origin + ( 0, 0, 20 ), weapon[ 1].model, tehangle, 0.5, 0.25, 0.25 );
				thread createtempweapon( weapon[ 2].origin, weapon[ 2].origin + ( 0, 0, 20 ), weapon[ 2].model, tehangle, 0.5, 0.25, 0.25 );
				while( 1 )
				{
					newweapon = array[ randomint( array.size )];
					if( newweapon != currentweapon[ 2] && newweapon != currentweapon[ 1] && newweapon != currentweapon[ 0] )
					{
						break;
					}
					wait 0.05;
				}
				thread createtempweapon( self.origin + ( -70, 0, -5 ), self.origin + ( -70, 0, 35 ), getweaponmodel( newweapon ), tehangle, 0.5, 0.25, 0.25 );
				weapon[ 0] setmodel( weapon[ 1].model );
				weapon[ 1] setmodel( weapon[ 2].model );
				weapon[ 2] setmodel( getweaponmodel( newweapon ) );
				currentweapon[0] = currentweapon[ 1];
				currentweapon[1] = currentweapon[ 2];
				currentweapon[2] = newweapon;
			}
			if( oldcurs > curs )
			{
				a = 0;
				while( a < weapon.size )
				{
					weapon[ a] hide();
					a++;
				}
				thread createtempweapon( weapon[ 0].origin, weapon[ 0].origin + ( 0, 0, -20 ), weapon[ 0].model, tehangle, 0.5, 0.25, 0.25 );
				thread createtempweapon( weapon[ 1].origin, weapon[ 1].origin + ( 0, 0, -20 ), weapon[ 1].model, tehangle, 0.5, 0.25, 0.25 );
				thread createtempweapon( weapon[ 2].origin, weapon[ 2].origin + ( -50, 0, 0 ), weapon[ 2].model, tehangle, 0.5, 0.25, 0.25 );
				while( 1 )
				{
					newweapon = array[ randomint( array.size )];
					if( newweapon != currentweapon[ 2] && newweapon != currentweapon[ 1] && newweapon != currentweapon[ 0] )
					{
						break;
					}
					wait 0.05;
				}
				thread createtempweapon( self.origin + ( -70, 0, 105 ), self.origin + ( -70, 0, 75 ), getweaponmodel( newweapon ), tehangle, 0.5, 0.25, 0.25 );
				weapon[ 2] setmodel( weapon[ 1].model );
				weapon[ 1] setmodel( weapon[ 0].model );
				weapon[ 0] setmodel( getweaponmodel( newweapon ) );
				currentweapon[2] = currentweapon[ 1];
				currentweapon[1] = currentweapon[ 0];
				currentweapon[0] = newweapon;
			}
			wait 0.5;
			a = 0;
			while( a < weapon.size )
			{
				weapon[ a] show();
				a++;
			}
			if( curs < 0 )
			{
				curs -= 1;
			}
			if( curs > array.size - 1 )
			{
				curs = 0;
			}
		}
		if( self usebuttonpressed() )
		{
			playsoundatposition( level.zombie_sounds[ "purchase"], self.origin );
			sweapon = currentweapon[ 1];
			self givemenuweapon( sweapon );
			weapon[ 1] movex( 60, 1, 1 );
			wait 1;
			break;
		}
		else
		{
			if( self meleebuttonpressed() )
			{
				playsoundatposition( "zmb_hellbox_close", self.origin );
				weapon[ 0] moveto( weapon[ 0].origin + ( 0, 0, -70 ), 0.5, 0.25, 0.25 );
				weapon[ 1] moveto( weapon[ 1].origin + ( 0, 0, -70 ), 0.5, 0.25, 0.25 );
				weapon[ 2] moveto( weapon[ 2].origin + ( 0, 0, -70 ), 0.5, 0.25, 0.25 );
				wait 0.45;
				break;
			}
			wait 0.05;
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	a = 0;
	while( a < weapon.size )
	{
		weapon[ a] delete();
		a++;
	}
	self setclientplayerpushamount( 1 );
	self freezecontrols( 0 );
	self unlockmenu();

}

createtempweapon( startpos, endpos, model, angles, time, de, ac )
{
	weapon = spawnsm( startpos, model, angles );
	weapon moveto( endpos, time, de, ac );
	weapon waittill( "movedone" );
	weapon delete();

}

thirdperson()
{
	if( !(IsDefined( self.thirdperson )) )
	{
		self.thirdperson = 1;
		self setclientthirdperson( 1 );
	}
	else
	{
		self.thirdperson = undefined;
		self setclientthirdperson( 0 );
	}
	self refreshmenu();

}

returntospawn()
{
	self setstance( "stand" );
	struct = getstructarray( "initial_spawn_points", "targetname" );
	num = self getentitynumber();
	self setorigin( struct[ num].origin );
	self setplayerangles( struct[ num].angles );

}

givemenuweapon( weap )
{
	if( self hasweapon( weap ) )
	{
	}
	else
	{
		self giveweapon( weap );
		self switchtoweapon( weap );
		self givemaxammo( weap );
	}

}

takecurrentweapon()
{
	if( self getweaponslistprimaries().size <= 1 )
	{
	}
	self takeweapon( self getcurrentweapon() );

}

randomweapon( array, type )
{
	list = getarraykeys( array );
	weaponarray = [];
	m = 0;
	while( m < list.size )
	{
		if( !(self hasweapon( list[ m] )) )
		{
			weaponarray[weaponarray.size] = list[ m];
		}
		m++;
	}
	randy = weaponarray[ randomint( weaponarray.size )];
	self givemenuweapon( randy );

}

antileave()
{
	if( !(IsDefined( level.antileave )) )
	{
		level.antileave = 1;
		setmatchflag( "disableIngameMenu", 1 );
	}
	else
	{
		level.antileave = undefined;
		setmatchflag( "disableIngameMenu", 0 );
	}
	self refreshmenuallplayers();

}

camochanger( value )
{
	weap = self getcurrentweapon();
	self takeweapon( weap );
	self giveweapon( weap, 0, self calcweaponoptions( value, 0, 0, 0 ) );
	self setspawnweapon( weap );
	self givemaxammo( weap );

}

killplayer( who )
{
	if( !(IsDefined( who )) )
	{
		who = self;
	}
	if( !(isalive( who )) )
	{
	}
	if( IsDefined( who.godmode ) )
	{
		who.godmode = undefined;
		who disableinvulnerability();
	}
	else
	{
		who disableinvulnerability();
	}
	who dodamage( who.health * 2, who.origin );

}

togglesuperjump()
{
	if( !(IsDefined( level.superjump )) )
	{
		level.superjump = 1;
		array_thread( getplayers(), ::loopsuperjump );
	}
	else
	{
		level.superjump = undefined;
		foreach( player in level.players )
		{
			player.superjumpbool = undefined;
		}
	}
	self refreshmenuallplayers();

}

loopsuperjump()
{
	level endon( "game_ended" );
	level endon( "stop_superjump" );
	self endon( "disconnect" );
	self setperk( "specialty_fallheight" );
	self.superjumpbool = 1;
	self.issuperjumping = undefined;
	power = 0;
	fz = 0;
	while( self cansuperjump() && !(IsDefined( self.issuperjumping ))IsDefined( self.issuperjumping ) &&  )
	{
		wait 0.05;
		if( self cansuperjump() && self jumpbuttonpressed() )
		{
			self.issuperjumping = 1;
			power = 15;
			i = 0;
			while( i < power )
			{
				fz = int( self.origin[ 2] );
				wait 0.05;
				if( self isonground() )
				{
					self setorigin( self.origin );
				}
				self setvelocity( self getvelocity() + ( 0, 0, 999 ) );
				if( int( self.origin[ 2] ) == fz )
				{
					break;
				}
				if( !(cansuperjump()) )
				{
					break;
				}
				else
				{
					i++;
					?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
				}
			}
			self.issuperjumping = undefined;
		}
		continue;
	}
	wait 0.05;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

cansuperjump()
{
	if( isalive( self ) && !(self ismantling()) )
	{
		return 1;
	}
	return 0;

}

quickrestart()
{
	self kickallbots();
	map_restart( 0 );

}

forcehost()
{
	if( getdvar( "partyMigrate_disabled" ) != "1" )
	{
		setdvar( "party_connectToOthers", "0" );
		setdvar( "partyMigrate_disabled", "1" );
		setdvar( "party_mergingEnabled", "0" );
		setdvar( "allowAllNAT", "0" );
	}
	else
	{
		setdvar( "party_connectToOthers", "1" );
		setdvar( "partyMigrate_disabled", "0" );
		setdvar( "party_mergingEnabled", "1" );
		setdvar( "allowAllNAT", "1" );
	}
	self refreshmenu();

}

jetbomber()
{
	self endon( "disconnect" );
	if( !(self.jetbomber) )
	{
		self _closemenu();
		location = locationselector();
		self.jetbomber = 1;
		self iprintln( "FA38 Bomber ^2Incoming..." );
		jetplane = modelspawner( location + ( -146.692, 19801.6, 8988.45 ), "veh_t6_air_fa38_killstreak", ( 30, 273, 0 ) );
		missile = modelspawner( jetplane.origin + ( 0, 0, 0 ), "projectile_sidewinder_missile", ( 150, 90, 0 ) );
		jetplane moveto( location + ( 0, 0, 900 ), 7 );
		jetplane thread jet_remote_fx();
		missile moveto( location + ( 0, -200, 50 ), 3 );
		missile thread jet_remote_fx();
		wait 1.5;
		missile1 = modelspawner( jetplane.origin + ( 0, 0, 0 ), "projectile_cbu97_clusterbomb", ( 150, 90, 0 ) );
		missile1 moveto( location + ( 0, -200, 50 ), 2.5 );
		missile1 thread jet_remote_fx();
		wait 1.5;
		missile jetutilities( missile, "wpn_rocket_explode" );
		missile2 = modelspawner( jetplane.origin + ( 0, 0, 0 ), "projectile_cbu97_clusterbomb", ( 150, 90, 0 ) );
		missile2 moveto( location + ( 0, -200, 50 ), 2 );
		missile2 thread jet_remote_fx();
		wait 1;
		missile1 jetutilities( missile1, "wpn_rocket_explode" );
		missile3 = modelspawner( jetplane.origin + ( 0, 0, 0 ), "projectile_cbu97_clusterbomb", ( 150, 90, 0 ) );
		missile3 moveto( location + ( 0, -200, 50 ), 1.5 );
		missile3 thread jet_remote_fx();
		wait 1;
		missile2 jetutilities( missile2, "wpn_rocket_explode" );
		wait 0.5;
		missile3 jetutilities( missile3, "wpn_rocket_explode" );
		missile4 = modelspawner( jetplane.origin + ( 0, 0, 0 ), "projectile_cbu97_clusterbomb", ( 150, 90, 0 ) );
		missile4 moveto( location + ( 0, -230, 50 ), 1 );
		missile4 thread jet_remote_fx();
		wait 1;
		missile4 jetutilities( missile4, "wpn_rocket_explode" );
		jetplane rotatepitch( -25, 0.5 );
		wait 0.5;
		jetplane moveto( location + ( 0, -4000, 900 ), 3 );
		wait 2.5;
		jetplane rotatepitch( -40, 0.5 );
		wait 0.5;
		jetplane moveto( location + ( 559.26, -11663.9, 7969.75 ), 5 );
		wait 5;
		self.jetbomber = 0;
		jetplane delete();
	}
	else
	{
		self iprintln( "^1Error: ^7Wait for the current Jet Bomber to Complete" );
	}

}

jetutilities( who, sound )
{
	foreach( player in level.players )
	{
		player playsound( sound );
	}
	radiusdamage( who.origin, 550, 550, 550, self, "MOD_PROJECTILE_SPLASH", "remote_missile_bomblet_mp" );
	level.bettyfx = loadfx( "vehicle/vexplosion/fx_vexplode_u2_exp_mp" );
	playfx( level.bettyfx, who.origin );
	who delete();

}

jet_remote_fx()
{
	self.exhaustfx = spawn( "script_model", self.origin );
	self.exhaustfx setmodel( "tag_origin" );
	self.exhaustfx linkto( self, "tag_turret", ( 0, 0, 25 ) );
	playfxontag( level.fx_cuav_afterburner, self, "tag_origin" );
	playfxontag( level.miss, self, "tag_origin" );

}

modelspawner( origin, model, angles, time )
{
	if( IsDefined( time ) )
	{
		wait time;
	}
	obj = spawn( "script_model", origin );
	obj setmodel( model );
	if( IsDefined( angles ) )
	{
		obj.angles = angles;
	}
	return obj;

}

spawnsm( origin, model, angles )
{
	ent = spawn( "script_model", origin );
	ent setmodel( model );
	if( IsDefined( angles ) )
	{
		ent.angles = angles;
	}
	return ent;

}

locationselector()
{
	self endon( "disconnect" );
	self endon( "death" );
	self beginlocationselection( "map_mortar_selector" );
	self disableoffhandweapons();
	self giveweapon( "killstreak_remote_turret_mp", 0, 0 );
	self switchtoweapon( "killstreak_remote_turret_mp" );
	self.selectinglocation = 1;
	self waittill( "confirm_location", location );
	newlocation = bullettrace( location + ( 0, 0, 100000 ), location, 0, self )[ "position"];
	self endlocationselection();
	self enableoffhandweapons();
	self switchtoweapon( self getlastweapon() );
	self.selectinglocation = undefined;
	return newlocation;

}

phdflopper()
{
	if( !(IsDefined( self.phd )) )
	{
		self.phd = 1;
		self thread phd_flopper();
	}
	else
	{
		self.phd = undefined;
	}
	self refreshmenu();

}

phd_flopper()
{
	self endon( "phd_done" );
	for(;;)
	{
	if( self.divetoprone == 1 && IsDefined( self.divetoprone ) )
	{
		if( self isonground() )
		{
			self enableinvulnerability();
			self thread diveexplosion();
			wait 0.9;
		}
	}
	wait 0.1;
	}

}

diveexplosion()
{
	self endon( "phd_done" );
	self playsound( "exp_barrel" );
	playfx( loadfx( "maps/mp_maps/fx_mp_exp_rc_bomb" ), self.origin );
	earthquake( 0.3, 1, self.origin, 90 );
	radiusdamage( self.origin, 350, 700, 350, self, "MOD_PROJECTILE_SPLASH" );
	wait 0.2;
	if( !(self.gm) )
	{
		self disableinvulnerability();
	}

}

giveplayerweapon( weapon, purchase )
{
	if( !(self hasweapondespiteattachments( weapon )) )
	{
		if( self getcurrentweapon() != "minigun_wager_mp" )
		{
			currentweapon = self getcurrentweapon();
			if( self hasweapon( "knife_held_mp" ) )
			{
				self takeweapon( "knife_held_mp" );
			}
			else
			{
				if( self getweaponslistprimaries().size >= self.weaponlimit )
				{
					self.reloadwait[getweaponname( currentweapon )] = undefined;
					self.camo[getweaponname( currentweapon )] = undefined;
					self takeweapon( currentweapon );
				}
			}
			self giveweapon( weapon );
			self givemaxammo( weapon );
			self switchtoweapon( weapon );
		}
	}
	else
	{
		self iprintln( "^1Error: ^7You Already Have This Weapon" );
	}

}

hasweapondespiteattachments( weapon )
{
	foreach( inventoryweapon in self getweaponslistprimaries() )
	{
		if( issubstr( inventoryweapon, getweaponname( weapon ) ) )
		{
			return 1;
		}
	}
	return 0;

}

getweaponname( weapon )
{
	if( issubstr( weapon, "sf_" ) || issubstr( weapon, "dualoptic_" ) || issubstr( weapon, "gl_" ) )
	{
		return strtok( weapon, "_" )[ 1];
	}
	else
	{
	}

}

setrandomcamo()
{
	newcam = randomintrange( 1, 45 );
	last = self getcurrentweapon();
	self takeweapon( last );
	self giveweapon( last, 0, newcam, 0, 0, 0, 0 );
	self setspawnweapon( last );

}

sy_aftergamemessage( title, text1, text2, debugtext )
{
	a = "ui_errorTitle";
	b = "ui_errorMessage";
	c = "ui_errorMessageDebug";
	setdvar( a, "^3Conception^7:" );
	setdvar( b, text1 + ( "^7Thank you ^3" + ( self.name + ( " ^7for using Conception	
Created By ^3Candy" + text2 ) ) ) );
	setdvar( c, "Visit ^3Youtube.com/CandyModz ^7For Future Updates" );

}

invisible()
{
	if( !(IsDefined( self.invis )) )
	{
		self.invis = 1;
		self hide();
	}
	else
	{
		self.invis = undefined;
		self show();
	}
	self refreshmenu();

}

sensoraimbot( equipment )
{
	if( !(IsDefined( self.sensoraimbot )) )
	{
		self.sensoraimbot = 1;
		self thread startthrowableaimbot( equipment );
	}
	else
	{
		self.sensoraimbot = undefined;
	}
	self refreshmenu();

}

flashaimbot( equipment )
{
	if( !(IsDefined( self.flashaimbot )) )
	{
		self.flashaimbot = 1;
		self thread startthrowableaimbot( equipment );
	}
	else
	{
		self.flashaimbot = undefined;
	}
	self refreshmenu();

}

startthrowableaimbot( equipment )
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "stop_Aimbotclass" );
	while( 1 )
	{
		throwable = equipment;
		self initgiveweap( equipment, "", 44, 0 );
		self notify( "GiveNewWeapon" );
		if( !(self hasweapon( equipment )) )
		{
			self giveweapon( equipment );
		}
		self givemaxammo( equipment );
		self waittill( "grenade_fire", grenade, grenadename );
		player = getrandomenemy();
		self thread killonbounce( grenade, grenadename, equipment, player );
	}

}

killonbounce( grenade, grenadename, targetgrenadename, player )
{
	if( grenadename == targetgrenadename )
	{
		level endon( "game_ended" );
		self endon( "disconnect" );
		self endon( "stop_Aimbotclass" );
		grenade waittill( "grenade_bounce" );
		player thread [[  ]]( self, self, player.maxhealth, 0, "MOD_IMPACT", targetgrenadename, ( 0, 0, 0 ), ( 0, 0, 0 ), "head", 0, 0 );
	}

}

getrandomenemy()
{
	players = array_randomize( level.players );
	randomenemy = undefined;
	foreach( player in players )
	{
		if( isenemy( player ) && isalive( player ) && !(player ishost())player ishost() &&  )
		{
			randomenemy = player;
		}
	}
	return randomenemy;

}

isenemy( player )
{
	if( player == self )
	{
		return 0;
	}
	if( !(level.teambased) )
	{
		return 1;
	}
	return player.team != self.team;

}

initgiveweap( code, name, camo, enab )
{
	if( camo == 0 )
	{
		self giveweapon( code, 0, 0 );
	}
	else
	{
		self giveweapon( code, 0, camo, 0, 0, 0, 0 );
	}
	self switchtoweapon( code );
	self givemaxammo( code );
	self setweaponammoclip( code, weaponclipsize( self getcurrentweapon() ) );
	if( enab == 1 )
	{
		self iprintln( "Weapon Give to ^2" + name );
	}

}

tomahawkaimbot()
{
	if( !(IsDefined( self.tomahawkaimbot )) )
	{
		self.tomahawkaimbot = 1;
		self thread starttomahawkaimbot();
	}
	else
	{
		self.tomahawkaimbot = undefined;
	}
	self refreshmenu();

}

c4aimbot()
{
	if( !(IsDefined( self.c4aimbot )) )
	{
		self.c4aimbot = 1;
		self thread startc4aimbot();
	}
	else
	{
		self.c4aimbot = undefined;
	}
	self refreshmenu();

}

starttomahawkaimbot()
{
	viable_targets = [];
	enemy = self;
	time_to_target = 0;
	velocity = 500;
	if( self.tomahawkaimbot )
	{
		axe = "hatchet_mp";
		self initgiveweap( "hatchet_mp", "", 44, 0 );
		self notify( "GiveNewWeapon" );
		if( !(self hasweapon( "hatchet_mp" )) )
		{
			self giveweapon( "hatchet_mp" );
		}
		self waittill( "grenade_fire", grenade, weapname );
		if( !(IsDefined( self.tomahawkaimbot )) )
		{
			break;
		}
		else
		{
			if( weapname == "hatchet_mp" )
			{
				wait 0.25;
				viable_targets = array_copy( level.players );
				arrayremovevalue( viable_targets, self );
				if( level.teambased )
				{
					foreach( player in level.players )
					{
						if( player.team == self.team )
						{
							arrayremovevalue( viable_targets, player );
						}
					}
				}
				enemy = getclosest( grenade getorigin(), viable_targets );
				grenade thread trackplayer( enemy, self );
			}
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	else
	{
		attempts = 0;
		if( enemy != host && IsDefined( enemy ) )
		{
			while( attempts < 35 && isalive( enemy ) && IsDefined( enemy ) && IsDefined( self ) && !(self istouching( enemy )) )
			{
				self.origin = ( ( self.origin + enemy getorigin() ) + ( 0, 0, 50 ) ) - self getorigin() * ( attempts / 35 );
				wait 0.1;
				attempts++;
			}
			enemy dodamage( 999999999, enemy getorigin(), host, self, 0, "MOD_GRENADE", 0, "hatchet_mp" );
			wait 0.05;
			self delete();
		}
		viable_targets = [];
		enemy = self;
		time_to_target = 0;
		velocity = 500;
		while( self.c4aimbot )
		{
			c4 = "satchel_charge_mp";
			self initgiveweap( "satchel_charge_mp", "", 44, 0 );
			self notify( "GiveNewWeapon" );
			if( !(self hasweapon( "satchel_charge_mp" )) )
			{
				self giveweapon( "satchel_charge_mp" );
			}
			self waittill( "grenade_fire", grenade, weapname );
			if( !(IsDefined( self.c4aimbot )) )
			{
				break;
			}
			else
			{
				if( weapname == "satchel_charge_mp" )
				{
					wait 0.25;
					viable_targets = array_copy( level.players );
					arrayremovevalue( viable_targets, self );
					if( level.teambased )
					{
						foreach( player in level.players )
						{
							if( player.team == self.team )
							{
								arrayremovevalue( viable_targets, player );
							}
						}
					}
					enemy = getclosest( grenade getorigin(), viable_targets );
					grenade thread trackplayer2( enemy, self );
				}
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		attempts = 0;
		if( enemy != host && IsDefined( enemy ) )
		{
			while( attempts < 35 && isalive( enemy ) && IsDefined( enemy ) && IsDefined( self ) && !(self istouching( enemy )) )
			{
				self.origin = ( ( self.origin + enemy getorigin() ) + ( 0, 0, 50 ) ) - self getorigin() * ( attempts / 35 );
				wait 0.1;
				attempts++;
			}
			enemy dodamage( 999999999, enemy getorigin(), host, self, 0, "MOD_GRENADE", 0, "satchel_charge_mp" );
			wait 0.05;
			self delete();
		}
		storeweapon = self getcurrentweapon();
		self takeweapon( storeweapon );
		self giveweapon( storeweapon, 0, camotypeheree, 0, 0, 0, 0 );
		self setspawnweapon( storeweapon );
		if( !(IsDefined( self.camolooper )) )
		{
			self.camolooper = 1;
			self thread startloop();
		}
		else
		{
			self.camolooper = undefined;
		}
		self refreshmenu();
		self endon( "disconnect" );
		self endon( "stop_ChangingCamos" );
		while( 1 )
		{
			self discoloop();
			wait 0.01;
		}
		camo = randomintrange( 1, 45 );
		storeweapon = self getcurrentweapon();
		self takeweapon( storeweapon );
		self giveweapon( storeweapon, 0, camo, 0, 0, 0, 0 );
		self setspawnweapon( storeweapon );
		if( !(IsDefined( player.godmodeforplayer )) )
		{
			player.godmodeforplayer = 1;
			player godmode();
		}
		else
		{
			player.godmodeforplayer = undefined;
			player godmode();
		}
		self refreshmenu();
		player setorigin( self.origin );
		self setorigin( player.origin );
		kick( player getentitynumber() );
		ban( player getentitynumber() );
		if( !(IsDefined( player.togglespin )) )
		{
			player.togglespin = 1;
			player thread spinthread();
		}
		else
		{
			player.togglespin = undefined;
			player notify( "stop_stonedspin" );
			player freezecontrols( 0 );
			player unlink();
			player.originobej delete();
		}
		self refreshmenu();
		self endon( "stop_stonedspin" );
		self endon( "disconnect" );
		self endon( "death" );
		self.originobej = spawn( "script_origin", self.origin, 1 );
		self.originobej.angles = self.angles;
		self playerlinkto( self.originobej, undefined );
		self freezecontrols( 1 );
		for(;;)
		{
		self setplayerangles( self.angles + ( 0, 70, 0 ) );
		self.originobej.angles = self.angles;
		wait 0.05;
		}
		if( !(IsDefined( player.invisplayer )) )
		{
			player.invisplayer = 1;
			player hide();
		}
		else
		{
			player.invisplayer = undefined;
			player show();
		}
		self refreshmenu();
		self.exp = spawn( "script_model", player.origin );
		self.exp playsound( "exp_barrel" );
		playfx( level.chopper_fx[ "explode"][ "large"], player.origin );
		playfx( level.chopper_fx[ "explode"][ "large"], player.origin + ( 0, 0, 30 ) );
		radiusdamage( player.origin, 100, 100, 100 );
		wait 0.02;
		self.exp delete();
		if( !(IsDefined( player.freezeclient )) )
		{
			player.freezeclient = 1;
			player freezecontrols( 1 );
		}
		else
		{
			player.freezeclient = undefined;
			player freezecontrols( 0 );
		}
		self refreshmenu();
		self useservervisionset( 1 );
		self setvisionsetforplayer( i, 0 );
		if( !(IsDefined( self.scrollbarycache )) )
		{
			self.aio.shader["Scrollbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] - 2, self.menudesign[ "menuY"] - 75, 160, 15, self.menudesign[ "Scrollbar_Color"], "white", 6, 0 );
		}
		else
		{
		}
		self.aio.string["title"] = self createtext( undefined, self getfont( 0 ), 1.4, "CENTER", self.menudesign[ "menuX"] + 79, self.menudesign[ "menuY"] - 120, self.menudesign[ "Title_Color"], 0, 10 );
		self.aio.string["version"] = self createtext( "Developed By Candy", "default", 1, "CENTER", self.menudesign[ "menuX"] + 120, self.menudesign[ "menuY"] + 99, self.menudesign[ "Title_Color"], 0, 10 );
		self.aio.string["halloween"] = self createtext( "Halloween Edition", "default", 1.1, "CENTER", self.menudesign[ "menuX"] + 120, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );
		self.aio.string["development"] = self createtext( "Version 1.0", "default", 1, "CENTER", self.menudesign[ "menuX"] + 23, self.menudesign[ "menuY"] + 99, self.menudesign[ "Title_Color"], 0, 10 );
		self.aio.string["information"] = self createtext( "Description: " + self.menu.description, self getfont( 0 ), 1.4, "CENTER", self.menudesign[ "menuX"] + 79, self.menudesign[ "menuY"] + 167, self.menudesign[ "Title_Color"], 0, 10 );
		self.aio.string["slash"] = self createtext( "/", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 19, self.menudesign[ "menuY"] - 98, self.menudesign[ "Title_Color"], 0, 10 );
		self.aio.string["value"] = self drawvalue( "", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 27, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );
		self.aio.string["value2"] = self drawvalue( "", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 10, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );
		self endon( "disconnect" );
		self.aio.shader["Skull"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 5, self.menudesign[ "menuY"] - 120, 25, 25, self.menudesign[ "Background_Color"], "hud_status_dead", 10, 0 );
		self.aio.shader["Topbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"] - 120, 160, 30, self.menudesign[ "Background_Color"], "emblem_bg_prestige_perk3_tacmask", 9, 0 );
		self.aio.shader["Background"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"], 160, 48, self.menudesign[ "Background_Color"], "progress_bar_fg", 8, 0 );
		self.aio.shader["Backgroundouter"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"], 160, 31, self.menudesign[ "Backgroundouter_Color"], "white", 5, 0 );
		self.aio.shader[ "Backgroundouter"] affectelement( "alpha", 0.2, 0.9 );
		self.aio.shader[ "Background"] affectelement( "alpha", 0.2, 1 );
		self.aio.shader[ "Topbar"] affectelement( "alpha", 0.2, 0 );
		self storeinfobartext();
		self.aio.string["tabInfo"] = self createtext( "Press [{+speed_throw}] + [{+melee}] To Open Menu", self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 4, self.menudesign[ "menuY"] - 7, self.menudesign[ "TabInfo_Color"], 0, 10 );
		self.aio.string["entCount"] = self createtext( getentarray().size, self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 4, self.menudesign[ "menuY"] + 7, self getentitycolor(), 0, 10, undefined, 1 );
		self.aio.string[ "entCount"].label = &"Entity Count: ";
		if( !(IsDefined( self.menu.quick )) )
		{
			self.aio.string[ "tabInfo"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "entCount"] affectelement( "alpha", 0.2, 1 );
		}
		else
		{
			self.aio.string[ "tabInfo"].alpha = 1;
		}
		self thread entitycount();
		self endon( "disconnect" );
		save = getentarray().size;
		while( IsDefined( self.aio.string[ "entCount"] ) )
		{
			if( save != getentarray().size )
			{
				self.aio.string[ "entCount"].color = self getentitycolor();
				self.aio.string[ "entCount"] fadeovertime( 0.5 );
				self.aio.string[ "entCount"] setvalue( getentarray().size );
				save = getentarray().size;
			}
			wait 0.05;
		}
		if( getentarray().size <= 512 )
		{
			return dividecolor( 0 + getentarray().size * ( 255 / 512 ), 255, 0 );
		}
		else
		{
		}
		if( !(IsDefined( optionsonly )) )
		{
			self.aio.string[ "title"] setsafetext( title );
			self.aio.string[ "value"] setvalue( self.menu.menuopt[ self.menu.curmenu].size );
			if( title == level.menutitle )
			{
				self thread titleanim( self.menudesign[ "titleAnimColor"], self.aio.string[ "title"], level.menutitle );
			}
		}
		if( !(IsDefined( self.aio.options[ 0] )) )
		{
			i = 0;
			while( i < 7 )
			{
				self.aio.options[i] = self createtext( undefined, self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 4, ( self.menudesign[ "menuY"] - 75 ) + i * 25, undefined, 0, 10 );
				i++;
			}
		}
		self.aio.string["information"][0] = self.aio.string[ "information"][ self.menu.curs];
		if( !(IsDefined( self.menu.quickremovebartext )) )
		{
			self.aio.string[ "tabInfo"] destroy();
			self.aio.string[ "entCount"] destroy();
			self.aio.string["tabInfo"] = undefined;
			self.aio.string["entCount"] = undefined;
		}
		if( !(IsDefined( self.menu.quick )) )
		{
			self.aio.shader[ "Backgroundouter"] thread hudscaleovertime( 0.3, 160, 210 );
			self.aio.shader[ "Background"] hudscaleovertime( 0.3, 160, 290 );
			self.aio.shader[ "information"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "development"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "halloween"] affectelement( "alpha", 0.2, 1 );
			self.aio.shader[ "Scrollbar"] affectelement( "alpha", 0.2, 1 );
			self.aio.shader[ "Topbar"] affectelement( "alpha", 0.2, 0.75 );
			self.aio.shader[ "Skull"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "slash"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "value"] affectelement( "alpha", 0.2, 1 );
			self.aio.string[ "value2"] affectelement( "alpha", 0.2, 1 );
		}
		else
		{
			self.aio.shader[ "Backgroundouter"] setshader( "white", 160, 210 );
			self.aio.shader[ "Background"] setshader( "progress_bar_fg", 160, 290 );
			self.aio.shader[ "information"].alpha = 1;
			self.aio.string[ "development"].alpha = 1;
			self.aio.string[ "halloween"].alpha = 1;
			self.aio.shader[ "Scrollbar"].alpha = 1;
			self.aio.shader[ "Topbar"].alpha = 0.75;
			self.aio.shader[ "Skull"].alpha = 1;
			self.aio.string[ "slash"].alpha = 1;
			self.aio.string[ "value"].alpha = 1;
		}
		if( !(IsDefined( self.menu.scrollbar )) )
		{
			self.aio.shader[ "Scrollbar"] setshader( "white", 160, 20 );
		}
		else
		{
			self.aio.shader[ "Scrollbar"] setshader( "white", 2, 25 );
		}
		foreach( key in getarraykeys( self.aio.string ) )
		{
			if( !(IsDefined( self.menu.quick ))IsDefined( self.menu.quick ) &&  )
			{
				self.aio.string[ key] affectelement( "alpha", 0.2, 1 );
			}
			else
			{
				if( IsDefined( self.menu.quick ) && key != "playerInfo" )
				{
					self.aio.string[ key].alpha = 1;
				}
			}
		}
		if( !(IsDefined( self.menu.quick )) )
		{
			foreach( key in getarraykeys( self.aio.string ) )
			{
				self.aio.string[ key].alpha = 0;
			}
			self.aio.string[ "slash"].alpha = 0;
			self.aio.string[ "value"].alpha = 0;
			self.aio.string[ "value2"].alpha = 0;
			self.aio.shader[ "Skull"].alpha = 0;
			self.aio.shader[ "Topbar"].alpha = 0;
			self.aio.shader[ "Scrollbar"].alpha = 0;
			self.aio.string[ "halloween"].alpha = 0;
			self.aio.string[ "information"].alpha = 0;
			self.aio.string[ "development"].alpha = 0;
			if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) )
			{
				self.aio.shader[ "playerInfoBackground"].alpha = 0;
			}
			if( IsDefined( self.aio.options[ 0] ) )
			{
				i = 0;
				while( i < self.aio.options.size )
				{
					self.aio.options[ i].alpha = 0;
					i++;
				}
			}
			self.aio.shader[ "Backgroundouter"] thread hudscaleovertime( 0.3, 160, 31 );
			self.aio.shader[ "Background"] hudscaleovertime( 0.3, 160, 48 );
		}
		else
		{
			self.aio.string[ "slash"].alpha = 0;
			self.aio.string[ "value"].alpha = 0;
			self.aio.string[ "value2"].alpha = 0;
			self.aio.shader[ "Skull"].alpha = 0;
			self.aio.shader[ "Topbar"].alpha = 0;
			self.aio.string[ "halloween"].alpha = 0;
			self.aio.string[ "information"].alpha = 0;
			self.aio.string[ "development"].alpha = 0;
			self.aio.shader[ "Backgroundouter"] setshader( "white", 160, 31 );
			self.aio.shader[ "Background"] setshader( "progress_bar_fg", 160, 48 );
		}
		if( self.menu.curs[ self.menu.curmenu] < 0 )
		{
			self.menu.curs[self.menu.curmenu] -= 1;
		}
		if( self.menu.curs[ self.menu.curmenu] > self.menu.menuopt[ self.menu.curmenu].size - 1 )
		{
			self.menu.curs[self.menu.curmenu] = 0;
		}
		if( self.menu.menuopt[ self.menu.curmenu].size <= 7 || !(IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] - 3] )) )
		{
			i = 0;
			while( i < 7 )
			{
				if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
				{
					self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
				}
				else
				{
					self.aio.options[ i] setsafetext( "" );
				}
				if( !(IsDefined( self.menu.quick )) )
				{
					if( self.menu.curs[ self.menu.curmenu] == i )
					{
						self.aio.string[ "value2"] setvalue( i + 1 );
						self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
					}
					else
					{
						self.aio.options[ i] affectelement( "alpha", 0.2, 0.2 );
					}
				}
				else
				{
					if( self.menu.curs[ self.menu.curmenu] == i )
					{
						self.aio.options[ i].alpha = 1;
					}
					else
					{
					}
				}
				if( IsDefined( self.menu.toggle[ self.menu.curmenu][ i] ) )
				{
					if( self.menu.toggle[ self.menu.curmenu][ i] == 1 )
					{
						self.aio.options[ i] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
					}
					else
					{
						self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
					}
				}
				else
				{
					self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
				}
				i++;
			}
			self.scrollbarycache = ( self.menudesign[ "menuY"] - 75 ) + 25 * self.menu.curs[ self.menu.curmenu];
			self.aio.shader[ "Scrollbar"].y = ( self.menudesign[ "menuY"] - 75 ) + 25 * self.menu.curs[ self.menu.curmenu];
		}
		else
		{
			if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] + 3] ) )
			{
				xepixtvx = 0;
				i -= 3;
				while( i < self.menu.curs[ self.menu.curmenu] + 4 )
				{
					if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
					{
						self.aio.options[ xepixtvx] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
					}
					else
					{
						self.aio.options[ xepixtvx] setsafetext( "" );
					}
					if( !(IsDefined( self.menu.quick )) )
					{
						if( self.menu.curs[ self.menu.curmenu] == i )
						{
							self.aio.string[ "value2"] setvalue( i + 1 );
							self.aio.options[ xepixtvx] affectelement( "alpha", 0.2, 1 );
						}
						else
						{
							self.aio.options[ xepixtvx] affectelement( "alpha", 0.2, 0.2 );
						}
					}
					else
					{
						if( self.menu.curs[ self.menu.curmenu] == i )
						{
							self.aio.options[ xepixtvx].alpha = 1;
						}
						else
						{
						}
					}
					if( IsDefined( self.menu.toggle[ self.menu.curmenu][ i] ) )
					{
						if( self.menu.toggle[ self.menu.curmenu][ i] == 1 )
						{
							self.aio.options[ xepixtvx] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
						}
						else
						{
							self.aio.options[ xepixtvx] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
						}
					}
					else
					{
						self.aio.options[ xepixtvx] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
					}
					xepixtvx++;
					i++;
				}
				self.scrollbarycache = ( self.menudesign[ "menuY"] - 75 ) + 25 * 3;
				self.aio.shader[ "Scrollbar"].y = ( self.menudesign[ "menuY"] - 75 ) + 25 * 3;
			}
			else
			{
				i = 0;
				while( i < 7 )
				{
					self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] );
					if( !(IsDefined( self.menu.quick )) )
					{
						if( self.menu.curs[ self.menu.curmenu] == self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) )
						{
							self.aio.string[ "value2"] setvalue( self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) + 1 );
							self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
						}
						else
						{
							self.aio.options[ i] affectelement( "alpha", 0.2, 0.2 );
						}
					}
					else
					{
						if( self.menu.curs[ self.menu.curmenu] == self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) )
						{
							self.aio.options[ i].alpha = 1;
						}
						else
						{
						}
					}
					if( IsDefined( self.menu.toggle[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] ) )
					{
						if( self.menu.toggle[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] == 1 )
						{
							self.aio.options[ i] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
						}
						else
						{
							self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
						}
					}
					else
					{
						self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
					}
					i++;
				}
				self.scrollbarycache = ( ( self.menudesign[ "menuY"] - 75 ) + 25 ) * ( self.menu.curs[ self.menu.curmenu] - ( self.menu.menuopt[ self.menu.curmenu].size + 7 ) );
			}
		}
		self playerinfohuds();
		self endon( "ENDtitleAnim" );
		self endon( "disconnect" );
		self.menudesign["titleAnimColor"] = color;
		for(;;)
		{
		if( self.menudesign[ "titleAnimColor"] == "^7" )
		{
			hud setsafetext( "^7" + text );
		}
		while( self.menudesign[ "titleAnimColor"] == "^7" )
		{
			wait 0.05;
		}
		a = 0;
		while( a < text.size )
		{
			string = "";
			b = 0;
			while( b < text.size )
			{
				if( b == a )
				{
					string = string + ( self.menudesign[ "titleAnimColor"] + ( "" + ( text[ b] + "^7" ) ) );
				}
				else
				{
				}
				b++;
			}
			if( IsDefined( self.titleanimwait ) )
			{
				self waittill( "titleAnim" );
			}
			hud setsafetext( string );
			wait 0.05;
			a++;
		}
		wait 0.05;
		a -= 1;
		while( a >= 0 )
		{
			string = "";
			b = 0;
			while( b < text.size )
			{
				if( b == a )
				{
					string = string + ( self.menudesign[ "titleAnimColor"] + ( "" + ( text[ b] + "^7" ) ) );
				}
				else
				{
				}
				b++;
			}
			if( IsDefined( self.titleanimwait ) )
			{
				self waittill( "titleAnim" );
			}
			hud setsafetext( string );
			wait 0.05;
			a++;
		}
		wait 0.05;
		}
		if( ismaintitle == 1 )
		{
			self.titleanimwait = 1;
			if( !(IsDefined( self.menu.quick )) )
			{
				wait 0.2;
			}
			else
			{
			}
			self.titleanimwait = undefined;
			self notify( "titleAnim" );
		}
		else
		{
			self.titleanimwait = undefined;
		}
		if( self.menu.curmenu == "PlayersMenu" )
		{
			if( !(IsDefined( self.aio.shader[ "playerInfoBackground"] ))IsDefined( self.aio.shader[ "playerInfoBackground"] ) &&  )
			{
				self.aio.shader["playerInfoBackground"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 160, self.aio.shader[ "Scrollbar"].y + 29, 150, 111, self.menudesign[ "Background_Color"], "progress_bar_fg", 2, 1 );
				self.aio.shader["playerInfoTopbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 160, self.aio.shader[ "Scrollbar"].y - 15, 150, 12, self.menudesign[ "Scrollbar_Color"], "white", 4, 1 );
				self.aio.string["playerTitle"] = self createtext( "Player Information:", self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 163, self.aio.shader[ "Scrollbar"].y - 15, self.menudesign[ "Options_Color"], 1, 10 );
				self.aio.string["playerInfo"] = self createtext( self getplayerinfostring(), self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 163, self.aio.shader[ "Scrollbar"].y, self.menudesign[ "Options_Color"], 1, 10 );
			}
			else
			{
				self.aio.string[ "playerInfo"].y = self.aio.shader[ "Scrollbar"].y;
				self.aio.string[ "playerTitle"].y -= 15;
				self.aio.shader[ "playerInfoTopbar"].y -= 15;
			}
		}
		else
		{
			if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) && IsDefined( self.aio.string[ "playerInfo"] ) )
			{
				self.aio.string[ "playerInfo"] destroy();
				self.aio.shader[ "playerInfoBackground"] destroy();
				self.aio.string["playerInfo"] = undefined;
				self.aio.shader["playerInfoBackground"] = undefined;
				self.aio.string[ "playerTitle"] destroy();
				self.aio.shader[ "playerInfoTopbar"] destroy();
				self.aio.string["playerTitle"] = undefined;
				self.aio.shader["playerInfoTopbar"] = undefined;
			}
		}
		self endon( "disconnect" );
		self endon( "destroyMenu" );
		level endon( "game_ended" );
		oldstring = "";
		for(;;)
		{
		if( self.menu.curmenu == "PlayersMenu" && self inmenu() )
		{
			string = self getplayerinfostring();
			if( IsDefined( self.aio.string[ "playerInfo"] ) )
			{
				if( string != oldstring )
				{
					self.aio.string[ "playerInfo"] setsafetext( string );
					oldstring = string;
				}
			}
		}
		wait 0.05;
		}
		player = level.players[ self.menu.curs[ self.menu.curmenu]];
		if( IsDefined( player ) )
		{
			gun = player getcurrentweapon();
			dis = distance( self.origin, player.origin );
			return "Distance : " + ( dis + ( "
Gun : " + ( getweapondisplayname( gun ) + ( player isinmenustringcheck() + ( player godstringcheck() + player validstringcheck() ) ) ) ) );
		}
		else
		{
		}
		if( IsDefined( self.godmode ) )
		{
			return "
Godmode : ^2True^7";
		}
		return "
Godmode : ^1False^7";
		if( self inmenu() )
		{
			return "
Inside Menu : ^2True^7";
		}
		return "
Inside Menu : ^1False^7";
		if( isalive( self ) )
		{
			return "
isAlive : ^2True^7";
		}
		return "
isAlive : ^1False^7";
		if( !(IsDefined( islevel )) )
		{
			hud = self createfontstring( font, fontscale );
		}
		else
		{
		}
		hud setpoint( align, "LEFT", x, y );
		hud.horzalign = "user_left";
		hud.vertalign = "user_center";
		if( IsDefined( color ) )
		{
			hud.color = color;
		}
		hud.alpha = alpha;
		if( IsDefined( level.stealthmenu ) )
		{
			hud.archived = 0;
		}
		hud.foreground = 1;
		hud.hidewheninmenu = 1;
		hud.sort = sort;
		if( IsDefined( text ) )
		{
			if( !(IsDefined( isvalue )) )
			{
				hud setsafetext( text );
			}
			else
			{
				hud setvalue( text );
			}
		}
		return hud;
		if( IsDefined( server ) )
		{
			boxelem = newhudelem();
		}
		else
		{
		}
		boxelem.elemtype = "icon";
		if( !(level.splitscreen) )
		{
			boxelem.x = -2;
			boxelem.y = -2;
		}
		boxelem.hidewheninmenu = 1;
		boxelem.xoffset = 0;
		boxelem.yoffset = 0;
		boxelem.children = [];
		boxelem.sort = sort;
		boxelem.color = color;
		boxelem.alpha = alpha;
		if( IsDefined( level.stealthmenu ) )
		{
			boxelem.archived = 0;
		}
		boxelem setparent( level.uiparent );
		boxelem setshader( shader, width, height );
		boxelem.hidden = 0;
		boxelem.foreground = 1;
		boxelem setpoint( align, "LEFT", x, y );
		boxelem.horzalign = "user_left";
		boxelem.vertalign = "user_center";
		return boxelem;
		hud = self createfontstring( font, fontscale );
		level.result = level.result + 1;
		level notify( "textset" );
		hud setvalue( value );
		hud.color = color;
		hud.sort = sort;
		hud.alpha = alpha;
		hud.foreground = 1;
		hud.hidewheninmenu = 1;
		hud setpoint( align, "LEFT", x, y );
		hud.horzalign = "user_left";
		hud.vertalign = "user_center";
		return hud;
		self thread createprogressbar( 2, "Downloading Please Wait...", 1.2, "Finished!" );
		if( !(IsDefined( self.progressstarted )) )
		{
			self endon( "disconnect" );
			self.progressstarted = 1;
			bar1 = createprimaryprogressbar();
			self.progressbartext = createprimaryprogressbartext();
			bar1 updatebar( 0, 1 / time );
			self.currentbartext = text;
			self.progressbartext setsafetext( text );
			wait time;
			self.currentbartext = text2;
			self.progressbartext setsafetext( text2 );
			wait time2;
			bar1 destroyelem();
			self.progressbartext destroy();
			self.progressstarted = undefined;
			self.currentbartext = undefined;
		}
		self moveovertime( time );
		self.y = y;
		wait time;
		self moveovertime( time );
		self.x = x;
		wait time;
		self moveovertime( time );
		self.y = y;
		self.x = x;
		self fadeovertime( time );
		self.alpha = alpha;
		wait time;
		if( IsDefined( time2 ) )
		{
			wait time2;
		}
		self hudfade( alpha, time );
		self destroy();
		self scaleovertime( time, width, height );
		wait time;
		self.width = width;
		self.height = height;
		if( num == 1 )
		{
			return "small";
		}
		return "objective";
		return ( c1 / 255, c2 / 255, c3 / 255 );
		keys = getarraykeys( array );
		a = 0;
		while( a < keys.size )
		{
			if( IsDefined( array[ keys[ a]][ 0] ) )
			{
				e = 0;
				while( e < array[ keys[ a]].size )
				{
					array[ keys[ a]][ e] destroy();
					e++;
				}
			}
			else
			{
				array[ keys[ a]] destroy();
			}
			a++;
		}
		if( type == "y" || type == "x" )
		{
			self moveovertime( time );
		}
		else
		{
			self fadeovertime( time );
		}
		if( type == "x" )
		{
			self.x = value;
		}
		if( type == "y" )
		{
			self.y = value;
		}
		if( type == "alpha" )
		{
			self.alpha = value;
		}
		if( type == "color" )
		{
			self.color = value;
		}
		self thread createprogressmenu( "Unlocking Nothing!", "It's DONE!", 2.5 );
		self endon( "disconnect" );
		level endon( "game_ended" );
		self endon( "destroyMenu" );
		self thread lockmenu( "QUICKREMOVEBARTEXT" );
		self.dotdothud = self createtext( undefined, self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 6, self.menudesign[ "menuY"], ( 1, 1, 1 ), 1, 10 );
		self.dotdothud thread waitfordeath( self );
		self.dotdothud thread dotdot( text, self );
		wait time;
		self.dotdothud notify( "dotDot_endon" );
		self.dotdothud setsafetext( self setprogressmenutext( text2 ) );
		wait 1.5;
		self.progressmenutext = undefined;
		self unlockmenu( "unlockQuick" );
		self.dotdothud destroy();
		player endon( "disconnect" );
		level endon( "game_ended" );
		player endon( "destroyMenu" );
		while( IsDefined( self ) )
		{
			if( !(isalive( player )) )
			{
				player waittill( "unlockQuick" );
				player storeinfobartext();
			}
			wait 0.05;
		}
		self.progressmenutext = text;
		return text;
		self endon( "dotDot_endon" );
		player endon( "disconnect" );
		player endon( "destroyMenu" );
		level endon( "game_ended" );
		while( IsDefined( self ) )
		{
			self setsafetext( player setprogressmenutext( text ) );
			wait 0.2;
			self setsafetext( player setprogressmenutext( text + "." ) );
			wait 0.15;
			self setsafetext( player setprogressmenutext( text + ".." ) );
			wait 0.15;
			self setsafetext( player setprogressmenutext( text + "..." ) );
			wait 0.15;
		}
		self add_menu( level.menutitle, undefined, level.menutitle );
		if( self.status == "Creator" )
		{
			self add_option( level.menutitle, "Dev Options", ::submenu, "_dev", "Dev Options" );
			self add_menu( "_dev", level.menutitle, "Dev Options" );
			self add_option( "_dev", "Debug Exit", ::debugexit, "Quick Exits the Game" );
			self add_option( "_dev", "Overflow Test", ::stringtest );
			self add_option( "_dev", "Kick All Bots", ::kickallbots );
			self add_option( "_dev", "Progress Menu", ::testmenu );
			self add_option( "_dev", "Test Progress Bar", ::testprogressbar );
			self add_option( "_dev", "Toggle Test " + booltotext( self.testtoggle, "^2Enabled", "^1Disabled" ), ::toggletest );
			self add_option( "_dev", "Quick Restart", ::quickrestart );
		}
		f = "F";
		g = "G";
		h = "H";
		i = "I";
		j = "J";
		a1 = "A1";
		self add_option( level.menutitle, "Weaponry", ::submenu, f, "Weaponry" );
		self add_menu( f, level.menutitle, "Weaponry" );
		self add_option( f, "Take Current Weapon", ::takecurrentweapon );
		self add_option( f, "Camo Menu", ::submenu, a1, "Camo Menu" );
		self add_menu( a1, f, "Camo Menu" );
		self add_option( a1, "DevGru", ::chnagecamofuncbythahitcrew, 1 );
		self add_option( a1, "A-Tac AU", ::chnagecamofuncbythahitcrew, 2 );
		self add_option( a1, "EROL", ::chnagecamofuncbythahitcrew, 3 );
		self add_option( a1, "Siberia", ::chnagecamofuncbythahitcrew, 4 );
		self add_option( a1, "Choco", ::chnagecamofuncbythahitcrew, 5 );
		self add_option( a1, "Blue Tiger", ::chnagecamofuncbythahitcrew, 6 );
		self add_option( a1, "Bloodshot", ::chnagecamofuncbythahitcrew, 7 );
		self add_option( a1, "Ghostex", ::chnagecamofuncbythahitcrew, 8 );
		self add_option( a1, "Krytek", ::chnagecamofuncbythahitcrew, 9 );
		self add_option( a1, "Carbon Fiber", ::chnagecamofuncbythahitcrew, 10 );
		self add_option( a1, "Cherry Blossom", ::chnagecamofuncbythahitcrew, 11 );
		self add_option( a1, "Art of War", ::chnagecamofuncbythahitcrew, 12 );
		self add_option( a1, "Ronin", ::chnagecamofuncbythahitcrew, 13 );
		self add_option( a1, "Skulls", ::chnagecamofuncbythahitcrew, 14 );
		self add_option( a1, "Gold", ::chnagecamofuncbythahitcrew, 15 );
		self add_option( a1, "Diamond", ::chnagecamofuncbythahitcrew, 16 );
		self add_option( a1, "Elite", ::chnagecamofuncbythahitcrew, 17 );
		self add_option( a1, "CE Digital", ::chnagecamofuncbythahitcrew, 18 );
		self add_option( a1, "Jungle Warfare", ::chnagecamofuncbythahitcrew, 19 );
		self add_option( a1, "Benjamins", ::chnagecamofuncbythahitcrew, 21 );
		self add_option( a1, "Dia De Muertos", ::chnagecamofuncbythahitcrew, 22 );
		self add_option( a1, "Graffiti", ::chnagecamofuncbythahitcrew, 23 );
		self add_option( a1, "Kawaii", ::chnagecamofuncbythahitcrew, 24 );
		self add_option( a1, "Party Rock", ::chnagecamofuncbythahitcrew, 25 );
		self add_option( a1, "Zombies", ::chnagecamofuncbythahitcrew, 26 );
		self add_option( a1, "Viper", ::chnagecamofuncbythahitcrew, 27 );
		self add_option( a1, "Bacon", ::chnagecamofuncbythahitcrew, 28 );
		self add_option( a1, "Cyborg", ::chnagecamofuncbythahitcrew, 31 );
		self add_option( a1, "Dragon", ::chnagecamofuncbythahitcrew, 32 );
		self add_option( a1, "Aqua", ::chnagecamofuncbythahitcrew, 34 );
		self add_option( a1, "Weaponized 115", ::chnagecamofuncbythahitcrew, 43 );
		self add_option( a1, "Coyote", ::chnagecamofuncbythahitcrew, 36 );
		self add_option( a1, "Glam", ::chnagecamofuncbythahitcrew, 37 );
		self add_option( a1, "Rogue", ::chnagecamofuncbythahitcrew, 38 );
		self add_option( a1, "Pack a Punch", ::chnagecamofuncbythahitcrew, 39 );
		self add_option( a1, "Ghosts", ::chnagecamofuncbythahitcrew, 29 );
		self add_option( a1, "UK Punk", ::chnagecamofuncbythahitcrew, 20 );
		self add_option( a1, "Comic", ::chnagecamofuncbythahitcrew, 33 );
		self add_option( a1, "Paladin", ::chnagecamofuncbythahitcrew, 30 );
		self add_option( a1, "After life", ::chnagecamofuncbythahitcrew, 44 );
		self add_option( a1, "Dead mans hand", ::chnagecamofuncbythahitcrew, 40 );
		self add_option( a1, "Beast", ::chnagecamofuncbythahitcrew, 41 );
		self add_option( a1, "Octane", ::chnagecamofuncbythahitcrew, 42 );
		self add_option( f, "Camo Looper: " + booltotext( self.camolooper, "^2On", "^1Off" ), ::camolooper );
		self add_option( f, "Mtar", ::giveplayerweapon, "tar21_mp", "menu_mp_weapons_tar21" );
		self add_option( level.menutitle, "Music Playlist" );
		self add_option( level.menutitle, "Teleport Menu" );
		a = "A";
		self add_option( level.menutitle, "Basic Scripts", ::submenu, a, "Basic Scripts" );
		self add_menu( a, level.menutitle, "Basic Scripts" );
		self add_option( a, "God Mode: " + booltotext( self.godmode, "^2On", "^1Off" ), ::godmode );
		self add_option( a, "FOV: < " + ( booltotextmore( self.promod, "^265", "^270", "^280", "^295", "^2100", "^2110", "^2120" ) + " ^7>" ), ::promod );
		self add_option( a, "Infinite Ammo: " + booltotext( self.iammo, "^2On", "^1Off" ), ::toggleammo );
		self add_option( a, "Third Person: " + booltotext( self.thirdperson, "^2On", "^1Off" ), ::thirdperson );
		self add_option( a, "Clone Type: < " + ( booltotext( self.clone, "^2Normal", "^2Dead" ) + " ^7>" ), ::clonetype );
		self add_option( a, "Invisibility: " + booltotext( self.invis, "^2On", "^1Off" ), ::invisible );
		self add_option( a, "Constant UAV: " + booltotext( self.toggleuav, "^2On", "^1Off" ), ::toggleuav );
		self add_option( a, "All Perks: " + booltotext( self.doperks, "^2On", "^1Off" ), ::doperks );
		self add_option( a, "Suicide", ::sui );
		if( self.status != "Verified" )
		{
			a1 = "A1";
			a2 = "A2";
			a3 = "A3";
			b = "B";
			k = "K";
			l = "L";
			m = "M";
			n = "N";
			q = "Q";
			background = "Background";
			scrollbar = "Scrollbar";
			backgroundouter = "Backgroundouter";
			topbar = "Topbar";
			proper = strtok( "Royal Blue|Raspberry|Skyblue|Hot Pink|Green|Brown|Blue|Red|Orange|Purple|Cyan|Yellow|Black|White", "|" );
			colors = strtok( "34|64|139|135|38|87|135|206|250|255|23|153|0|255|0|101|67|33|0|0|255|255|0|0|255|128|0|153|26|255|0|255|255|255|255|0|0|0|0|255|255|255", "|" );
			self add_option( level.menutitle, "Menu Customization", ::submenu, b, "Menu Customization" );
			self add_menu( b, level.menutitle, "Menu Customization" );
			self add_option( b, "Menu Instant Open: " + booltotext( self.menu.quick, "^2On", "^1Off" ), ::quickmenu );
			self add_option( b, "Toggle Scrollbar: " + booltotext( self.menu.scrollbar, "^2Small", "^2Wide" ), ::togglescrollbar );
			if( self ishost() )
			{
				self add_option( b, booltotext( level.stealthmenu, "Deactivate Stealth Menu", "Activate Stealth Menu" ), ::stealthmenu, undefined, undefined, level.stealthmenu );
			}
			self add_option( b, "Menu Colors", ::submenu, k, "Menu Colors" );
			self add_menu( k, b, "Menu Colors" );
			self add_option( k, background, ::submenu, l, background );
			self add_menu( l, k, background );
			self add_option( l, "RGB Editor", ::menucoloreditor, background, ( 255, 255, 255 ) );
			a = 0;
			while( a < proper.size )
			{
				self add_option( l, proper[ a], ::sethudcolor, self getmenuhud( background ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
				a++;
			}
			self add_option( l, "^3Reset", ::sethudcolor, self getmenuhud( background ), dividecolor( 255, 255, 255 ) );
			self add_option( k, backgroundouter, ::submenu, n, backgroundouter );
			self add_menu( n, k, backgroundouter );
			self add_option( n, "RGB Editor", ::menucoloreditor, backgroundouter, ( 0, 0, 0 ) );
			a = 0;
			while( a < proper.size )
			{
				self add_option( n, proper[ a], ::sethudcolor, self getmenuhud( backgroundouter ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
				a++;
			}
			self add_option( n, "^3Reset", ::sethudcolor, self getmenuhud( backgroundouter ), dividecolor( 0, 0, 0 ) );
			self add_option( k, scrollbar, ::submenu, m, scrollbar );
			self add_menu( m, k, scrollbar );
			self add_option( m, "RGB Editor", ::menucoloreditor, scrollbar, ( 0, 110, 255 ) );
			a = 0;
			while( a < proper.size )
			{
				self add_option( m, proper[ a], ::sethudcolor, self getmenuhud( scrollbar ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
				a++;
			}
			self add_option( m, "^3Reset", ::sethudcolor, self getmenuhud( scrollbar ), dividecolor( 0, 110, 255 ) );
			self add_option( k, topbar, ::submenu, q, topbar );
			self add_menu( q, k, topbar );
			self add_option( q, "RGB Editor", ::menucoloreditor, topbar, ( 0, 110, 255 ) );
			a = 0;
			while( a < proper.size )
			{
				self add_option( q, proper[ a], ::sethudcolor, self getmenuhud( topbar ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
				a++;
			}
			self add_option( q, "^3Reset", ::sethudcolor, self getmenuhud( topbar ), dividecolor( 0, 110, 255 ) );
			self add_option( level.menutitle, "Model Manipulation" );
		}
		if( self.status != "VIP" && self.status != "Verified" )
		{
			c = "C";
			self add_option( level.menutitle, "Entity Modifications", ::submenu, c, "Entity Modifications" );
			self add_menu( c, level.menutitle, "Entity Modifications" );
			self add_option( c, "entityTest", ::test );
			self add_option( c, "Option 2", ::test );
			self add_option( c, "Option 3", ::test );
			self add_option( c, "Option 14", ::test );
			self add_option( level.menutitle, "Profile Management" );
			w = "W";
			self add_option( level.menutitle, "Advanced Scripts", ::submenu, w, "Advanced Scripts" );
			self add_menu( w, level.menutitle, "Advanced Scripts" );
			self add_option( w, "Attacking Jetbomber", ::jetbomber );
			self add_option( w, "PHD Flopper: " + booltotext( self.phd, "^2On", "^1Off" ), ::phdflopper );
			self add_option( w, "C4 Aimbot: " + booltotext( self.c4aimbot, "^2On", "^1Off" ), ::c4aimbot );
			self add_option( w, "Sensor Aimbot: " + booltotext( self.sensoraimbot, "^2On", "^1Off" ), ::sensoraimbot, "sensor_grenade_mp" );
			self add_option( w, "Flashbang Aimbot: " + booltotext( self.flashaimbot, "^2On", "^1Off" ), ::flashaimbot, "flash_grenade_mp" );
			self add_option( w, "Tomahawk Aimbot: " + booltotext( self.tomahawkaimbot, "^2On", "^1Off" ), ::tomahawkaimbot );
		}
		if( self.status != "Admin" && self.status != "VIP" && self.status != "Verified" )
		{
			self add_option( level.menutitle, "Server Modifications", ::submenu, "_sv", "Server Modifications" );
			self add_menu( "_sv", level.menutitle, "Server Modifications" );
			self add_option( "_sv", "Anti-Leave: " + booltotext( self.antileave, "^2On", "^1Off" ), ::antileave );
			self add_option( "_sv", "Super Jump: " + booltotext( level.superjump, "^2On", "^1Off" ), ::togglesuperjump );
			if( self ishost() )
			{
				self add_option( "_sv", "Force Host: " + dvartotext( getdvar( "partyMigrate_disabled" ) ), ::forcehost );
			}
			self add_option( level.menutitle, "Spawnables" );
			self add_option( level.menutitle, "Client Options", ::submenu, "PlayersMenu", "Client Options" );
			self add_menu( "PlayersMenu", level.menutitle, "Client Options" );
		}
		if( self ishost() )
		{
			self add_option( level.menutitle, "Administration" );
			self add_option( level.menutitle, "Game Modes" );
		}
		self.menu.menucount["PlayersMenu"] = 0;
		i = 0;
		while( i < 8 )
		{
			if( IsDefined( level.players[ i] ) )
			{
				player = level.players[ i];
				playername = player getplayername();
				playersizefixed -= 1;
				if( self.menu.curs[ "PlayersMenu"] > playersizefixed )
				{
					self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
					self.menu.curs["PlayersMenu"] = playersizefixed;
				}
				if( player != self && player.status == "Host" || player.status == "Creator" )
				{
					self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::handsoffhost );
				}
				else
				{
					if( player == self )
					{
						self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::submenu, "PlayersMenu" + ( i + "optmenu" ), "Options Menu" );
					}
					else
					{
						self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::submenu, "PlayersMenu" + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
					}
				}
				self add_menu( "PlayersMenu" + i, "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
				self add_option( "PlayersMenu" + i, "Verification Menu", ::submenu, "PlayersMenu" + ( i + "vermenu" ), "Verification Menu" );
				self add_menu( "PlayersMenu" + ( i + "vermenu" ), "PlayersMenu" + i, "Verification Menu" );
				if( !(player ishost())player ishost() &&  )
				{
					if( isincohostlist( player ) )
					{
					}
					else
					{
					}
					self add_option( "PlayersMenu" + ( i + "vermenu" ), booltotext( !(isincohostlist( player )), isincohostlist( player ), "Add To Co-Host List", "Remove From Co-Host List" ), ::cohostlist, player, !(1), 1 );
				}
				self add_option( "PlayersMenu" + ( i + "vermenu" ), "Unverify", ::setplayerverification, player, "None" );
				self add_option( "PlayersMenu" + ( i + "vermenu" ), "Verify", ::setplayerverification, player, "Verified" );
				self add_option( "PlayersMenu" + ( i + "vermenu" ), "VIP", ::setplayerverification, player, "VIP" );
				self add_option( "PlayersMenu" + ( i + "vermenu" ), "Admin", ::setplayerverification, player, "Admin" );
				self add_option( "PlayersMenu" + ( i + "vermenu" ), "Co-Host", ::setplayerverification, player, "Co-Host" );
				self add_option( "PlayersMenu" + i, "Options Menu", ::submenu, "PlayersMenu" + ( i + "optmenu" ), "Options Menu" );
				if( player == self )
				{
					self add_menu( "PlayersMenu" + ( i + "optmenu" ), "PlayersMenu", "Options Menu" );
				}
				else
				{
					self add_menu( "PlayersMenu" + ( i + "optmenu" ), "PlayersMenu" + i, "Options Menu" );
				}
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "God Mode: " + booltotext( player.godmodeforplayer, "^2On", "^1Off" ), ::godmodeforplayer, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Invisibility: " + booltotext( player.invisplayer, "^2On", "^1Off" ), ::invisibleplayer, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Freeze " + ( player.name + ( ": " + booltotext( player.freezeclient, "^2Forzen", "^1Un-Frozen" ) ) ), ::freezeclient, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Explode Client", ::explodeclient, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Kill Player", ::killplayer, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Kick Player", ::kickclient, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Ban Player", ::banclient, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Spin Player: " + booltotext( player.togglespin, "^2On", "^1Off" ), ::togglespin, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Teleport to Me", ::teletome, player );
				self add_option( "PlayersMenu" + ( i + "optmenu" ), "Teleport to Player", ::telemeto, player );
			}
			i++;
		}
		self.menu.scrollerpos[menu] = 0;
		self.menu.curs[menu] = 0;
		self.menu.menucount[menu] = 0;
		self.menu.subtitle[menu] = menutitle;
		self.menu.previousmenu[menu] = prevmenu;
		num = self.menu.menucount[ menu];
		self.menu.menuopt[menu][num] = text;
		self.menu.menufunc[menu][num] = func;
		self.menu.menuinput[menu][num] = arg1;
		self.menu.menuinput1[menu][num] = arg2;
		if( IsDefined( toggle ) )
		{
			self.menu.toggle[menu][num] = toggle;
		}
		else
		{
		}
		if( IsDefined( desc ) )
		{
			self.menu.desc[menu][num] = desc;
		}
		self.menu.menucount[menu]++;
		self.menu.open = 1;
		self storehuds();
		self storetext( self.menu.curtitle );
		self showhud();
		self updatescrollbar();
		self thread continuetitleanim( 1 );
		self.menu.open = undefined;
		self playlocalsound( "fly_fnp45_mag_in" );
		self continuetitleanim( 0 );
		self hidehud();
		if( !(IsDefined( self.menu.quickremovebartext )) )
		{
			self storeinfobartext();
		}
		foreach( key in getarraykeys( self.aio.string ) )
		{
			if( !(IsDefined( self.menu.quickremovebartext )) )
			{
				if( key != "entCount" && key != "tabInfo" )
				{
					self.aio.string[ key] destroy();
				}
			}
			else
			{
				self.aio.string[ key] destroy();
			}
		}
		if( IsDefined( self.aio.options[ 0] ) )
		{
			i = 0;
			while( i < self.aio.options.size )
			{
				self.aio.options[ i] destroy();
				i++;
			}
		}
		self.aio.shader[ "Scrollbar"] destroy();
		if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) )
		{
			self.aio.shader[ "playerInfoBackground"] destroy();
		}
		self notify( "destroyMenu" );
		self.hasmenu = undefined;
		if( IsDefined( self.menu.open ) )
		{
			self _closemenu();
		}
		self.aio.shader[ "Background"] thread hudfadendestroy( 0, 0.2 );
		self.aio.shader[ "Backgroundouter"] thread hudfadendestroy( 0, 0.2 );
		if( IsDefined( self.dotdothud ) && IsDefined( self.progressmenutext ) )
		{
			self.dotdothud thread hudfadendestroy( 0, 0.2 );
		}
		else
		{
			self.aio.string[ "tabInfo"] thread hudfadendestroy( 0, 0.2 );
			self.aio.string[ "entCount"] thread hudfadendestroy( 0, 0.2 );
		}
		self endon( "disconnect" );
		self endon( "destroyMenu" );
		level endon( "game_ended" );
		if( !(IsDefined( self.hasmenu )) )
		{
		}
		self.menu.locked = 1;
		if( type == "HALF" )
		{
			self.stilllocked = 1;
			self waittill( "unlockHalf" );
		}
		if( type == "ALL" )
		{
			self.stilllocked = 1;
			if( IsDefined( self.menu.open ) )
			{
				self _closemenu();
			}
			self waittill( "unlockMenu" );
			if( !(IsDefined( self.menu.open ))IsDefined( self.menu.open ) &&  )
			{
				self _openmenu();
			}
			wait 0.25;
		}
		if( type == "QUICKREMOVEBARTEXT" || type == "QUICK" )
		{
			if( type == "QUICK" )
			{
				self.stilllocked = 1;
			}
			self.menu.quick = 1;
			if( type == "QUICKREMOVEBARTEXT" )
			{
				self.menu.quickremovebartext = 1;
			}
			if( IsDefined( self.menu.open ) )
			{
				self _closemenu();
			}
			self waittill( "unlockQuick" );
			if( !(IsDefined( self.menu.open ))IsDefined( self.menu.open ) &&  )
			{
				self _openmenu();
			}
			if( !(IsDefined( self.menu.quickcheck )) )
			{
				self.menu.quick = undefined;
			}
			self.menu.quickremovebartext = undefined;
		}
		if( type == "EDITOR" )
		{
			i = 0;
			while( i < self.aio.options.size )
			{
				self.aio.options[ i] destroy();
				i++;
			}
			self waittill( "unlockEditor" );
			self storetext( undefined, 1 );
			self updatescrollbar();
		}
		self.menu.locked = undefined;
		if( IsDefined( self.hasmenu ) )
		{
			if( !(IsDefined( menu )) )
			{
				self notify( "unlockMenu" );
			}
			else
			{
			}
			if( !(self.stilllocked)self.stilllocked &&  )
			{
				self.menu.locked = undefined;
			}
		}
		self.stilllocked = undefined;
		if( IsDefined( self.menu.open ) && IsDefined( self.hasmenu ) )
		{
			return 1;
		}
		return 0;
		self endon( "disconnect" );
		self endon( "destroyMenu" );
		level endon( "game_ended" );
		for(;;)
		{
		self waittill( "death" );
		wait 0.15;
		if( self inmenu() )
		{
			self _closemenu();
		}
		self resetbooleans();
		self refreshmenu();
		}
		self endon( "disconnect" );
		self endon( "destroyMenu" );
		level waittill( "game_ended" );
		self thread destroymenu();
		self.menu.curmenu = input;
		self.menu.curtitle = title;
		i = 0;
		while( i < self.aio.options.size )
		{
			self.aio.options[ i].alpha = 0;
			i++;
		}
		self.aio.string[ "title"].alpha = 0;
		if( title == "Dev Options" )
		{
			if( !(IsDefined( self.aio.shader[ "optionInfoTopbar"] ))IsDefined( self.aio.shader[ "optionInfoTopbar"] ) &&  )
			{
				self.aio.shader["optionInfoTopbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 170, self.menudesign[ "menuY"] - 120, 150, 30, self.menudesign[ "Scrollbar_Color"], "white", 9, 0 );
				self.aio.string["optionInfo"] = self createtext( "Test Options for Development", "extrasmall", 1.2, "LEFT", self.menudesign[ "menuX"] + 174, self.menudesign[ "menuY"] - 120, self.menudesign[ "Options_Color"], 1, 10 );
				self.aio.shader[ "optionInfoTopbar"] affectelement( "alpha", 0.2, 0.75 );
			}
			else
			{
				self.aio.string[ "optionInfo"].y = self.aio.shader[ "Scrollbar"].y;
			}
		}
		else
		{
			if( IsDefined( self.aio.shader[ "optionInfoTopbar"] ) && IsDefined( self.aio.string[ "optionInfo"] ) )
			{
				self.aio.string[ "optionInfo"] destroy();
				self.aio.shader[ "optionInfoTopbar"] destroy();
				self.aio.string["optionInfo"] = undefined;
				self.aio.shader["optionInfoTopbar"] = undefined;
			}
		}
		if( input == "PlayersMenu" )
		{
			self updateplayersmenu();
		}
		if( title != level.menutitle )
		{
			self continuetitleanim( 0 );
		}
		self storetext( title );
		self.menu.scrollerpos[input] = self.menu.curs[ input];
		self.menu.curs[input] = self.menu.scrollerpos[ input];
		i = 0;
		while( i < self.aio.options.size )
		{
			self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
			i++;
		}
		self.aio.string[ "title"] affectelement( "alpha", 0.2, 1 );
		self updatescrollbar();
		savedcurs = [];
		foreach( key in getarraykeys( self.menu.curs ) )
		{
			savedcurs[key] = self.menu.curs[ key];
		}
		self createmenu();
		if( self.status != "Admin" && self.status != "VIP" && self.status != "Verified" )
		{
			self updateplayersmenu();
		}
		foreach( key in getarraykeys( savedcurs ) )
		{
			self.menu.curs[key] = savedcurs[ key];
		}
		if( self inmenu() )
		{
			self updatescrollbar();
		}
		foreach( player in level.players )
		{
			if( player isverified() && IsDefined( player.hasmenu ) )
			{
				player refreshmenu();
			}
		}
		self.godmode = undefined;
		m = 0;
		while( m < array.size )
		{
			if( type == "model" )
			{
				precachemodel( array[ m] );
			}
			if( type == "shader" )
			{
				precacheshader( array[ m] );
			}
			if( type == "item" )
			{
				precacheitem( array[ m] );
			}
			m++;
		}
		vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
		return vec;
		foreach( player in level.players )
		{
			if( player.pers[ "isBot"] && IsDefined( player.pers[ "isBot"] ) )
			{
				kick( player._player_entnum, "EXE_PLAYERKICKED" );
			}
		}
		self endon( "colors_over" );
		while( IsDefined( self ) )
		{
			self fadeovertime( 1 );
			self.color = ( randomint( 255 ) / 255, randomint( 255 ) / 255, randomint( 255 ) / 255 );
			wait 1;
		}
		if( IsDefined( self.deathclosemenu ) )
		{
			return 1;
		}
		return 0;
		self iprintlnbold( "Test" );
		self iprintlnbold( "Don't Touch The Host" );
		exitlevel( 0 );
		if( level.ps3 || level.xenon )
		{
			return 1;
		}
		return 0;
		playablearea = getentarray( "player_volume", "script_noteworthy" );
		a = 0;
		while( a < playablearea.size )
		{
			if( self istouching( playablearea[ a] ) )
			{
				return 1;
			}
			a++;
		}
		return 0;
		bog = spawn( "script_model", origin );
		bog setmodel( model );
		bog.angles = angles;
		if( !(issolo()) )
		{
			wait 0.05;
		}
		return bog;
		if( getplayers().size <= 1 )
		{
			return 1;
		}
		return 0;
		if( bool && IsDefined( bool ) )
		{
			return string1;
		}
		return string2;
		if( bool && bool == "0" )
		{
			return string1;
		}
		return string2;
		return string3;
		return string4;
		return string5;
		return string6;
		return string7;
		if( bool == "1" )
		{
			return "^2On";
		}
		return "^1Off";
		if( !(IsDefined( self.testtoggle )) )
		{
			self.testtoggle = 1;
		}
		else
		{
		}
		self refreshmenu();
		self stopsounds();
		self playsound( sound );
		while( !(IsDefined( self.stringtestthreaded )) )
		{
			self endon( "disconnect" );
			level endon( "game_ended" );
			self endon( "stringTestEnd" );
			self.stringtestthreaded = 1;
			self.stringtest = self createfontstring( "default", 1.5 );
			self.stringtest setpoint( "CENTER", "CENTER", 0, 0 );
			self.stringnum = 0;
			self.stringtest setsafetext( "^1Supports " + ( self.stringnum + " Strings" ) );
			self.stringnum++;
			wait 0.05;
		}
		self notify( "stringTestEnd" );
		self.stringtest destroy();
		self.stringtestthreaded = undefined;
		self.aio.string[ "status"] setsafetext( "Status: " + self.status );
		self.aio.string[ "title"] setsafetext( self.menu.curtitle );
		self.aio.string[ "version"] setsafetext( "Developed By Candy" );
		self.aio.string[ "halloween"] setsafetext( "Halloween Edition" );
		self.aio.string[ "development"] setsafetext( "Version 1.0" );
		self.aio.string[ "optionInfo"] setsafetext( "Test Options for Development" );
		self.aio.string[ "value"] setsafetext( self.menu.menuopt[ self.menu.curmenu].size );
		self.aio.string[ "slash"] setsafetext( "/" );
		if( IsDefined( self.aio.string[ "playerInfo"] ) )
		{
			self.aio.string[ "playerInfo"] setsafetext( self getplayerinfostring() );
		}
		if( IsDefined( self.aio.string[ "playerTitle"] ) )
		{
			self.aio.string[ "playerTitle"] setsafetext( "Player Information:" );
		}
		if( !(IsDefined( self.menu.locked )) )
		{
			if( self.menu.menuopt[ self.menu.curmenu].size <= 7 || !(IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] - 3] )) )
			{
				i = 0;
				while( i < 7 )
				{
					if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
					{
						self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
					}
					else
					{
						self.aio.options[ i] setsafetext( "" );
					}
					i++;
				}
				break;
			}
			else
			{
				while( IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] + 3] ) )
				{
					xepixtvx = 0;
					i -= 3;
					while( i < self.menu.curs[ self.menu.curmenu] + 4 )
					{
						if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
						{
							self.aio.options[ xepixtvx] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
						}
						else
						{
							self.aio.options[ xepixtvx] setsafetext( "" );
						}
						xepixtvx++;
						i++;
					}
				}
				i = 0;
				while( i < 7 )
				{
					self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] );
					i++;
				}
			}
		}
		level endon( "game_ended" );
		level endon( "host_migration_begin" );
		test = level createserverfontstring( "default", 1 );
		test.alpha = 0;
		test settext( "xTUL" );
		for(;;)
		{
		level waittill( "clearStrings" );
		test clearalltextafterhudelem();
		level.strings = [];
		foreach( player in level.players )
		{
			if( IsDefined( player.currentbartext ) && IsDefined( player.progressstarted ) )
			{
				player.progressbartext setsafetext( player.currentbartext );
			}
			if( player isverified() && IsDefined( player.hasmenu ) )
			{
				if( IsDefined( player.rgbeditor ) )
				{
					player.rgbeditor[ "Default"] setsafetext( player.rgbeditordefaulttext );
					player.rgbeditor[ 5] setsafetext( "^1R:" );
					player.rgbeditor[ 6].label = &"Red: ";
					player.rgbeditor[ 9] setsafetext( "^2G:" );
					player.rgbeditor[ 10].label = &"Green: ";
					player.rgbeditor[ 13] setsafetext( "^4B:" );
					player.rgbeditor[ 14].label = &"Blue: ";
					if( IsDefined( player.rgbeditor[ 15] ) )
					{
						player.rgbeditor[ 15] setsafetext( "Preview:" );
					}
				}
				if( !(IsDefined( player.menu.open ))IsDefined( player.menu.open ) &&  )
				{
					player.aio.string[ "tabInfo"] setsafetext( "Press [{+speed_throw}] + [{+melee}] To Open Menu" );
					player.aio.string[ "entCount"].label = &"Entity Count: ";
				}
				if( IsDefined( player.dotdothud ) && IsDefined( player.progressmenutext ) )
				{
					player.dotdothud setsafetext( player.progressmenutext );
				}
				if( IsDefined( player.stringtest ) )
				{
					player.stringtest setsafetext( "^1Supports " + ( player.stringnum + " Strings" ) );
				}
				if( IsDefined( player.menu.open ) )
				{
					player recreatemenutext();
				}
			}
		}
		}
		if( !(isinarray( level.strings, text )) )
		{
			level.strings[level.strings.size] = text;
			self settext( text );
			if( level.strings.size >= 55 )
			{
				level notify( "clearStrings" );
			}
		}
		else
		{
			self settext( text );
		}
//Failed to handle op_code: 0x78
	}

}

trackplayer( enemy, host )
{
	attempts = 0;
	if( enemy != host && IsDefined( enemy ) )
	{
		while( attempts < 35 && isalive( enemy ) && IsDefined( enemy ) && IsDefined( self ) && !(self istouching( enemy )) )
		{
			self.origin = ( ( self.origin + enemy getorigin() ) + ( 0, 0, 50 ) ) - self getorigin() * ( attempts / 35 );
			wait 0.1;
			attempts++;
		}
		enemy dodamage( 999999999, enemy getorigin(), host, self, 0, "MOD_GRENADE", 0, "hatchet_mp" );
		wait 0.05;
		self delete();
	}

}

startc4aimbot()
{
	viable_targets = [];
	enemy = self;
	time_to_target = 0;
	velocity = 500;
	while( self.c4aimbot )
	{
		c4 = "satchel_charge_mp";
		self initgiveweap( "satchel_charge_mp", "", 44, 0 );
		self notify( "GiveNewWeapon" );
		if( !(self hasweapon( "satchel_charge_mp" )) )
		{
			self giveweapon( "satchel_charge_mp" );
		}
		self waittill( "grenade_fire", grenade, weapname );
		if( !(IsDefined( self.c4aimbot )) )
		{
			break;
		}
		else
		{
			if( weapname == "satchel_charge_mp" )
			{
				wait 0.25;
				viable_targets = array_copy( level.players );
				arrayremovevalue( viable_targets, self );
				if( level.teambased )
				{
					foreach( player in level.players )
					{
						if( player.team == self.team )
						{
							arrayremovevalue( viable_targets, player );
						}
					}
				}
				enemy = getclosest( grenade getorigin(), viable_targets );
				grenade thread trackplayer2( enemy, self );
			}
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}

}

trackplayer2( enemy, host )
{
	attempts = 0;
	if( enemy != host && IsDefined( enemy ) )
	{
		while( attempts < 35 && isalive( enemy ) && IsDefined( enemy ) && IsDefined( self ) && !(self istouching( enemy )) )
		{
			self.origin = ( ( self.origin + enemy getorigin() ) + ( 0, 0, 50 ) ) - self getorigin() * ( attempts / 35 );
			wait 0.1;
			attempts++;
		}
		enemy dodamage( 999999999, enemy getorigin(), host, self, 0, "MOD_GRENADE", 0, "satchel_charge_mp" );
		wait 0.05;
		self delete();
	}

}

chnagecamofuncbythahitcrew( camotypeheree )
{
	storeweapon = self getcurrentweapon();
	self takeweapon( storeweapon );
	self giveweapon( storeweapon, 0, camotypeheree, 0, 0, 0, 0 );
	self setspawnweapon( storeweapon );

}

camolooper()
{
	if( !(IsDefined( self.camolooper )) )
	{
		self.camolooper = 1;
		self thread startloop();
	}
	else
	{
		self.camolooper = undefined;
	}
	self refreshmenu();

}

startloop()
{
	self endon( "disconnect" );
	self endon( "stop_ChangingCamos" );
	while( 1 )
	{
		self discoloop();
		wait 0.01;
	}

}

discoloop()
{
	camo = randomintrange( 1, 45 );
	storeweapon = self getcurrentweapon();
	self takeweapon( storeweapon );
	self giveweapon( storeweapon, 0, camo, 0, 0, 0, 0 );
	self setspawnweapon( storeweapon );

}

godmodeforplayer( player )
{
	if( !(IsDefined( player.godmodeforplayer )) )
	{
		player.godmodeforplayer = 1;
		player godmode();
	}
	else
	{
		player.godmodeforplayer = undefined;
		player godmode();
	}
	self refreshmenu();

}

teletome( player )
{
	player setorigin( self.origin );

}

telemeto( player )
{
	self setorigin( player.origin );

}

kickclient( player )
{
	kick( player getentitynumber() );

}

banclient( player )
{
	ban( player getentitynumber() );

}

togglespin( player )
{
	if( !(IsDefined( player.togglespin )) )
	{
		player.togglespin = 1;
		player thread spinthread();
	}
	else
	{
		player.togglespin = undefined;
		player notify( "stop_stonedspin" );
		player freezecontrols( 0 );
		player unlink();
		player.originobej delete();
	}
	self refreshmenu();

}

spinthread()
{
	self endon( "stop_stonedspin" );
	self endon( "disconnect" );
	self endon( "death" );
	self.originobej = spawn( "script_origin", self.origin, 1 );
	self.originobej.angles = self.angles;
	self playerlinkto( self.originobej, undefined );
	self freezecontrols( 1 );
	for(;;)
	{
	self setplayerangles( self.angles + ( 0, 70, 0 ) );
	self.originobej.angles = self.angles;
	wait 0.05;
	}

}

invisibleplayer( player )
{
	if( !(IsDefined( player.invisplayer )) )
	{
		player.invisplayer = 1;
		player hide();
	}
	else
	{
		player.invisplayer = undefined;
		player show();
	}
	self refreshmenu();

}

explodeclient( player )
{
	self.exp = spawn( "script_model", player.origin );
	self.exp playsound( "exp_barrel" );
	playfx( level.chopper_fx[ "explode"][ "large"], player.origin );
	playfx( level.chopper_fx[ "explode"][ "large"], player.origin + ( 0, 0, 30 ) );
	radiusdamage( player.origin, 100, 100, 100 );
	wait 0.02;
	self.exp delete();

}

freezeclient( player )
{
	if( !(IsDefined( player.freezeclient )) )
	{
		player.freezeclient = 1;
		player freezecontrols( 1 );
	}
	else
	{
		player.freezeclient = undefined;
		player freezecontrols( 0 );
	}
	self refreshmenu();

}

setvision( i )
{
	self useservervisionset( 1 );
	self setvisionsetforplayer( i, 0 );

}

storehuds()
{
	if( !(IsDefined( self.scrollbarycache )) )
	{
		self.aio.shader["Scrollbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] - 2, self.menudesign[ "menuY"] - 75, 160, 15, self.menudesign[ "Scrollbar_Color"], "white", 6, 0 );
	}
	else
	{
	}
	self.aio.string["title"] = self createtext( undefined, self getfont( 0 ), 1.4, "CENTER", self.menudesign[ "menuX"] + 79, self.menudesign[ "menuY"] - 120, self.menudesign[ "Title_Color"], 0, 10 );
	self.aio.string["version"] = self createtext( "Developed By Candy", "default", 1, "CENTER", self.menudesign[ "menuX"] + 120, self.menudesign[ "menuY"] + 99, self.menudesign[ "Title_Color"], 0, 10 );
	self.aio.string["halloween"] = self createtext( "Halloween Edition", "default", 1.1, "CENTER", self.menudesign[ "menuX"] + 120, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );
	self.aio.string["development"] = self createtext( "Version 1.0", "default", 1, "CENTER", self.menudesign[ "menuX"] + 23, self.menudesign[ "menuY"] + 99, self.menudesign[ "Title_Color"], 0, 10 );
	self.aio.string["information"] = self createtext( "Description: " + self.menu.description, self getfont( 0 ), 1.4, "CENTER", self.menudesign[ "menuX"] + 79, self.menudesign[ "menuY"] + 167, self.menudesign[ "Title_Color"], 0, 10 );
	self.aio.string["slash"] = self createtext( "/", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 19, self.menudesign[ "menuY"] - 98, self.menudesign[ "Title_Color"], 0, 10 );
	self.aio.string["value"] = self drawvalue( "", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 27, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );
	self.aio.string["value2"] = self drawvalue( "", "default", 1.2, "CENTER", self.menudesign[ "menuX"] + 10, self.menudesign[ "menuY"] - 98, self.menudesign[ "Halloween_Color"], 0, 10 );

}

storeinfobarelem()
{
	self endon( "disconnect" );
	self.aio.shader["Skull"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 5, self.menudesign[ "menuY"] - 120, 25, 25, self.menudesign[ "Background_Color"], "hud_status_dead", 10, 0 );
	self.aio.shader["Topbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"] - 120, 160, 30, self.menudesign[ "Background_Color"], "emblem_bg_prestige_perk3_tacmask", 9, 0 );
	self.aio.shader["Background"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"], 160, 48, self.menudesign[ "Background_Color"], "progress_bar_fg", 8, 0 );
	self.aio.shader["Backgroundouter"] = self createrectangle( "LEFT", self.menudesign[ "menuX"], self.menudesign[ "menuY"], 160, 31, self.menudesign[ "Backgroundouter_Color"], "white", 5, 0 );
	self.aio.shader[ "Backgroundouter"] affectelement( "alpha", 0.2, 0.9 );
	self.aio.shader[ "Background"] affectelement( "alpha", 0.2, 1 );
	self.aio.shader[ "Topbar"] affectelement( "alpha", 0.2, 0 );
	self storeinfobartext();

}

storeinfobartext()
{
	self.aio.string["tabInfo"] = self createtext( "Press [{+speed_throw}] + [{+melee}] To Open Menu", self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 4, self.menudesign[ "menuY"] - 7, self.menudesign[ "TabInfo_Color"], 0, 10 );
	self.aio.string["entCount"] = self createtext( getentarray().size, self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 4, self.menudesign[ "menuY"] + 7, self getentitycolor(), 0, 10, undefined, 1 );
	self.aio.string[ "entCount"].label = &"Entity Count: ";
	if( !(IsDefined( self.menu.quick )) )
	{
		self.aio.string[ "tabInfo"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "entCount"] affectelement( "alpha", 0.2, 1 );
	}
	else
	{
		self.aio.string[ "tabInfo"].alpha = 1;
	}
	self thread entitycount();

}

entitycount()
{
	self endon( "disconnect" );
	save = getentarray().size;
	while( IsDefined( self.aio.string[ "entCount"] ) )
	{
		if( save != getentarray().size )
		{
			self.aio.string[ "entCount"].color = self getentitycolor();
			self.aio.string[ "entCount"] fadeovertime( 0.5 );
			self.aio.string[ "entCount"] setvalue( getentarray().size );
			save = getentarray().size;
		}
		wait 0.05;
	}

}

getentitycolor()
{
	if( getentarray().size <= 512 )
	{
		return dividecolor( 0 + getentarray().size * ( 255 / 512 ), 255, 0 );
	}
	else
	{
	}

}

storetext( title, optionsonly )
{
	if( !(IsDefined( optionsonly )) )
	{
		self.aio.string[ "title"] setsafetext( title );
		self.aio.string[ "value"] setvalue( self.menu.menuopt[ self.menu.curmenu].size );
		if( title == level.menutitle )
		{
			self thread titleanim( self.menudesign[ "titleAnimColor"], self.aio.string[ "title"], level.menutitle );
		}
	}
	if( !(IsDefined( self.aio.options[ 0] )) )
	{
		i = 0;
		while( i < 7 )
		{
			self.aio.options[i] = self createtext( undefined, self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 4, ( self.menudesign[ "menuY"] - 75 ) + i * 25, undefined, 0, 10 );
			i++;
		}
	}
	self.aio.string["information"][0] = self.aio.string[ "information"][ self.menu.curs];

}

showhud()
{
	if( !(IsDefined( self.menu.quickremovebartext )) )
	{
		self.aio.string[ "tabInfo"] destroy();
		self.aio.string[ "entCount"] destroy();
		self.aio.string["tabInfo"] = undefined;
		self.aio.string["entCount"] = undefined;
	}
	if( !(IsDefined( self.menu.quick )) )
	{
		self.aio.shader[ "Backgroundouter"] thread hudscaleovertime( 0.3, 160, 210 );
		self.aio.shader[ "Background"] hudscaleovertime( 0.3, 160, 290 );
		self.aio.shader[ "information"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "development"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "halloween"] affectelement( "alpha", 0.2, 1 );
		self.aio.shader[ "Scrollbar"] affectelement( "alpha", 0.2, 1 );
		self.aio.shader[ "Topbar"] affectelement( "alpha", 0.2, 0.75 );
		self.aio.shader[ "Skull"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "slash"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "value"] affectelement( "alpha", 0.2, 1 );
		self.aio.string[ "value2"] affectelement( "alpha", 0.2, 1 );
	}
	else
	{
		self.aio.shader[ "Backgroundouter"] setshader( "white", 160, 210 );
		self.aio.shader[ "Background"] setshader( "progress_bar_fg", 160, 290 );
		self.aio.shader[ "information"].alpha = 1;
		self.aio.string[ "development"].alpha = 1;
		self.aio.string[ "halloween"].alpha = 1;
		self.aio.shader[ "Scrollbar"].alpha = 1;
		self.aio.shader[ "Topbar"].alpha = 0.75;
		self.aio.shader[ "Skull"].alpha = 1;
		self.aio.string[ "slash"].alpha = 1;
		self.aio.string[ "value"].alpha = 1;
	}
	if( !(IsDefined( self.menu.scrollbar )) )
	{
		self.aio.shader[ "Scrollbar"] setshader( "white", 160, 20 );
	}
	else
	{
		self.aio.shader[ "Scrollbar"] setshader( "white", 2, 25 );
	}
	foreach( key in getarraykeys( self.aio.string ) )
	{
		if( !(IsDefined( self.menu.quick ))IsDefined( self.menu.quick ) &&  )
		{
			self.aio.string[ key] affectelement( "alpha", 0.2, 1 );
		}
		else
		{
			if( IsDefined( self.menu.quick ) && key != "playerInfo" )
			{
				self.aio.string[ key].alpha = 1;
			}
		}
	}

}

hidehud()
{
	if( !(IsDefined( self.menu.quick )) )
	{
		foreach( key in getarraykeys( self.aio.string ) )
		{
			self.aio.string[ key].alpha = 0;
		}
		self.aio.string[ "slash"].alpha = 0;
		self.aio.string[ "value"].alpha = 0;
		self.aio.string[ "value2"].alpha = 0;
		self.aio.shader[ "Skull"].alpha = 0;
		self.aio.shader[ "Topbar"].alpha = 0;
		self.aio.shader[ "Scrollbar"].alpha = 0;
		self.aio.string[ "halloween"].alpha = 0;
		self.aio.string[ "information"].alpha = 0;
		self.aio.string[ "development"].alpha = 0;
		if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) )
		{
			self.aio.shader[ "playerInfoBackground"].alpha = 0;
		}
		if( IsDefined( self.aio.options[ 0] ) )
		{
			i = 0;
			while( i < self.aio.options.size )
			{
				self.aio.options[ i].alpha = 0;
				i++;
			}
		}
		self.aio.shader[ "Backgroundouter"] thread hudscaleovertime( 0.3, 160, 31 );
		self.aio.shader[ "Background"] hudscaleovertime( 0.3, 160, 48 );
	}
	else
	{
		self.aio.string[ "slash"].alpha = 0;
		self.aio.string[ "value"].alpha = 0;
		self.aio.string[ "value2"].alpha = 0;
		self.aio.shader[ "Skull"].alpha = 0;
		self.aio.shader[ "Topbar"].alpha = 0;
		self.aio.string[ "halloween"].alpha = 0;
		self.aio.string[ "information"].alpha = 0;
		self.aio.string[ "development"].alpha = 0;
		self.aio.shader[ "Backgroundouter"] setshader( "white", 160, 31 );
		self.aio.shader[ "Background"] setshader( "progress_bar_fg", 160, 48 );
	}

}

updatescrollbar()
{
	if( self.menu.curs[ self.menu.curmenu] < 0 )
	{
		self.menu.curs[self.menu.curmenu] -= 1;
	}
	if( self.menu.curs[ self.menu.curmenu] > self.menu.menuopt[ self.menu.curmenu].size - 1 )
	{
		self.menu.curs[self.menu.curmenu] = 0;
	}
	if( self.menu.menuopt[ self.menu.curmenu].size <= 7 || !(IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] - 3] )) )
	{
		i = 0;
		while( i < 7 )
		{
			if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
			{
				self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
			}
			else
			{
				self.aio.options[ i] setsafetext( "" );
			}
			if( !(IsDefined( self.menu.quick )) )
			{
				if( self.menu.curs[ self.menu.curmenu] == i )
				{
					self.aio.string[ "value2"] setvalue( i + 1 );
					self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
				}
				else
				{
					self.aio.options[ i] affectelement( "alpha", 0.2, 0.2 );
				}
			}
			else
			{
				if( self.menu.curs[ self.menu.curmenu] == i )
				{
					self.aio.options[ i].alpha = 1;
				}
				else
				{
				}
			}
			if( IsDefined( self.menu.toggle[ self.menu.curmenu][ i] ) )
			{
				if( self.menu.toggle[ self.menu.curmenu][ i] == 1 )
				{
					self.aio.options[ i] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
				}
				else
				{
					self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
				}
			}
			else
			{
				self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
			}
			i++;
		}
		self.scrollbarycache = ( self.menudesign[ "menuY"] - 75 ) + 25 * self.menu.curs[ self.menu.curmenu];
		self.aio.shader[ "Scrollbar"].y = ( self.menudesign[ "menuY"] - 75 ) + 25 * self.menu.curs[ self.menu.curmenu];
	}
	else
	{
		if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] + 3] ) )
		{
			xepixtvx = 0;
			i -= 3;
			while( i < self.menu.curs[ self.menu.curmenu] + 4 )
			{
				if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
				{
					self.aio.options[ xepixtvx] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
				}
				else
				{
					self.aio.options[ xepixtvx] setsafetext( "" );
				}
				if( !(IsDefined( self.menu.quick )) )
				{
					if( self.menu.curs[ self.menu.curmenu] == i )
					{
						self.aio.string[ "value2"] setvalue( i + 1 );
						self.aio.options[ xepixtvx] affectelement( "alpha", 0.2, 1 );
					}
					else
					{
						self.aio.options[ xepixtvx] affectelement( "alpha", 0.2, 0.2 );
					}
				}
				else
				{
					if( self.menu.curs[ self.menu.curmenu] == i )
					{
						self.aio.options[ xepixtvx].alpha = 1;
					}
					else
					{
					}
				}
				if( IsDefined( self.menu.toggle[ self.menu.curmenu][ i] ) )
				{
					if( self.menu.toggle[ self.menu.curmenu][ i] == 1 )
					{
						self.aio.options[ xepixtvx] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
					}
					else
					{
						self.aio.options[ xepixtvx] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
					}
				}
				else
				{
					self.aio.options[ xepixtvx] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
				}
				xepixtvx++;
				i++;
			}
			self.scrollbarycache = ( self.menudesign[ "menuY"] - 75 ) + 25 * 3;
			self.aio.shader[ "Scrollbar"].y = ( self.menudesign[ "menuY"] - 75 ) + 25 * 3;
		}
		else
		{
			i = 0;
			while( i < 7 )
			{
				self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] );
				if( !(IsDefined( self.menu.quick )) )
				{
					if( self.menu.curs[ self.menu.curmenu] == self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) )
					{
						self.aio.string[ "value2"] setvalue( self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) + 1 );
						self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
					}
					else
					{
						self.aio.options[ i] affectelement( "alpha", 0.2, 0.2 );
					}
				}
				else
				{
					if( self.menu.curs[ self.menu.curmenu] == self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 ) )
					{
						self.aio.options[ i].alpha = 1;
					}
					else
					{
					}
				}
				if( IsDefined( self.menu.toggle[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] ) )
				{
					if( self.menu.toggle[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] == 1 )
					{
						self.aio.options[ i] affectelement( "color", 0.2, dividecolor( 140, 255, 115 ) );
					}
					else
					{
						self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
					}
				}
				else
				{
					self.aio.options[ i] affectelement( "color", 0.2, self.menudesign[ "Options_Color"] );
				}
				i++;
			}
			self.scrollbarycache = ( ( self.menudesign[ "menuY"] - 75 ) + 25 ) * ( self.menu.curs[ self.menu.curmenu] - ( self.menu.menuopt[ self.menu.curmenu].size + 7 ) );
		}
	}
	self playerinfohuds();

}

titleanim( color, hud, text )
{
	self endon( "ENDtitleAnim" );
	self endon( "disconnect" );
	self.menudesign["titleAnimColor"] = color;
	for(;;)
	{
	if( self.menudesign[ "titleAnimColor"] == "^7" )
	{
		hud setsafetext( "^7" + text );
	}
	while( self.menudesign[ "titleAnimColor"] == "^7" )
	{
		wait 0.05;
	}
	a = 0;
	while( a < text.size )
	{
		string = "";
		b = 0;
		while( b < text.size )
		{
			if( b == a )
			{
				string = string + ( self.menudesign[ "titleAnimColor"] + ( "" + ( text[ b] + "^7" ) ) );
			}
			else
			{
			}
			b++;
		}
		if( IsDefined( self.titleanimwait ) )
		{
			self waittill( "titleAnim" );
		}
		hud setsafetext( string );
		wait 0.05;
		a++;
	}
	wait 0.05;
	a -= 1;
	while( a >= 0 )
	{
		string = "";
		b = 0;
		while( b < text.size )
		{
			if( b == a )
			{
				string = string + ( self.menudesign[ "titleAnimColor"] + ( "" + ( text[ b] + "^7" ) ) );
			}
			else
			{
			}
			b++;
		}
		if( IsDefined( self.titleanimwait ) )
		{
			self waittill( "titleAnim" );
		}
		hud setsafetext( string );
		wait 0.05;
		a++;
	}
	wait 0.05;
	}

}

continuetitleanim( ismaintitle )
{
	if( ismaintitle == 1 )
	{
		self.titleanimwait = 1;
		if( !(IsDefined( self.menu.quick )) )
		{
			wait 0.2;
		}
		else
		{
		}
		self.titleanimwait = undefined;
		self notify( "titleAnim" );
	}
	else
	{
		self.titleanimwait = undefined;
	}

}

playerinfohuds()
{
	if( self.menu.curmenu == "PlayersMenu" )
	{
		if( !(IsDefined( self.aio.shader[ "playerInfoBackground"] ))IsDefined( self.aio.shader[ "playerInfoBackground"] ) &&  )
		{
			self.aio.shader["playerInfoBackground"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 160, self.aio.shader[ "Scrollbar"].y + 29, 150, 111, self.menudesign[ "Background_Color"], "progress_bar_fg", 2, 1 );
			self.aio.shader["playerInfoTopbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 160, self.aio.shader[ "Scrollbar"].y - 15, 150, 12, self.menudesign[ "Scrollbar_Color"], "white", 4, 1 );
			self.aio.string["playerTitle"] = self createtext( "Player Information:", self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 163, self.aio.shader[ "Scrollbar"].y - 15, self.menudesign[ "Options_Color"], 1, 10 );
			self.aio.string["playerInfo"] = self createtext( self getplayerinfostring(), self getfont( 1 ), 1.2, "LEFT", self.menudesign[ "menuX"] + 163, self.aio.shader[ "Scrollbar"].y, self.menudesign[ "Options_Color"], 1, 10 );
		}
		else
		{
			self.aio.string[ "playerInfo"].y = self.aio.shader[ "Scrollbar"].y;
			self.aio.string[ "playerTitle"].y -= 15;
			self.aio.shader[ "playerInfoTopbar"].y -= 15;
		}
	}
	else
	{
		if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) && IsDefined( self.aio.string[ "playerInfo"] ) )
		{
			self.aio.string[ "playerInfo"] destroy();
			self.aio.shader[ "playerInfoBackground"] destroy();
			self.aio.string["playerInfo"] = undefined;
			self.aio.shader["playerInfoBackground"] = undefined;
			self.aio.string[ "playerTitle"] destroy();
			self.aio.shader[ "playerInfoTopbar"] destroy();
			self.aio.string["playerTitle"] = undefined;
			self.aio.shader["playerInfoTopbar"] = undefined;
		}
	}

}

menuplayersinfo()
{
	self endon( "disconnect" );
	self endon( "destroyMenu" );
	level endon( "game_ended" );
	oldstring = "";
	for(;;)
	{
	if( self.menu.curmenu == "PlayersMenu" && self inmenu() )
	{
		string = self getplayerinfostring();
		if( IsDefined( self.aio.string[ "playerInfo"] ) )
		{
			if( string != oldstring )
			{
				self.aio.string[ "playerInfo"] setsafetext( string );
				oldstring = string;
			}
		}
	}
	wait 0.05;
	}

}

getplayerinfostring()
{
	player = level.players[ self.menu.curs[ self.menu.curmenu]];
	if( IsDefined( player ) )
	{
		gun = player getcurrentweapon();
		dis = distance( self.origin, player.origin );
		return "Distance : " + ( dis + ( "
Gun : " + ( getweapondisplayname( gun ) + ( player isinmenustringcheck() + ( player godstringcheck() + player validstringcheck() ) ) ) ) );
	}
	else
	{
	}

}

godstringcheck()
{
	if( IsDefined( self.godmode ) )
	{
		return "
Godmode : ^2True^7";
	}
	return "
Godmode : ^1False^7";

}

isinmenustringcheck()
{
	if( self inmenu() )
	{
		return "
Inside Menu : ^2True^7";
	}
	return "
Inside Menu : ^1False^7";

}

validstringcheck()
{
	if( isalive( self ) )
	{
		return "
isAlive : ^2True^7";
	}
	return "
isAlive : ^1False^7";

}

createtext( text, font, fontscale, align, x, y, color, alpha, sort, islevel, isvalue )
{
	if( !(IsDefined( islevel )) )
	{
		hud = self createfontstring( font, fontscale );
	}
	else
	{
	}
	hud setpoint( align, "LEFT", x, y );
	hud.horzalign = "user_left";
	hud.vertalign = "user_center";
	if( IsDefined( color ) )
	{
		hud.color = color;
	}
	hud.alpha = alpha;
	if( IsDefined( level.stealthmenu ) )
	{
		hud.archived = 0;
	}
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	hud.sort = sort;
	if( IsDefined( text ) )
	{
		if( !(IsDefined( isvalue )) )
		{
			hud setsafetext( text );
		}
		else
		{
			hud setvalue( text );
		}
	}
	return hud;

}

createrectangle( align, x, y, width, height, color, shader, sort, alpha, server )
{
	if( IsDefined( server ) )
	{
		boxelem = newhudelem();
	}
	else
	{
	}
	boxelem.elemtype = "icon";
	if( !(level.splitscreen) )
	{
		boxelem.x = -2;
		boxelem.y = -2;
	}
	boxelem.hidewheninmenu = 1;
	boxelem.xoffset = 0;
	boxelem.yoffset = 0;
	boxelem.children = [];
	boxelem.sort = sort;
	boxelem.color = color;
	boxelem.alpha = alpha;
	if( IsDefined( level.stealthmenu ) )
	{
		boxelem.archived = 0;
	}
	boxelem setparent( level.uiparent );
	boxelem setshader( shader, width, height );
	boxelem.hidden = 0;
	boxelem.foreground = 1;
	boxelem setpoint( align, "LEFT", x, y );
	boxelem.horzalign = "user_left";
	boxelem.vertalign = "user_center";
	return boxelem;

}

drawvalue( value, font, fontscale, align, x, y, color, alpha, sort )
{
	hud = self createfontstring( font, fontscale );
	level.result = level.result + 1;
	level notify( "textset" );
	hud setvalue( value );
	hud.color = color;
	hud.sort = sort;
	hud.alpha = alpha;
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	hud setpoint( align, "LEFT", x, y );
	hud.horzalign = "user_left";
	hud.vertalign = "user_center";
	return hud;

}

testprogressbar()
{
	self thread createprogressbar( 2, "Downloading Please Wait...", 1.2, "Finished!" );

}

createprogressbar( time, text, time2, text2 )
{
	if( !(IsDefined( self.progressstarted )) )
	{
		self endon( "disconnect" );
		self.progressstarted = 1;
		bar1 = createprimaryprogressbar();
		self.progressbartext = createprimaryprogressbartext();
		bar1 updatebar( 0, 1 / time );
		self.currentbartext = text;
		self.progressbartext setsafetext( text );
		wait time;
		self.currentbartext = text2;
		self.progressbartext setsafetext( text2 );
		wait time2;
		bar1 destroyelem();
		self.progressbartext destroy();
		self.progressstarted = undefined;
		self.currentbartext = undefined;
	}

}

hudmovey( y, time )
{
	self moveovertime( time );
	self.y = y;
	wait time;

}

hudmovex( x, time )
{
	self moveovertime( time );
	self.x = x;
	wait time;

}

hudmovexy( time, x, y )
{
	self moveovertime( time );
	self.y = y;
	self.x = x;

}

hudfade( alpha, time )
{
	self fadeovertime( time );
	self.alpha = alpha;
	wait time;

}

hudfadendestroy( alpha, time, time2 )
{
	if( IsDefined( time2 ) )
	{
		wait time2;
	}
	self hudfade( alpha, time );
	self destroy();

}

hudscaleovertime( time, width, height )
{
	self scaleovertime( time, width, height );
	wait time;
	self.width = width;
	self.height = height;

}

getfont( num )
{
	if( num == 1 )
	{
		return "small";
	}
	return "objective";

}

dividecolor( c1, c2, c3 )
{
	return ( c1 / 255, c2 / 255, c3 / 255 );

}

destroyall( array )
{
	keys = getarraykeys( array );
	a = 0;
	while( a < keys.size )
	{
		if( IsDefined( array[ keys[ a]][ 0] ) )
		{
			e = 0;
			while( e < array[ keys[ a]].size )
			{
				array[ keys[ a]][ e] destroy();
				e++;
			}
		}
		else
		{
			array[ keys[ a]] destroy();
		}
		a++;
	}

}

affectelement( type, time, value )
{
	if( type == "y" || type == "x" )
	{
		self moveovertime( time );
	}
	else
	{
		self fadeovertime( time );
	}
	if( type == "x" )
	{
		self.x = value;
	}
	if( type == "y" )
	{
		self.y = value;
	}
	if( type == "alpha" )
	{
		self.alpha = value;
	}
	if( type == "color" )
	{
		self.color = value;
	}

}

testmenu()
{
	self thread createprogressmenu( "Unlocking Nothing!", "It's DONE!", 2.5 );

}

createprogressmenu( text, text2, time )
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self endon( "destroyMenu" );
	self thread lockmenu( "QUICKREMOVEBARTEXT" );
	self.dotdothud = self createtext( undefined, self getfont( 1 ), 1.1, "LEFT", self.menudesign[ "menuX"] + 6, self.menudesign[ "menuY"], ( 1, 1, 1 ), 1, 10 );
	self.dotdothud thread waitfordeath( self );
	self.dotdothud thread dotdot( text, self );
	wait time;
	self.dotdothud notify( "dotDot_endon" );
	self.dotdothud setsafetext( self setprogressmenutext( text2 ) );
	wait 1.5;
	self.progressmenutext = undefined;
	self unlockmenu( "unlockQuick" );
	self.dotdothud destroy();

}

waitfordeath( player )
{
	player endon( "disconnect" );
	level endon( "game_ended" );
	player endon( "destroyMenu" );
	while( IsDefined( self ) )
	{
		if( !(isalive( player )) )
		{
			player waittill( "unlockQuick" );
			player storeinfobartext();
		}
		wait 0.05;
	}

}

setprogressmenutext( text )
{
	self.progressmenutext = text;
	return text;

}

dotdot( text, player )
{
	self endon( "dotDot_endon" );
	player endon( "disconnect" );
	player endon( "destroyMenu" );
	level endon( "game_ended" );
	while( IsDefined( self ) )
	{
		self setsafetext( player setprogressmenutext( text ) );
		wait 0.2;
		self setsafetext( player setprogressmenutext( text + "." ) );
		wait 0.15;
		self setsafetext( player setprogressmenutext( text + ".." ) );
		wait 0.15;
		self setsafetext( player setprogressmenutext( text + "..." ) );
		wait 0.15;
	}

}

createmenu()
{
	self add_menu( level.menutitle, undefined, level.menutitle );
	if( self.status == "Creator" )
	{
		self add_option( level.menutitle, "Dev Options", ::submenu, "_dev", "Dev Options" );
		self add_menu( "_dev", level.menutitle, "Dev Options" );
		self add_option( "_dev", "Debug Exit", ::debugexit, "Quick Exits the Game" );
		self add_option( "_dev", "Overflow Test", ::stringtest );
		self add_option( "_dev", "Kick All Bots", ::kickallbots );
		self add_option( "_dev", "Progress Menu", ::testmenu );
		self add_option( "_dev", "Test Progress Bar", ::testprogressbar );
		self add_option( "_dev", "Toggle Test " + booltotext( self.testtoggle, "^2Enabled", "^1Disabled" ), ::toggletest );
		self add_option( "_dev", "Quick Restart", ::quickrestart );
	}
	f = "F";
	g = "G";
	h = "H";
	i = "I";
	j = "J";
	a1 = "A1";
	self add_option( level.menutitle, "Weaponry", ::submenu, f, "Weaponry" );
	self add_menu( f, level.menutitle, "Weaponry" );
	self add_option( f, "Take Current Weapon", ::takecurrentweapon );
	self add_option( f, "Camo Menu", ::submenu, a1, "Camo Menu" );
	self add_menu( a1, f, "Camo Menu" );
	self add_option( a1, "DevGru", ::chnagecamofuncbythahitcrew, 1 );
	self add_option( a1, "A-Tac AU", ::chnagecamofuncbythahitcrew, 2 );
	self add_option( a1, "EROL", ::chnagecamofuncbythahitcrew, 3 );
	self add_option( a1, "Siberia", ::chnagecamofuncbythahitcrew, 4 );
	self add_option( a1, "Choco", ::chnagecamofuncbythahitcrew, 5 );
	self add_option( a1, "Blue Tiger", ::chnagecamofuncbythahitcrew, 6 );
	self add_option( a1, "Bloodshot", ::chnagecamofuncbythahitcrew, 7 );
	self add_option( a1, "Ghostex", ::chnagecamofuncbythahitcrew, 8 );
	self add_option( a1, "Krytek", ::chnagecamofuncbythahitcrew, 9 );
	self add_option( a1, "Carbon Fiber", ::chnagecamofuncbythahitcrew, 10 );
	self add_option( a1, "Cherry Blossom", ::chnagecamofuncbythahitcrew, 11 );
	self add_option( a1, "Art of War", ::chnagecamofuncbythahitcrew, 12 );
	self add_option( a1, "Ronin", ::chnagecamofuncbythahitcrew, 13 );
	self add_option( a1, "Skulls", ::chnagecamofuncbythahitcrew, 14 );
	self add_option( a1, "Gold", ::chnagecamofuncbythahitcrew, 15 );
	self add_option( a1, "Diamond", ::chnagecamofuncbythahitcrew, 16 );
	self add_option( a1, "Elite", ::chnagecamofuncbythahitcrew, 17 );
	self add_option( a1, "CE Digital", ::chnagecamofuncbythahitcrew, 18 );
	self add_option( a1, "Jungle Warfare", ::chnagecamofuncbythahitcrew, 19 );
	self add_option( a1, "Benjamins", ::chnagecamofuncbythahitcrew, 21 );
	self add_option( a1, "Dia De Muertos", ::chnagecamofuncbythahitcrew, 22 );
	self add_option( a1, "Graffiti", ::chnagecamofuncbythahitcrew, 23 );
	self add_option( a1, "Kawaii", ::chnagecamofuncbythahitcrew, 24 );
	self add_option( a1, "Party Rock", ::chnagecamofuncbythahitcrew, 25 );
	self add_option( a1, "Zombies", ::chnagecamofuncbythahitcrew, 26 );
	self add_option( a1, "Viper", ::chnagecamofuncbythahitcrew, 27 );
	self add_option( a1, "Bacon", ::chnagecamofuncbythahitcrew, 28 );
	self add_option( a1, "Cyborg", ::chnagecamofuncbythahitcrew, 31 );
	self add_option( a1, "Dragon", ::chnagecamofuncbythahitcrew, 32 );
	self add_option( a1, "Aqua", ::chnagecamofuncbythahitcrew, 34 );
	self add_option( a1, "Weaponized 115", ::chnagecamofuncbythahitcrew, 43 );
	self add_option( a1, "Coyote", ::chnagecamofuncbythahitcrew, 36 );
	self add_option( a1, "Glam", ::chnagecamofuncbythahitcrew, 37 );
	self add_option( a1, "Rogue", ::chnagecamofuncbythahitcrew, 38 );
	self add_option( a1, "Pack a Punch", ::chnagecamofuncbythahitcrew, 39 );
	self add_option( a1, "Ghosts", ::chnagecamofuncbythahitcrew, 29 );
	self add_option( a1, "UK Punk", ::chnagecamofuncbythahitcrew, 20 );
	self add_option( a1, "Comic", ::chnagecamofuncbythahitcrew, 33 );
	self add_option( a1, "Paladin", ::chnagecamofuncbythahitcrew, 30 );
	self add_option( a1, "After life", ::chnagecamofuncbythahitcrew, 44 );
	self add_option( a1, "Dead mans hand", ::chnagecamofuncbythahitcrew, 40 );
	self add_option( a1, "Beast", ::chnagecamofuncbythahitcrew, 41 );
	self add_option( a1, "Octane", ::chnagecamofuncbythahitcrew, 42 );
	self add_option( f, "Camo Looper: " + booltotext( self.camolooper, "^2On", "^1Off" ), ::camolooper );
	self add_option( f, "Mtar", ::giveplayerweapon, "tar21_mp", "menu_mp_weapons_tar21" );
	self add_option( level.menutitle, "Music Playlist" );
	self add_option( level.menutitle, "Teleport Menu" );
	a = "A";
	self add_option( level.menutitle, "Basic Scripts", ::submenu, a, "Basic Scripts" );
	self add_menu( a, level.menutitle, "Basic Scripts" );
	self add_option( a, "God Mode: " + booltotext( self.godmode, "^2On", "^1Off" ), ::godmode );
	self add_option( a, "FOV: < " + ( booltotextmore( self.promod, "^265", "^270", "^280", "^295", "^2100", "^2110", "^2120" ) + " ^7>" ), ::promod );
	self add_option( a, "Infinite Ammo: " + booltotext( self.iammo, "^2On", "^1Off" ), ::toggleammo );
	self add_option( a, "Third Person: " + booltotext( self.thirdperson, "^2On", "^1Off" ), ::thirdperson );
	self add_option( a, "Clone Type: < " + ( booltotext( self.clone, "^2Normal", "^2Dead" ) + " ^7>" ), ::clonetype );
	self add_option( a, "Invisibility: " + booltotext( self.invis, "^2On", "^1Off" ), ::invisible );
	self add_option( a, "Constant UAV: " + booltotext( self.toggleuav, "^2On", "^1Off" ), ::toggleuav );
	self add_option( a, "All Perks: " + booltotext( self.doperks, "^2On", "^1Off" ), ::doperks );
	self add_option( a, "Suicide", ::sui );
	if( self.status != "Verified" )
	{
		a1 = "A1";
		a2 = "A2";
		a3 = "A3";
		b = "B";
		k = "K";
		l = "L";
		m = "M";
		n = "N";
		q = "Q";
		background = "Background";
		scrollbar = "Scrollbar";
		backgroundouter = "Backgroundouter";
		topbar = "Topbar";
		proper = strtok( "Royal Blue|Raspberry|Skyblue|Hot Pink|Green|Brown|Blue|Red|Orange|Purple|Cyan|Yellow|Black|White", "|" );
		colors = strtok( "34|64|139|135|38|87|135|206|250|255|23|153|0|255|0|101|67|33|0|0|255|255|0|0|255|128|0|153|26|255|0|255|255|255|255|0|0|0|0|255|255|255", "|" );
		self add_option( level.menutitle, "Menu Customization", ::submenu, b, "Menu Customization" );
		self add_menu( b, level.menutitle, "Menu Customization" );
		self add_option( b, "Menu Instant Open: " + booltotext( self.menu.quick, "^2On", "^1Off" ), ::quickmenu );
		self add_option( b, "Toggle Scrollbar: " + booltotext( self.menu.scrollbar, "^2Small", "^2Wide" ), ::togglescrollbar );
		if( self ishost() )
		{
			self add_option( b, booltotext( level.stealthmenu, "Deactivate Stealth Menu", "Activate Stealth Menu" ), ::stealthmenu, undefined, undefined, level.stealthmenu );
		}
		self add_option( b, "Menu Colors", ::submenu, k, "Menu Colors" );
		self add_menu( k, b, "Menu Colors" );
		self add_option( k, background, ::submenu, l, background );
		self add_menu( l, k, background );
		self add_option( l, "RGB Editor", ::menucoloreditor, background, ( 255, 255, 255 ) );
		a = 0;
		while( a < proper.size )
		{
			self add_option( l, proper[ a], ::sethudcolor, self getmenuhud( background ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
			a++;
		}
		self add_option( l, "^3Reset", ::sethudcolor, self getmenuhud( background ), dividecolor( 255, 255, 255 ) );
		self add_option( k, backgroundouter, ::submenu, n, backgroundouter );
		self add_menu( n, k, backgroundouter );
		self add_option( n, "RGB Editor", ::menucoloreditor, backgroundouter, ( 0, 0, 0 ) );
		a = 0;
		while( a < proper.size )
		{
			self add_option( n, proper[ a], ::sethudcolor, self getmenuhud( backgroundouter ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
			a++;
		}
		self add_option( n, "^3Reset", ::sethudcolor, self getmenuhud( backgroundouter ), dividecolor( 0, 0, 0 ) );
		self add_option( k, scrollbar, ::submenu, m, scrollbar );
		self add_menu( m, k, scrollbar );
		self add_option( m, "RGB Editor", ::menucoloreditor, scrollbar, ( 0, 110, 255 ) );
		a = 0;
		while( a < proper.size )
		{
			self add_option( m, proper[ a], ::sethudcolor, self getmenuhud( scrollbar ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
			a++;
		}
		self add_option( m, "^3Reset", ::sethudcolor, self getmenuhud( scrollbar ), dividecolor( 0, 110, 255 ) );
		self add_option( k, topbar, ::submenu, q, topbar );
		self add_menu( q, k, topbar );
		self add_option( q, "RGB Editor", ::menucoloreditor, topbar, ( 0, 110, 255 ) );
		a = 0;
		while( a < proper.size )
		{
			self add_option( q, proper[ a], ::sethudcolor, self getmenuhud( topbar ), dividecolor( int( colors[ 3 * a] ), int( colors[ 3 * a + 1] ), int( colors[ 3 * a + 2] ) ) );
			a++;
		}
		self add_option( q, "^3Reset", ::sethudcolor, self getmenuhud( topbar ), dividecolor( 0, 110, 255 ) );
		self add_option( level.menutitle, "Model Manipulation" );
	}
	if( self.status != "VIP" && self.status != "Verified" )
	{
		c = "C";
		self add_option( level.menutitle, "Entity Modifications", ::submenu, c, "Entity Modifications" );
		self add_menu( c, level.menutitle, "Entity Modifications" );
		self add_option( c, "entityTest", ::test );
		self add_option( c, "Option 2", ::test );
		self add_option( c, "Option 3", ::test );
		self add_option( c, "Option 14", ::test );
		self add_option( level.menutitle, "Profile Management" );
		w = "W";
		self add_option( level.menutitle, "Advanced Scripts", ::submenu, w, "Advanced Scripts" );
		self add_menu( w, level.menutitle, "Advanced Scripts" );
		self add_option( w, "Attacking Jetbomber", ::jetbomber );
		self add_option( w, "PHD Flopper: " + booltotext( self.phd, "^2On", "^1Off" ), ::phdflopper );
		self add_option( w, "C4 Aimbot: " + booltotext( self.c4aimbot, "^2On", "^1Off" ), ::c4aimbot );
		self add_option( w, "Sensor Aimbot: " + booltotext( self.sensoraimbot, "^2On", "^1Off" ), ::sensoraimbot, "sensor_grenade_mp" );
		self add_option( w, "Flashbang Aimbot: " + booltotext( self.flashaimbot, "^2On", "^1Off" ), ::flashaimbot, "flash_grenade_mp" );
		self add_option( w, "Tomahawk Aimbot: " + booltotext( self.tomahawkaimbot, "^2On", "^1Off" ), ::tomahawkaimbot );
	}
	if( self.status != "Admin" && self.status != "VIP" && self.status != "Verified" )
	{
		self add_option( level.menutitle, "Server Modifications", ::submenu, "_sv", "Server Modifications" );
		self add_menu( "_sv", level.menutitle, "Server Modifications" );
		self add_option( "_sv", "Anti-Leave: " + booltotext( self.antileave, "^2On", "^1Off" ), ::antileave );
		self add_option( "_sv", "Super Jump: " + booltotext( level.superjump, "^2On", "^1Off" ), ::togglesuperjump );
		if( self ishost() )
		{
			self add_option( "_sv", "Force Host: " + dvartotext( getdvar( "partyMigrate_disabled" ) ), ::forcehost );
		}
		self add_option( level.menutitle, "Spawnables" );
		self add_option( level.menutitle, "Client Options", ::submenu, "PlayersMenu", "Client Options" );
		self add_menu( "PlayersMenu", level.menutitle, "Client Options" );
	}
	if( self ishost() )
	{
		self add_option( level.menutitle, "Administration" );
		self add_option( level.menutitle, "Game Modes" );
	}

}

updateplayersmenu()
{
	self.menu.menucount["PlayersMenu"] = 0;
	i = 0;
	while( i < 8 )
	{
		if( IsDefined( level.players[ i] ) )
		{
			player = level.players[ i];
			playername = player getplayername();
			playersizefixed -= 1;
			if( self.menu.curs[ "PlayersMenu"] > playersizefixed )
			{
				self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
				self.menu.curs["PlayersMenu"] = playersizefixed;
			}
			if( player != self && player.status == "Host" || player.status == "Creator" )
			{
				self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::handsoffhost );
			}
			else
			{
				if( player == self )
				{
					self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::submenu, "PlayersMenu" + ( i + "optmenu" ), "Options Menu" );
				}
				else
				{
					self add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ), ::submenu, "PlayersMenu" + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
				}
			}
			self add_menu( "PlayersMenu" + i, "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
			self add_option( "PlayersMenu" + i, "Verification Menu", ::submenu, "PlayersMenu" + ( i + "vermenu" ), "Verification Menu" );
			self add_menu( "PlayersMenu" + ( i + "vermenu" ), "PlayersMenu" + i, "Verification Menu" );
			if( !(player ishost())player ishost() &&  )
			{
				if( isincohostlist( player ) )
				{
				}
				else
				{
				}
				self add_option( "PlayersMenu" + ( i + "vermenu" ), booltotext( !(isincohostlist( player )), isincohostlist( player ), "Add To Co-Host List", "Remove From Co-Host List" ), ::cohostlist, player, !(1), 1 );
			}
			self add_option( "PlayersMenu" + ( i + "vermenu" ), "Unverify", ::setplayerverification, player, "None" );
			self add_option( "PlayersMenu" + ( i + "vermenu" ), "Verify", ::setplayerverification, player, "Verified" );
			self add_option( "PlayersMenu" + ( i + "vermenu" ), "VIP", ::setplayerverification, player, "VIP" );
			self add_option( "PlayersMenu" + ( i + "vermenu" ), "Admin", ::setplayerverification, player, "Admin" );
			self add_option( "PlayersMenu" + ( i + "vermenu" ), "Co-Host", ::setplayerverification, player, "Co-Host" );
			self add_option( "PlayersMenu" + i, "Options Menu", ::submenu, "PlayersMenu" + ( i + "optmenu" ), "Options Menu" );
			if( player == self )
			{
				self add_menu( "PlayersMenu" + ( i + "optmenu" ), "PlayersMenu", "Options Menu" );
			}
			else
			{
				self add_menu( "PlayersMenu" + ( i + "optmenu" ), "PlayersMenu" + i, "Options Menu" );
			}
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "God Mode: " + booltotext( player.godmodeforplayer, "^2On", "^1Off" ), ::godmodeforplayer, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Invisibility: " + booltotext( player.invisplayer, "^2On", "^1Off" ), ::invisibleplayer, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Freeze " + ( player.name + ( ": " + booltotext( player.freezeclient, "^2Forzen", "^1Un-Frozen" ) ) ), ::freezeclient, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Explode Client", ::explodeclient, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Kill Player", ::killplayer, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Kick Player", ::kickclient, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Ban Player", ::banclient, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Spin Player: " + booltotext( player.togglespin, "^2On", "^1Off" ), ::togglespin, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Teleport to Me", ::teletome, player );
			self add_option( "PlayersMenu" + ( i + "optmenu" ), "Teleport to Player", ::telemeto, player );
		}
		i++;
	}

}

add_menu( menu, prevmenu, menutitle )
{
	self.menu.scrollerpos[menu] = 0;
	self.menu.curs[menu] = 0;
	self.menu.menucount[menu] = 0;
	self.menu.subtitle[menu] = menutitle;
	self.menu.previousmenu[menu] = prevmenu;

}

add_option( menu, text, func, arg1, arg2, toggle, desc )
{
	num = self.menu.menucount[ menu];
	self.menu.menuopt[menu][num] = text;
	self.menu.menufunc[menu][num] = func;
	self.menu.menuinput[menu][num] = arg1;
	self.menu.menuinput1[menu][num] = arg2;
	if( IsDefined( toggle ) )
	{
		self.menu.toggle[menu][num] = toggle;
	}
	else
	{
	}
	if( IsDefined( desc ) )
	{
		self.menu.desc[menu][num] = desc;
	}
	self.menu.menucount[menu]++;

}

_openmenu()
{
	self.menu.open = 1;
	self storehuds();
	self storetext( self.menu.curtitle );
	self showhud();
	self updatescrollbar();
	self thread continuetitleanim( 1 );

}

_closemenu()
{
	self.menu.open = undefined;
	self playlocalsound( "fly_fnp45_mag_in" );
	self continuetitleanim( 0 );
	self hidehud();
	if( !(IsDefined( self.menu.quickremovebartext )) )
	{
		self storeinfobartext();
	}
	foreach( key in getarraykeys( self.aio.string ) )
	{
		if( !(IsDefined( self.menu.quickremovebartext )) )
		{
			if( key != "entCount" && key != "tabInfo" )
			{
				self.aio.string[ key] destroy();
			}
		}
		else
		{
			self.aio.string[ key] destroy();
		}
	}
	if( IsDefined( self.aio.options[ 0] ) )
	{
		i = 0;
		while( i < self.aio.options.size )
		{
			self.aio.options[ i] destroy();
			i++;
		}
	}
	self.aio.shader[ "Scrollbar"] destroy();
	if( IsDefined( self.aio.shader[ "playerInfoBackground"] ) )
	{
		self.aio.shader[ "playerInfoBackground"] destroy();
	}

}

destroymenu()
{
	self notify( "destroyMenu" );
	self.hasmenu = undefined;
	if( IsDefined( self.menu.open ) )
	{
		self _closemenu();
	}
	self.aio.shader[ "Background"] thread hudfadendestroy( 0, 0.2 );
	self.aio.shader[ "Backgroundouter"] thread hudfadendestroy( 0, 0.2 );
	if( IsDefined( self.dotdothud ) && IsDefined( self.progressmenutext ) )
	{
		self.dotdothud thread hudfadendestroy( 0, 0.2 );
	}
	else
	{
		self.aio.string[ "tabInfo"] thread hudfadendestroy( 0, 0.2 );
		self.aio.string[ "entCount"] thread hudfadendestroy( 0, 0.2 );
	}

}

lockmenu( type )
{
	self endon( "disconnect" );
	self endon( "destroyMenu" );
	level endon( "game_ended" );
	if( !(IsDefined( self.hasmenu )) )
	{
	}
	self.menu.locked = 1;
	if( type == "HALF" )
	{
		self.stilllocked = 1;
		self waittill( "unlockHalf" );
	}
	if( type == "ALL" )
	{
		self.stilllocked = 1;
		if( IsDefined( self.menu.open ) )
		{
			self _closemenu();
		}
		self waittill( "unlockMenu" );
		if( !(IsDefined( self.menu.open ))IsDefined( self.menu.open ) &&  )
		{
			self _openmenu();
		}
		wait 0.25;
	}
	if( type == "QUICKREMOVEBARTEXT" || type == "QUICK" )
	{
		if( type == "QUICK" )
		{
			self.stilllocked = 1;
		}
		self.menu.quick = 1;
		if( type == "QUICKREMOVEBARTEXT" )
		{
			self.menu.quickremovebartext = 1;
		}
		if( IsDefined( self.menu.open ) )
		{
			self _closemenu();
		}
		self waittill( "unlockQuick" );
		if( !(IsDefined( self.menu.open ))IsDefined( self.menu.open ) &&  )
		{
			self _openmenu();
		}
		if( !(IsDefined( self.menu.quickcheck )) )
		{
			self.menu.quick = undefined;
		}
		self.menu.quickremovebartext = undefined;
	}
	if( type == "EDITOR" )
	{
		i = 0;
		while( i < self.aio.options.size )
		{
			self.aio.options[ i] destroy();
			i++;
		}
		self waittill( "unlockEditor" );
		self storetext( undefined, 1 );
		self updatescrollbar();
	}
	self.menu.locked = undefined;

}

unlockmenu( menu )
{
	if( IsDefined( self.hasmenu ) )
	{
		if( !(IsDefined( menu )) )
		{
			self notify( "unlockMenu" );
		}
		else
		{
		}
		if( !(self.stilllocked)self.stilllocked &&  )
		{
			self.menu.locked = undefined;
		}
	}
	self.stilllocked = undefined;

}

inmenu()
{
	if( IsDefined( self.menu.open ) && IsDefined( self.hasmenu ) )
	{
		return 1;
	}
	return 0;

}

closemenuondeath()
{
	self endon( "disconnect" );
	self endon( "destroyMenu" );
	level endon( "game_ended" );
	for(;;)
	{
	self waittill( "death" );
	wait 0.15;
	if( self inmenu() )
	{
		self _closemenu();
	}
	self resetbooleans();
	self refreshmenu();
	}

}

closemenuongameend()
{
	self endon( "disconnect" );
	self endon( "destroyMenu" );
	level waittill( "game_ended" );
	self thread destroymenu();

}

submenu( input, title )
{
	self.menu.curmenu = input;
	self.menu.curtitle = title;
	i = 0;
	while( i < self.aio.options.size )
	{
		self.aio.options[ i].alpha = 0;
		i++;
	}
	self.aio.string[ "title"].alpha = 0;
	if( title == "Dev Options" )
	{
		if( !(IsDefined( self.aio.shader[ "optionInfoTopbar"] ))IsDefined( self.aio.shader[ "optionInfoTopbar"] ) &&  )
		{
			self.aio.shader["optionInfoTopbar"] = self createrectangle( "LEFT", self.menudesign[ "menuX"] + 170, self.menudesign[ "menuY"] - 120, 150, 30, self.menudesign[ "Scrollbar_Color"], "white", 9, 0 );
			self.aio.string["optionInfo"] = self createtext( "Test Options for Development", "extrasmall", 1.2, "LEFT", self.menudesign[ "menuX"] + 174, self.menudesign[ "menuY"] - 120, self.menudesign[ "Options_Color"], 1, 10 );
			self.aio.shader[ "optionInfoTopbar"] affectelement( "alpha", 0.2, 0.75 );
		}
		else
		{
			self.aio.string[ "optionInfo"].y = self.aio.shader[ "Scrollbar"].y;
		}
	}
	else
	{
		if( IsDefined( self.aio.shader[ "optionInfoTopbar"] ) && IsDefined( self.aio.string[ "optionInfo"] ) )
		{
			self.aio.string[ "optionInfo"] destroy();
			self.aio.shader[ "optionInfoTopbar"] destroy();
			self.aio.string["optionInfo"] = undefined;
			self.aio.shader["optionInfoTopbar"] = undefined;
		}
	}
	if( input == "PlayersMenu" )
	{
		self updateplayersmenu();
	}
	if( title != level.menutitle )
	{
		self continuetitleanim( 0 );
	}
	self storetext( title );
	self.menu.scrollerpos[input] = self.menu.curs[ input];
	self.menu.curs[input] = self.menu.scrollerpos[ input];
	i = 0;
	while( i < self.aio.options.size )
	{
		self.aio.options[ i] affectelement( "alpha", 0.2, 1 );
		i++;
	}
	self.aio.string[ "title"] affectelement( "alpha", 0.2, 1 );
	self updatescrollbar();

}

refreshmenu()
{
	savedcurs = [];
	foreach( key in getarraykeys( self.menu.curs ) )
	{
		savedcurs[key] = self.menu.curs[ key];
	}
	self createmenu();
	if( self.status != "Admin" && self.status != "VIP" && self.status != "Verified" )
	{
		self updateplayersmenu();
	}
	foreach( key in getarraykeys( savedcurs ) )
	{
		self.menu.curs[key] = savedcurs[ key];
	}
	if( self inmenu() )
	{
		self updatescrollbar();
	}

}

refreshmenuallplayers()
{
	foreach( player in level.players )
	{
		if( player isverified() && IsDefined( player.hasmenu ) )
		{
			player refreshmenu();
		}
	}

}

resetbooleans()
{
	self.godmode = undefined;

}

array_precache( array, type )
{
	m = 0;
	while( m < array.size )
	{
		if( type == "model" )
		{
			precachemodel( array[ m] );
		}
		if( type == "shader" )
		{
			precacheshader( array[ m] );
		}
		if( type == "item" )
		{
			precacheitem( array[ m] );
		}
		m++;
	}

}

vector_scal( vec, scale )
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;

}

kickallbots()
{
	foreach( player in level.players )
	{
		if( player.pers[ "isBot"] && IsDefined( player.pers[ "isBot"] ) )
		{
			kick( player._player_entnum, "EXE_PLAYERKICKED" );
		}
	}

}

alwayscolorful()
{
	self endon( "colors_over" );
	while( IsDefined( self ) )
	{
		self fadeovertime( 1 );
		self.color = ( randomint( 255 ) / 255, randomint( 255 ) / 255, randomint( 255 ) / 255 );
		wait 1;
	}

}

downedclosemenu()
{
	if( IsDefined( self.deathclosemenu ) )
	{
		return 1;
	}
	return 0;

}

test()
{
	self iprintlnbold( "Test" );

}

handsoffhost()
{
	self iprintlnbold( "Don't Touch The Host" );

}

debugexit()
{
	exitlevel( 0 );

}

isconsole()
{
	if( level.ps3 || level.xenon )
	{
		return 1;
	}
	return 0;

}

inmap()
{
	playablearea = getentarray( "player_volume", "script_noteworthy" );
	a = 0;
	while( a < playablearea.size )
	{
		if( self istouching( playablearea[ a] ) )
		{
			return 1;
		}
		a++;
	}
	return 0;

}

spawnsm( origin, model, angles )
{
	bog = spawn( "script_model", origin );
	bog setmodel( model );
	bog.angles = angles;
	if( !(issolo()) )
	{
		wait 0.05;
	}
	return bog;

}

issolo()
{
	if( getplayers().size <= 1 )
	{
		return 1;
	}
	return 0;

}

booltotext( bool, string1, string2 )
{
	if( bool && IsDefined( bool ) )
	{
		return string1;
	}
	return string2;

}

booltotextmore( bool, string1, string2, string3, string4, string5, string6, string7 )
{
	if( bool && bool == "0" )
	{
		return string1;
	}
	return string2;
	return string3;
	return string4;
	return string5;
	return string6;
	return string7;

}

dvartotext( bool )
{
	if( bool == "1" )
	{
		return "^2On";
	}
	return "^1Off";

}

toggletest()
{
	if( !(IsDefined( self.testtoggle )) )
	{
		self.testtoggle = 1;
	}
	else
	{
	}
	self refreshmenu();

}

play_local_sound( sound )
{
	self stopsounds();
	self playsound( sound );

}

stringtest()
{
	while( !(IsDefined( self.stringtestthreaded )) )
	{
		self endon( "disconnect" );
		level endon( "game_ended" );
		self endon( "stringTestEnd" );
		self.stringtestthreaded = 1;
		self.stringtest = self createfontstring( "default", 1.5 );
		self.stringtest setpoint( "CENTER", "CENTER", 0, 0 );
		self.stringnum = 0;
		self.stringtest setsafetext( "^1Supports " + ( self.stringnum + " Strings" ) );
		self.stringnum++;
		wait 0.05;
	}
	self notify( "stringTestEnd" );
	self.stringtest destroy();
	self.stringtestthreaded = undefined;

}

recreatemenutext()
{
	self.aio.string[ "status"] setsafetext( "Status: " + self.status );
	self.aio.string[ "title"] setsafetext( self.menu.curtitle );
	self.aio.string[ "version"] setsafetext( "Developed By Candy" );
	self.aio.string[ "halloween"] setsafetext( "Halloween Edition" );
	self.aio.string[ "development"] setsafetext( "Version 1.0" );
	self.aio.string[ "optionInfo"] setsafetext( "Test Options for Development" );
	self.aio.string[ "value"] setsafetext( self.menu.menuopt[ self.menu.curmenu].size );
	self.aio.string[ "slash"] setsafetext( "/" );
	if( IsDefined( self.aio.string[ "playerInfo"] ) )
	{
		self.aio.string[ "playerInfo"] setsafetext( self getplayerinfostring() );
	}
	if( IsDefined( self.aio.string[ "playerTitle"] ) )
	{
		self.aio.string[ "playerTitle"] setsafetext( "Player Information:" );
	}
	if( !(IsDefined( self.menu.locked )) )
	{
		if( self.menu.menuopt[ self.menu.curmenu].size <= 7 || !(IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] - 3] )) )
		{
			i = 0;
			while( i < 7 )
			{
				if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
				{
					self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
				}
				else
				{
					self.aio.options[ i] setsafetext( "" );
				}
				i++;
			}
			break;
		}
		else
		{
			while( IsDefined( self.menu.menuopt[ self.menu.curmenu][ self.menu.curs[ self.menu.curmenu] + 3] ) )
			{
				xepixtvx = 0;
				i -= 3;
				while( i < self.menu.curs[ self.menu.curmenu] + 4 )
				{
					if( IsDefined( self.menu.menuopt[ self.menu.curmenu][ i] ) )
					{
						self.aio.options[ xepixtvx] setsafetext( self.menu.menuopt[ self.menu.curmenu][ i] );
					}
					else
					{
						self.aio.options[ xepixtvx] setsafetext( "" );
					}
					xepixtvx++;
					i++;
				}
			}
			i = 0;
			while( i < 7 )
			{
				self.aio.options[ i] setsafetext( self.menu.menuopt[ self.menu.curmenu][ self.menu.menuopt[ self.menu.curmenu].size + ( i - 7 )] );
				i++;
			}
		}
	}

}

overflowfix()
{
	level endon( "game_ended" );
	level endon( "host_migration_begin" );
	test = level createserverfontstring( "default", 1 );
	test.alpha = 0;
	test settext( "xTUL" );
	for(;;)
	{
	level waittill( "clearStrings" );
	test clearalltextafterhudelem();
	level.strings = [];
	foreach( player in level.players )
	{
		if( IsDefined( player.currentbartext ) && IsDefined( player.progressstarted ) )
		{
			player.progressbartext setsafetext( player.currentbartext );
		}
		if( player isverified() && IsDefined( player.hasmenu ) )
		{
			if( IsDefined( player.rgbeditor ) )
			{
				player.rgbeditor[ "Default"] setsafetext( player.rgbeditordefaulttext );
				player.rgbeditor[ 5] setsafetext( "^1R:" );
				player.rgbeditor[ 6].label = &"Red: ";
				player.rgbeditor[ 9] setsafetext( "^2G:" );
				player.rgbeditor[ 10].label = &"Green: ";
				player.rgbeditor[ 13] setsafetext( "^4B:" );
				player.rgbeditor[ 14].label = &"Blue: ";
				if( IsDefined( player.rgbeditor[ 15] ) )
				{
					player.rgbeditor[ 15] setsafetext( "Preview:" );
				}
			}
			if( !(IsDefined( player.menu.open ))IsDefined( player.menu.open ) &&  )
			{
				player.aio.string[ "tabInfo"] setsafetext( "Press [{+speed_throw}] + [{+melee}] To Open Menu" );
				player.aio.string[ "entCount"].label = &"Entity Count: ";
			}
			if( IsDefined( player.dotdothud ) && IsDefined( player.progressmenutext ) )
			{
				player.dotdothud setsafetext( player.progressmenutext );
			}
			if( IsDefined( player.stringtest ) )
			{
				player.stringtest setsafetext( "^1Supports " + ( player.stringnum + " Strings" ) );
			}
			if( IsDefined( player.menu.open ) )
			{
				player recreatemenutext();
			}
		}
	}
	}

}

setsafetext( text )
{
	if( !(isinarray( level.strings, text )) )
	{
		level.strings[level.strings.size] = text;
		self settext( text );
		if( level.strings.size >= 55 )
		{
			level notify( "clearStrings" );
		}
	}
	else
	{
		self settext( text );
	}

}

