//Decompiled with SeriousHD-'s GSC Decompiler
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_spectating;
init()
{
	initializeaesthetics();
	level thread onplayerconnect();
	level.gts = "SEARCH AND DESTROY";
	precachestring( level.gts );
	level._get_game_module_players = undefined;
	level.zombie_team = "team3";
	level.teambased = 1;
	level.overrideplayerdeathwatchtimer = undefined;
	precacheshader( "damage_feedback" );
	precacheshader( "menu_zm_popup" );
	precacheshader( "white" );
	precacheshader( "gradient_center" );
	precacheshader( "ui_sliderbutt_1" );
	precacheshader( "circle" );
	precacheshader( "menu_zm_background_main" );
	precacheshader( "waypoint_revive" );
	precacheshader( "menu_zm_background_main" );
	precachemodel( "test_sphere_silver" );
	precacheshader( "specialty_instakill_zombies" );
	setdvar( "player_meleeDamageMultiplier", 1 );
	setdvar( "tu3_canSetDvars", "1" );
	setdvar( "g_friendlyfireDist", "0" );
	setdvar( "allClientDvarsEnabled", "1" );
	setdvar( "party_gameStartTimerLength", "1" );
	setdvar( "party_gameStartTimerLengthPrivate", "1" );
	setdvar( "bg_viewKickScale", "0.0001" );
	setdvar( "scr_disable_weapondrop", 0 );
	if( getdvar( "party_connectToOthers" ) == "1" )
	{
		level.nomatchoverride = 1;
	}
	level.killcamlength = 5;
	level.zombie_vars["riotshield_hit_points"] = 25000;
	setdvar( "party_connectToOthers", "0" );
	setdvar( "partyMigrate_disabled", "1" );
	setdvar( "party_mergingEnabled", "0" );
	flag_set( "sq_minigame_active" );
	level.zombie_vars["riotshield_gib_damage"] = 99999;
	level.zombie_vars["riotshield_knockdown_damage"] = 99999;
	level.player_out_of_playable_area_monitor = 0;
	level.player_too_many_weapons_monitor = 0;
	level.player_intersection_tracker_override = ::_zm_arena_intersection_override;
	level.player_too_many_players_check = 0;
	level.player_out_of_playable_area_monitor = 0;
	level.player_too_many_players_check_func = ::player_too_many_players_check;
	level.is_player_in_screecher_zone = ::_zm_arena_false_function;
	level.screecher_should_runaway = ::_zm_arena_true_function;
	level.custom_spectate_permissions = setspectatepermissionsgrief();
	kc_init();
	level.callbackplayerlaststand = ::callback_playerkilled;

}

player_too_many_players_check()
{

}

_zm_arena_intersection_override( player )
{
	self waittill( "forever" );
	return 0;

}

_zm_arena_false_function( player )
{
	return 0;

}

_zm_arena_true_function( player )
{
	return 1;

}

onplayerconnect()
{
	for(;;)
	{
	level waittill( "connected", player );
	player thread onplayerspawned();
	player thread ondisconnectmipmapfix();
	}

}

onplayerspawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self.has_zsndbomb = 0;
	if( self ishost() )
	{
		level.ctext = level createserverfontstring( "default", 1.7 );
		level.ctext setpoint( "LEFT", "TOP", -380, 70 );
		level.ctext.color = ( 1, 0.5, 0 );
		level.ctext.alpha = 0;
		level.ctext.glowcolor = ( 0, 0, 0 );
		level.ctext.glowalpha = 0;
		level.ctext.sort = 999;
		level.ctext settext( "SEARCH AND DESTROY" );
		level.ctext.foreground = 1;
		level.ctext.hidewheninmenu = 0;
		level.ctext.archived = 1;
		level.zsnd_readyplayers = 0;
		level.zsnd_lastround = 0;
	}
	self waittill( "spawned_player" );
	self.kill_streak = 0;
	if( self ishost() )
	{
		level.ctext fadeovertime( 0.75 );
		level.ctext.alpha = 1;
		level thread gameengine();
	}
	for(;;)
	{
	self waittill( "spawned_player" );
	self thread zsndrespawned();
	}

}

ondisconnectmipmapfix()
{
	level endon( "end_game" );
	self waittill( "disconnect" );
	wait 1.5;
	foreach( player in level.players )
	{
		player.playershaders[ self.name] destroy();
	}

}

gameengine()
{
	flag_wait( "start_zombie_round_logic" );
	level.zsnd_round_started = 0;
	level.zsnd_readyplayers = 0;
	level.zsnd_bomb_detonated = 0;
	level.zsnd_bomb_defused = 0;
	level.roundendkilling = 0;
	if( getdvar( "mapname" ) == "zm_prison" )
	{
		bool = 0;
		b_everyone_alive = 0;
		while( !(b_everyone_alive)b_everyone_alive &&  )
		{
			b_everyone_alive = 1;
			a_players = getplayers();
			foreach( player in a_players )
			{
				if( player.afterlife && IsDefined( player.afterlife ) )
				{
					b_everyone_alive = 0;
					wait 0.05;
					break;
				}
				else
				{
				}
			}
		}
		wait 3;
		foreach( player in level.players )
		{
			player.lives = 0;
			player.pers["lives"] = 0;
			player setclientfieldtoplayer( "player_lives", player.lives );
			player notify( "stop_player_out_of_playable_area_monitor" );
		}
	}
	foreach( player in level.players )
	{
		player enableinvulnerability();
	}
	level.cloaderscreen = newhudelem();
	level.cloaderscreen.elemtype = "icon";
	level.cloaderscreen.color = ( 0, 0, 0 );
	level.cloaderscreen.alpha = 1;
	level.cloaderscreen.sort = 9;
	level.cloaderscreen.foreground = 0;
	level.cloaderscreen.children = [];
	level.cloaderscreen setparent( level.uiparent );
	level.cloaderscreen setshader( "white", 900, 500 );
	level.cloaderscreen setpoint( "CENTER", "CENTER", 0, 0 );
	level.cloaderscreen.hidewheninmenu = 0;
	level.cloaderscreen.archived = 1;
	level.ctext changefontscaleovertime( 1.2 );
	level.ctext.fontscale = 2.5;
	level.ctext moveovertime( 1.2 );
	level.ctext.y = level.ctext.y - 50;
	level.zombie_ghost_round_states.is_first_ghost_round_finished = 1;
	level.force_ghost_round_start = undefined;
	level.zombie_ghost_round_states.next_ghost_round_number = 999;
	level.zombie_ghost_round_states.current_ghost_round_number = 998;
	level endon( "end_game" );
	setscoreboardcolumns( "score", "kills", "downs", "", "" );
	if( !(IsDefined( level.nomatchoverride )) )
	{
		setmatchflag( "disableIngameMenu", 1 );
	}
	assignteams();
	setmatchtalkflag( "DeadChatWithDead", 1 );
	setmatchtalkflag( "DeadChatWithTeam", 0 );
	setmatchtalkflag( "DeadHearTeamLiving", 0 );
	setmatchtalkflag( "DeadHearAllLiving", 0 );
	setmatchtalkflag( "EveryoneHearsEveryone", 0 );
	setmatchtalkflag( "DeadHearKiller", 0 );
	setmatchtalkflag( "KillersHearVictim", 0 );
	setmatchflag( "final_killcam", 0 );
	setmatchflag( "round_end_killcam", 0 );
	level.zombie_vars["spectators_respawn"] = 0;
	setdvar( "player_lastStandBleedoutTime", 1 );
	level.zombie_vars["penalty_no_revive"] = 0;
	level.zombie_vars["penalty_died"] = 0;
	level.zombie_vars["penalty_downed"] = 0.05;
	level.brutus_spawners = undefined;
	level.no_end_game_check = 1;
	level.player_friendly_fire_callbacks = undefined;
	_zm_arena_openalldoors();
	foreach( door in getentarray( "afterlife_door", "script_noteworthy" ) )
	{
		door thread door_opened( 0 );
		wait 0.005;
	}
	foreach( debri in getentarray( "zombie_debris", "targetname" ) )
	{
		debri.zombie_cost = 0;
		debri notify( "trigger", level.players[ 0], 1 );
		wait 0.005;
	}
	level.zsnd_intermission = 1;
	level.players[ 0] iprintln( "" );
	level.zsnd_bomb_planted = 0;
	n_between_round_time = level.zombie_vars[ "zombie_between_round_time"];
	level.zombie_vars["zombie_new_runner_interval"] = 3;
	level.zombie_ai_limit = 52;
	level.zombie_vars["zombie_max_ai"] = 52;
	level.zombie_vars["zombie_move_speed_multiplier"] = 180;
	level.zombie_vars["zombie_between_round_time"] = 0.01;
	level.zombie_vars["zombie_spawn_delay"] = 0.1;
	level.zombie_actor_limit = 5;
	target = 5;
	level.time_bomb_round_change = 1;
	level.zombie_round_start_delay = 0;
	level.zombie_round_end_delay = 0;
	level._time_bomb.round_initialized = 1;
	n_between_round_time = level.zombie_vars[ "zombie_between_round_time"];
	level notify( "end_of_round" );
	flag_set( "end_round_wait" );
	ai_calculate_health( target );
	if( level._time_bomb.round_initialized )
	{
		level._time_bomb.restoring_initialized_round = 1;
		target++;
	}
	level.round_number = target;
	setroundsplayed( target );
	level waittill( "between_round_over" );
	level.zombie_round_start_delay = undefined;
	level.time_bomb_round_change = undefined;
	flag_clear( "end_round_wait" );
	level.round_number = 5;
	level.players[ 0] iprintln( "" );
	setdvar( "g_ai", "0" );
	level.players[ 0] iprintln( "" );
	level thread z_snd_intro();
	level.zsnd_intialized = 0;
	foreach( player in level.players )
	{
		player thread zsndrespawned();
	}
	level.allies_rounds = 0;
	level.axis_rounds = 0;
	totalrounds = 0;
	level.zsnd_timer_over = 1;
	level thread zsnd_timer();
	level.players[ 0] iprintln( "" );
	while( level.axis_rounds < 4 && level.allies_rounds < 4 )
	{
		setmatchtalkflag( "DeadChatWithDead", 1 );
		setmatchtalkflag( "DeadChatWithTeam", 0 );
		setmatchtalkflag( "DeadHearTeamLiving", 0 );
		setmatchtalkflag( "DeadHearAllLiving", 0 );
		setmatchtalkflag( "EveryoneHearsEveryone", 0 );
		setmatchtalkflag( "DeadHearKiller", 0 );
		setmatchtalkflag( "KillersHearVictim", 0 );
		setmatchflag( "final_killcam", 0 );
		setmatchflag( "round_end_killcam", 0 );
		level thread dofinalkillcam();
		level.zsnd_round_started = 0;
		level.zsnd_readyplayers = 0;
		level.zsnd_bomb_detonated = 0;
		level.zsnd_bomb_defused = 0;
		level.zsnd_bomb_planted = 0;
		level.infinalkillcam = 0;
		level.zsnd_timeleft = 180;
		setslowmotion( 0.25, 1, 1 );
		gameobjectsinitialize();
		level.zsnd_intialized = 1;
		level.zsnd_intermission = 0;
		foreach( player in level.players )
		{
			player thread zsndrespawned();
			player notify( "end_killcam" );
		}
		while( level.zsnd_readyplayers / level.players.size < 0.5 )
		{
			wait 0.25;
		}
		setdvar( "g_ai", "0" );
		doroundcountdown();
		setdvar( "g_ai", "1" );
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			foreach( player in level.players )
			{
				player.lives = 0;
				player.pers["lives"] = 0;
				player setclientfieldtoplayer( "player_lives", player.lives );
			}
		}
		level.zsnd_timer_over = 0;
		giverandomaxisplayerabomb();
		foreach( player in level.players )
		{
			player notify( "ZSND_round_start" );
		}
		level.zsnd_round_started = 1;
		while( level.zsnd_timeleft > 0 && getalliescount() > 0 && !(level.zsnd_bomb_defused)level.zsnd_bomb_defused ||  )
		{
			if( !(level.zsnd_bomb_planted)level.zsnd_bomb_planted &&  )
			{
				break;
			}
			else
			{
				wait 1;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		setmatchtalkflag( "EveryoneHearsEveryone", 1 );
		level notify( "zSND_ROUND_COMPLETE" );
		level.zsnd_timer_over = 1;
		level.zsnd_intermission = 1;
		setdvar( "g_ai", "0" );
		gameobjectscleanup();
		wait 0.01;
		if( getalliescount() < 1 || level.zsnd_bomb_detonated )
		{
			winnersare( "axis" );
		}
		else
		{
			winnersare( "allies" );
		}
		totalrounds++;
		if( totalrounds == 6 || totalrounds == 3 )
		{
			oldscore = level.axis_rounds;
			level.axis_rounds = level.allies_rounds;
			level.allies_rounds = oldscore;
			foreach( player in level.players )
			{
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player setteam( "allies", "axis" );
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player.team = "allies";
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player.pers["team"] = "allies";
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player._encounters_team = "allies";
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player._team_name = &"ZOMBIE_RACE_TEAM_2";
				if( player.sessionteam == "allies" )
				{
				}
				else
				{
				}
				player.sessionteam = "allies";
				player notify( "joined_team" );
				level notify( "joined_team" );
			}
		}
	}
	setslowmotion( 0.25, 1, 1 );
	while( level.allies_rounds > 3 )
	{
		foreach( player in level.players )
		{
			if( player.sessionteam == "allies" )
			{
			}
			else
			{
			}
			if( player.sessionteam == "allies" )
			{
			}
			else
			{
			}
			player.scorestext = player drawtext( "WON" + "LOST", "YOU ", "default", 2, "CENTER", "TOP", 0, 25, ( 1, 0, 0 ), ( 0, 1, 0 ), 1, ( 0, 0, 0 ), 0, 9 );
		}
	}
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
		}
		else
		{
		}
		if( player.sessionteam == "axis" )
		{
		}
		else
		{
		}
		player.scorestext = player drawtext( "WON" + "LOST", "YOU ", "default", 2, "CENTER", "TOP", 0, 25, ( 1, 0, 0 ), ( 0, 1, 0 ), 1, ( 0, 0, 0 ), 0, 9 );
	}
	foreach( player in level.players )
	{
		player thread playergiveshotguns();
	}
	wait 4;
	level notify( "end_game" );

}

getteamcount( team )
{
	count = 0;
	foreach( player in level.players )
	{
		if( player.sessionteam == team )
		{
			count++;
		}
	}
	return 0;

}

getaxiscount()
{
	count = 0;
	foreach( player in level.players )
	{
		if( player.sessionstate != "dead" && player.sessionstate != "spectator" && player.sessionteam == "axis" )
		{
			count++;
		}
	}
	return count;

}

getalliescount()
{
	count = 0;
	foreach( player in level.players )
	{
		if( player.sessionstate != "dead" && player.sessionstate != "spectator" && player.sessionteam == "allies" )
		{
			count++;
		}
	}
	return count;

}

winnersare( team )
{
	level.finalkillcam_winner = team;
	setdvar( "g_ai", "0" );
	level.roundendkilling = 1;
	foreach( player in level.players )
	{
		if( player.sessionstate != "spectator" )
		{
			player enableinvulnerability();
			player freezecontrols( 1 );
		}
	}
	if( team == "allies" )
	{
		level.allies_rounds++;
	}
	else
	{
	}
	if( team == "allies" )
	{
		level.winnertext = level drawtext( "Defenders win", "default", 2, "CENTER", "TOP", 0, 0, ( 1, 1, 0 ), 1, ( 0, 0, 0 ), 0, 9 );
	}
	else
	{
	}
	level.scorestext = level drawtext( "Defenders: " + ( level.allies_rounds + ( " | Attackers: " + level.axis_rounds ) ), "default", 2, "CENTER", "TOP", 0, 25, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 9 );
	if( level.axis_rounds >= 4 || level.allies_rounds >= 4 )
	{
		level.zsnd_lastround = 1;
	}
	postroundfinalkillcam();
	wait 2;
	foreach( team1 in level.teams )
	{
		clearfinalkillcamteam( team1 );
	}
	level.roundendkilling = 0;
	level.winnertext destroy();
	level.scorestext destroy();

}

zsndrespawned()
{
	self notify( "zns_rsp" );
	self endon( "zns_rsp" );
	while( level.infinalkillcam || level.zsnd_intermission )
	{
		wait 0.25;
	}
	self.has_zsndbomb = 0;
	while( !(level.zsnd_intialized) )
	{
		wait 0.25;
	}
	if( self.sessionstate == "spectator" )
	{
		if( IsDefined( self.spectate_hud ) )
		{
			self.spectate_hud destroy();
		}
		self [[  ]]();
	}
	while( self.sessionstate == "spectator" )
	{
		wait 1;
	}
	self endkillcam( 0 );
	self notify( "end_killcam" );
	self setclientthirdperson( 0 );
	self setdepthoffield( 0, 0, 512, 4000, 4, 0 );
	self disableinvulnerability();
	self freezecontrols( 0 );
	if( IsDefined( self.bombhud ) )
	{
		self.bombhud destroy();
	}
	if( self.sessionteam == "axis" )
	{
		self.characterindex = 0;
	}
	else
	{
	}
	self givecustomcharacters_zsnd();
	self setclientminiscoreboardhide( 1 );
	self thread showteamtext();
	self disableweapons();
	spawnmeincorrectspot();
	classselectionscreen();
	self thread onshotpingradar();
	self thread waitforplayeractions();
	self thread damagemonitorfromplayers();
	self enableaimassist();
	cleanoldminimap();
	self thread zminimap();
	self.magic_bullet_shield = 0;
	self notify( "pers_flopper_lost" );
	self.pers_num_flopper_damages = 0;
	self notify( "stop_player_too_many_weapons_monitor" );
	self notify( "stop_player_out_of_playable_area_monitor" );
	self.lives = 0;
	self.no_revive_trigger = 1;
	self waittill( "ZSND_round_start" );
	self enableweapons();
	self unlink();
	self.stopperobj delete();
	self.maxhealth = 800;
	self.health = 800;
	while( !(self.laststand)self.laststand ||  )
	{
		wait 0.25;
	}
	self.laststand = 0;
	self.kill_streak = 0;
	if( IsDefined( self.lastattacker ) )
	{
		if( self.lastattacker != self )
		{
			self.lastattacker notify( "ZSND_ACTION", "KILL", 1500 );
		}
		self thread killfeed( self.lastattacker.name );
		self.lastattacker = undefined;
	}
	else
	{
		self thread killfeed( "Zombies" );
	}
	while( self.sessionstate != "spectator" )
	{
		wait 1;
	}
	foreach( player in level.players )
	{
		player.playershaders[ self.name] destroy();
	}
	self.dead_from_snd = 1;
	self waittill( "ZSND_round_switched" );
	if( self.sessionstate == "spectator" )
	{
		if( IsDefined( self.spectate_hud ) )
		{
			self.spectate_hud destroy();
		}
		self [[  ]]();
	}

}

damagemonitorfromplayers()
{
	self notify( "NewZDMonitor" );
	self endon( "NewZDMonitor" );
	wep = undefined;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		if( isplayer( attacker ) )
		{
			self.lastattacker = attacker;
			wep = attacker getcurrentweapon();
			if( wep == "ray_gun_zm" )
			{
				self dodamage( amount * 2, self.origin, attacker );
			}
			if( wep == "slipgun_zm" )
			{
				self dodamage( amount * 5, self.origin, attacker );
			}
			if( wep == "raygun_mark2_zm" )
			{
				self dodamage( amount, self.origin, attacker );
			}
			if( attacker.current_tomahawk_weapon == "upgraded_tomahawk_zm" && IsDefined( attacker.current_tomahawk_weapon ) && mod == "MOD_GRENADE" && level.script == "zm_prison" )
			{
				self dodamage( amount * 999, self.origin, attacker );
			}
			if( wep == "tomb_shield_zm" || wep == "riotshield_zm" || wep == "alcatraz_shield_zm" )
			{
				self dodamage( 200, self.origin, attacker );
			}
			if( self.health <= 1 )
			{
				attacker notify( "ZSND_ACTION", "DEATHHITMARKER", 1500 );
			}
			else
			{
			}
		}
	}

}

waitforplayeractions()
{
	self notify( "newactionmonitor" );
	self endon( "newactionmonitor" );
	self.hitmarker destroy();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );
	self.hitsoundtracker = 1;
	self.kill_streak = 0;
	while( 1 )
	{
		self waittill( "ZSND_ACTION", action, value );
		if( action == "KILL" )
		{
			self.kill_streak++;
			self notify( self.kill_streak + "_ks_achieved" );
			if( self.kill_streak > 10 )
			{
				self thread killstreak();
			}
		}
		if( action == "HITMARKER" )
		{
			self whitemarker();
		}
		if( action == "DEATHHITMARKER" )
		{
			self redmarker();
		}
	}

}

redmarker()
{
	self notify( "red_override" );
	self thread playhitsound( UNDEFINED_LOCAL, "mpl_hit_alert" );
	self.hitmarker.alpha = 1;
	self.hitmarker.color = ( 1, 0, 0 );
	self.hitmarker fadeovertime( 0.5 );
	self.hitmarker.color = ( 1, 1, 1 );
	self.hitmarker.alpha = 0;

}

whitemarker()
{
	self endon( "red_override" );
	self thread playhitsound( UNDEFINED_LOCAL, "mpl_hit_alert" );
	self.hitmarker.alpha = 1;
	self.hitmarker fadeovertime( 0.5 );
	self.hitmarker.alpha = 0;

}

playhitsound( mod, alert )
{
	self endon( "disconnect" );
	if( self.hitsoundtracker )
	{
		self.hitsoundtracker = 0;
		self playlocalsound( alert );
		wait 0.05;
		self.hitsoundtracker = 1;
	}

}

assignteams()
{
	j = randomintrange( 0, 2 );
	possible = array_copy( level.players );
	possible = array_randomize( possible );
	i = 0;
	while( i < possible.size )
	{
		j = !(j);
		if( j )
		{
		}
		else
		{
		}
		possible[ i] setteam( "allies", "axis" );
		if( j )
		{
		}
		else
		{
		}
		possible[ i].team = "allies";
		if( j )
		{
		}
		else
		{
		}
		possible[ i].pers["team"] = "allies";
		if( j )
		{
		}
		else
		{
		}
		possible[ i].sessionteam = "allies";
		if( j )
		{
		}
		else
		{
		}
		possible[ i]._encounters_team = "allies";
		if( j )
		{
		}
		else
		{
		}
		possible[ i]._team_name = &"ZOMBIE_RACE_TEAM_2";
		possible[ i] notify( "joined_team" );
		level notify( "joined_team" );
		i++;
	}

}

setspectatepermissionsgrief()
{
	self allowspectateteam( "allies", 1 );
	self allowspectateteam( "axis", 1 );
	self allowspectateteam( "freelook", 0 );
	self allowspectateteam( "none", 1 );

}

classselectionscreen()
{
	self endon( "zns_rsp" );
	self.pickedclass = 0;
	self.stopperobj = spawn( "script_origin", self.origin, 1 );
	self playerlinkto( self.stopperobj, undefined );
	self freezecontrols( 0 );
	self.classoptionsbg destroy();
	self.classoption0 destroy();
	self.classoptions[ 0] destroy();
	self.classoptions[ 1] destroy();
	self.classoptions[ 2] destroy();
	self.classoptions[ 3] destroy();
	self.classoptions[ 4] destroy();
	self.classoptions[ 5] destroy();
	self.classoptions[ 6] destroy();
	self.classoptions[ 7] destroy();
	self.classoptions[ 8] destroy();
	self.classoptions[ 9] destroy();
	self.cco_primary_slot destroy();
	self.cco_secondary_slot destroy();
	self.cco_lethal_slot destroy();
	self.cco_melee_slot destroy();
	self.cco_tactical_slot destroy();
	self.classoptions = [];
	self.classoption0 = drawtext( "[{+gostand}] Select	[{+actionslot 1}] Scroll Up	[{+actionslot 2}] Scroll Down", "default", 1.25, "CENTER", "BOTTOM", 0, 0, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[0] = drawtext( "SMG", "default", 1.75, "LEFT", "TOP", -350, 75, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[1] = drawtext( "Sniper", "default", 1.75, "LEFT", "TOP", -350, 100, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[2] = drawtext( "Raygun", "default", 1.75, "LEFT", "TOP", -350, 125, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[3] = drawtext( "Shotgun", "default", 1.75, "LEFT", "TOP", -350, 150, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[4] = drawtext( "Specialist", "default", 1.75, "LEFT", "TOP", -350, 175, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[5] = drawtext( "Ninja", "default", 1.75, "LEFT", "TOP", -350, 200, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[6] = drawtext( "Trickshotter", "default", 1.75, "LEFT", "TOP", -350, 225, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[7] = drawtext( "Support", "default", 1.75, "LEFT", "TOP", -350, 250, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[8] = drawtext( "Pistol Beast", "default", 1.75, "LEFT", "TOP", -350, 275, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptions[9] = drawtext( "Specialist 2", "default", 1.75, "LEFT", "TOP", -350, 300, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	self.classoptionsbg = createshader( "white", "CENTER", "CENTER", 0, 0, 900, 500, ( 0, 0, 0 ), 0.8, 0 );
	self setblur( 4, 0.1 );
	sclass = 0;
	self enableweaponcycling();
	self.classoptions[ sclass].color = ( 1, 0.5, 0 );
	updateccitemsinventory( sclass );
	while( !(self.pickedclass)self.pickedclass &&  )
	{
		if( self jumpbuttonpressed() )
		{
			self selectclass( sclass );
			break;
		}
		else
		{
			while( self actionslotonebuttonpressed() )
			{
				self.classoptions[ sclass].color = ( 1, 1, 1 );
				sclass++;
				if( sclass < 0 )
				{
					sclass = 9;
				}
				self.classoptions[ sclass].color = ( 1, 0.5, 0 );
				updateccitemsinventory( sclass );
				while( self actionslotonebuttonpressed() )
				{
					wait 0.05;
				}
			}
			if( self actionslottwobuttonpressed() )
			{
				self.classoptions[ sclass].color = ( 1, 1, 1 );
				sclass++;
				if( sclass > 9 )
				{
					sclass = 0;
				}
				self.classoptions[ sclass].color = ( 1, 0.5, 0 );
				updateccitemsinventory( sclass );
				while( !(self.pickedclass)self.pickedclass && !(level.zsnd_round_started)level.zsnd_round_started )
				{
					wait 0.05;
				}
			}
		}
		wait 0.05;
	}
	self.classoption0 destroy();
	self.classoptions[ 0] destroy();
	self.classoptions[ 1] destroy();
	self.classoptions[ 2] destroy();
	self.classoptions[ 3] destroy();
	self.classoptions[ 4] destroy();
	self.classoptions[ 5] destroy();
	self.classoptions[ 6] destroy();
	self.classoptions[ 7] destroy();
	self.classoptions[ 8] destroy();
	self.classoptions[ 9] destroy();
	self.classoptionsbg destroy();
	self.cco_primary_slot destroy();
	self.cco_secondary_slot destroy();
	self.cco_lethal_slot destroy();
	self.cco_melee_slot destroy();
	self.cco_tactical_slot destroy();
	level.zsnd_readyplayers++;
	self setblur( 0, 0.1 );
	if( !(self.pickedclass) )
	{
		self dodamage( 999, self.origin );
	}

}

selectclass( class )
{
	perks = undefined;
	self.ignoreme = 0;
	self takeallweapons();
	self setclientuivisibilityflag( "hud_visible", 0 );
	perks = strtok( "specialty_additionalprimaryweapon,specialty_armorpiercing,specialty_armorvest,specialty_bulletaccuracy,specialty_bulletdamage,specialty_bulletflinch,specialty_bulletpenetration,specialty_deadshot,specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_earnmoremomentum,specialty_explosivedamage,specialty_extraammo,specialty_fallheight,specialty_fastads,specialty_fastequipmentuse,specialty_fastladderclimb,specialty_fastmantle,specialty_fastmeleerecovery,specialty_fastreload,specialty_fasttoss,specialty_fastweaponswitch,specialty_finalstand,specialty_fireproof,specialty_flakjacket,specialty_flashprotection,specialty_gpsjammer,specialty_grenadepulldeath,specialty_healthregen,specialty_holdbreath,specialty_immunecounteruav,specialty_immuneemp,specialty_immunemms,specialty_immunenvthermal,specialty_immunerangefinder,specialty_killstreak,specialty_longersprint,specialty_loudenemies,specialty_marksman,specialty_movefaster,specialty_nomotionsensor,specialty_noname,specialty_nottargetedbyairsupport,specialty_nokillstreakreticle,specialty_nottargettedbysentry,specialty_pin_back,specialty_pistoldeath,specialty_proximityprotection,specialty_quickrevive,specialty_quieter,specialty_reconnaissance,specialty_rof,specialty_scavenger,specialty_showenemyequipment,specialty_stunprotection,specialty_shellshock,specialty_sprintrecovery,specialty_showonradar,specialty_stalker,specialty_twogrenades,specialty_twoprimaries,specialty_unlimitedsprint", "," );
	foreach( perk in perks )
	{
		self unsetperk( perk );
	}
	if( class == 0 )
	{
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			self giveweapon( "tazer_knuckles_zm" );
		}
		self weapon_give( "cymbal_monkey_zm", 0, 0 );
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self weapon_give( "fiveseven_zm", 0, 0 );
		if( getdvar( "mapname" ) == "zm_buried" || getdvar( "mapname" ) == "zm_highrise" )
		{
			self weapon_give( "pdw57_zm", 0, 0 );
		}
		else
		{
			if( getdvar( "mapname" ) == "zm_tomb" )
			{
				self weapon_give( "thompson_zm", 0, 0 );
			}
			else
			{
				self weapon_give( "mp5k_zm", 0, 0 );
			}
		}
		perks = strtok( "specialty_unlimitedsprint,specialty_sprintrecovery,specialty_rof,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fasttoss,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_extraammo,specialty_armorvest,specialty_bulletflinch", "," );
	}
	if( class == 2 )
	{
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			self giveweapon( "tazer_knuckles_zm" );
		}
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self weapon_give( "knife_ballistic_zm", 0, 0 );
		self weapon_give( "ray_gun_zm", 0, 0 );
		self switchtoweapon( "ray_gun_zm" );
		perks = strtok( "specialty_unlimitedsprint,specialty_stalker,specialty_rof,specialty_quieter,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fastreload,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_armorvest,specialty_bulletflinch", "," );
	}
	if( class == 1 )
	{
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			self giveweapon( "tazer_knuckles_zm" );
		}
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self weapon_give( "dsr50_zm", 0, 0 );
		self weapon_give( "fivesevendw_zm", 0, 0 );
		self switchtoweapon( "dsr50_zm" );
		perks = strtok( "specialty_scavenger,specialty_reconnaissance,specialty_quieter,specialty_quickrevive,specialty_marksman,specialty_loudenemies,specialty_longersprint,specialty_holdbreath,specialty_gpsjammer,specialty_fastweaponswitch,specialty_fasttoss,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fallheight,specialty_deadshot,specialty_armorvest,specialty_armorpiercing,specialty_bulletaccuracy,specialty_bulletdamage,specialty_bulletpenetration", "," );
	}
	if( class == 3 )
	{
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			self giveweapon( "tazer_knuckles_zm" );
		}
		self weapon_give( "m14_zm", 0, 0 );
		self weapon_give( "870mcs_zm", 0, 0 );
		self weapon_give( "frag_grenade_zm", 0, 0 );
		perks = strtok( "specialty_unlimitedsprint,specialty_stalker,specialty_rof,specialty_quieter,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fastreload,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_armorvest,specialty_bulletflinch", "," );
	}
	if( class == 4 )
	{
		if( level.script == "zm_transit" )
		{
			self weapon_give( "riotshield_zm", 0, 0 );
			self weapon_give( "sticky_grenade_zm", 0, 0 );
			self weapon_give( "m1911_zm", 0, 0 );
			self switchtoweapon( "riotshield_zm" );
		}
		if( level.script == "zm_nuked" )
		{
			self weapon_give( "sticky_grenade_zm", 0, 0 );
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "m1911_zm", 0, 0 );
			self weapon_give( "raygun_mark2_zm", 0, 0 );
			self switchtoweapon( "raygun_mark2_zm" );
		}
		if( level.script == "zm_highrise" )
		{
			self weapon_give( "sticky_grenade_zm", 0, 0 );
			self weapon_give( "slipgun_zm", 0, 0 );
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "equip_springpad_zm", 0, 0 );
			self switchtoweapon( "slipgun_zm" );
			self thread dierisespecialistweapon();
		}
		if( level.script == "zm_prison" )
		{
			self weapon_give( "m1911_zm", 0, 0 );
			self weapon_give( "alcatraz_shield_zm", 0, 0 );
			flag_set( "soul_catchers_charged" );
			level notify( "bouncing_tomahawk_zm_aquired" );
			self notify( "tomahawk_picked_up" );
			self notify( "player_obtained_tomahawk" );
			self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
			self setclientfieldtoplayer( "tomahawk_in_use", 1 );
			self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
			self.loadout.hastomahawk = 1;
			self weapon_give( "upgraded_tomahawk_zm", 0, 0 );
			self notify( "new_tactical_grenade" );
			self.current_tactical_grenade = self.current_tomahawk_weapon;
			self switchtoweapon( "alcatraz_shield_zm" );
		}
		if( level.script == "zm_buried" )
		{
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "rnma_zm", 0, 0 );
			self thread buriedspecialistweapon();
		}
		if( level.script == "zm_tomb" )
		{
			self weapon_give( "c96_zm", 0, 0 );
			self weapon_give( "tomb_shield_zm", 0, 0 );
			self switchtoweapon( "tomb_shield_zm" );
		}
		perks = strtok( "specialty_unlimitedsprint,specialty_stalker,specialty_rof,specialty_quieter,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fastreload,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_armorvest,specialty_bulletflinch", "," );
	}
	if( class == 5 )
	{
		if( level.script == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			if( level.script == "zm_tomb" )
			{
				self weapon_give( "staff_lightning_melee_zm", 0, 0 );
			}
			else
			{
				self weapon_give( "bowie_knife_zm", 0, 0 );
			}
		}
		self.ignoreme = 1;
		perks = strtok( "specialty_unlimitedsprint,specialty_stalker,specialty_rof,specialty_quieter,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fastreload,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_armorvest,specialty_bulletflinch,specialty_movefaster", "," );
		self setmovespeedscale( 1.25 );
	}
	if( class == 6 )
	{
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self weapon_give( "sticky_grenade_zm", 0, 0 );
		self weapon_give( "knife_zm", 0, 0 );
		if( level.script != "zm_tomb" )
		{
			self weapon_give( "rottweil72_zm", 0, 0 );
		}
		else
		{
			self weapon_give( "ksg_zm", 0, 0 );
		}
		if( level.script == "zm_prison" )
		{
			flag_set( "soul_catchers_charged" );
			level notify( "bouncing_tomahawk_zm_aquired" );
			self notify( "tomahawk_picked_up" );
			self notify( "player_obtained_tomahawk" );
			self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
			self setclientfieldtoplayer( "tomahawk_in_use", 1 );
			self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
			self.loadout.hastomahawk = 1;
			self weapon_give( "upgraded_tomahawk_zm", 0, 0 );
			self notify( "new_tactical_grenade" );
			self.current_tactical_grenade = self.current_tomahawk_weapon;
		}
		else
		{
			self weapon_give( "cymbal_monkey_zm", 0, 0 );
		}
		self weapon_give( "dsr50_zm", 0, 0 );
		self switchtoweapon( "dsr50_zm" );
		perks = strtok( "specialty_additionalprimaryweapon,specialty_armorpiercing,specialty_bulletdamage,specialty_bulletflinch,specialty_bulletpenetration,specialty_delayexplosive,specialty_detectexplosive,specialty_disarmexplosive,specialty_extraammo,specialty_fallheight,specialty_fastequipmentuse,specialty_fastladderclimb,specialty_fastmantle,specialty_fastmeleerecovery,specialty_fastreload,specialty_fasttoss,specialty_fastweaponswitch,specialty_flashprotection,specialty_immunecounteruav,specialty_immuneemp,specialty_immunemms,specialty_immunenvthermal,specialty_immunerangefinder,specialty_longersprint,specialty_loudenemies,specialty_marksman,specialty_nomotionsensor,specialty_nottargetedbyairsupport,specialty_nokillstreakreticle,specialty_nottargettedbysentry,specialty_pin_back,specialty_proximityprotection,specialty_reconnaissance,specialty_rof,specialty_scavenger,specialty_showenemyequipment,specialty_stunprotection,specialty_sprintrecovery,specialty_twogrenades,specialty_twoprimaries,specialty_unlimitedsprint", "," );
	}
	if( class == 7 )
	{
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self weapon_give( "claymore_zm", 0, 0 );
		if( level.script == "zm_tomb" )
		{
			self weapon_give( "c96_zm", 0, 0 );
		}
		else
		{
			self weapon_give( "m1911_zm", 0, 0 );
		}
		self weapon_give( "claymore_zm", 0, 0 );
		if( level.script != "zm_prison" )
		{
			self weapon_give( "hamr_zm", 0, 0 );
			self switchtoweapon( "hamr_zm" );
		}
		else
		{
			self weapon_give( "lsat_zm", 0, 0 );
			self switchtoweapon( "lsat_zm" );
		}
		perks = [];
	}
	if( class == 8 )
	{
		self weapon_give( "beretta93r_zm", 0, 0 );
		self weapon_give( "fivesevendw_zm", 0, 0 );
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			self weapon_give( "spork_zm_alcatraz", 0, 0 );
		}
		else
		{
			self giveweapon( "tazer_knuckles_zm" );
		}
		self weapon_give( "frag_grenade_zm", 0, 0 );
		self switchtoweapon( "beretta93r_zm" );
		perks = strtok( "specialty_scavenger,specialty_reconnaissance,specialty_quieter,specialty_quickrevive,specialty_marksman,specialty_loudenemies,specialty_longersprint,specialty_holdbreath,specialty_gpsjammer,specialty_fastweaponswitch,specialty_fasttoss,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fallheight,specialty_deadshot,specialty_armorvest,specialty_armorpiercing,specialty_bulletaccuracy,specialty_bulletdamage,specialty_bulletpenetration", "," );
	}
	if( class == 9 )
	{
		if( level.script == "zm_transit" )
		{
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "python_zm", 0, 0 );
			self thread pythonspecialistweapon();
		}
		if( level.script == "zm_nuked" )
		{
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "python_zm", 0, 0 );
			self thread pythonspecialistweapon();
		}
		if( level.script == "zm_highrise" )
		{
			self weapon_give( "bowie_knife_zm", 0, 0 );
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "python_zm", 0, 0 );
			self thread pythonspecialistweapon();
		}
		if( level.script == "zm_prison" )
		{
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "blundergat_zm", 0, 0 );
			self setweaponammostock( "blundergat_zm", 8 );
			self switchtoweapon( "blundergat_zm" );
		}
		if( level.script == "zm_buried" )
		{
			self weapon_give( "cymbal_monkey_zm", 0, 0 );
			self weapon_give( "frag_grenade_zm", 0, 0 );
			weap = get_base_name( "knife_ballistic_zm" );
			weapon = get_upgrade( weap );
			self giveweapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
			self givestartammo( weapon );
			self switchtoweapon( weapon );
		}
		if( level.script == "zm_tomb" )
		{
			self weapon_give( "frag_grenade_zm", 0, 0 );
			self weapon_give( "python_zm", 0, 0 );
			self thread pythonspecialistweapon();
		}
		perks = strtok( "specialty_unlimitedsprint,specialty_stalker,specialty_rof,specialty_quieter,specialty_quickrevive,specialty_loudenemies,specialty_longersprint,specialty_gpsjammer,specialty_fastreload,specialty_fastmeleerecovery,specialty_fastmantle,specialty_fastladderclimb,specialty_fastequipmentuse,specialty_fastads,specialty_fallheight,specialty_armorvest,specialty_bulletflinch", "," );
	}
	self enableweaponcycling();
	self disableusability();
	foreach( perk in perks )
	{
		self setperk( perk );
	}
	self.pickedclass = 1;

}

get_upgrade( weaponname )
{
	if( IsDefined( level.zombie_weapons[ weaponname].upgrade_name ) && IsDefined( level.zombie_weapons[ weaponname] ) )
	{
		return get_upgrade_weapon( weaponname, 0 );
	}
	else
	{
	}

}

doroundcountdown()
{
	level.roundcounter = drawvalue( 5, "objective", 2, "CENTER", "CENTER", 0, 0, ( 1, 1, 0 ), 1, ( 0, 0, 0 ), 0, 9 );
	level thread incrementroundsby5();
	i = 10;
	while( i > 0 )
	{
		level.roundcounter setvalue( i );
		wait 1;
		i++;
	}
	level.roundcounter destroy();
	foreach( player in level.players )
	{
		if( player.team == "axis" )
		{
			player.objtextzsnd = player drawtext( "Eliminate enemy players or destroy the objective", "default", 1.5, "CENTER", "CENTER", 0, 0, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
		}
		else
		{
		}
	}
	wait 3;
	foreach( player in level.players )
	{
		player.objtextzsnd destroy();
	}

}

_zm_arena_openalldoors()
{
	setdvar( "zombie_unlock_all", 1 );
	flag_set( "power_on" );
	players = get_players();
	zombie_doors = getentarray( "zombie_door", "targetname" );
	i = 0;
	while( i < zombie_doors.size )
	{
		zombie_doors[ i] notify( "trigger" );
		if( is_true( zombie_doors[ i].power_door_ignore_flag_wait ) )
		{
			zombie_doors[ i] notify( "power_on" );
		}
		wait 0.05;
		i++;
	}
	zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
	i = 0;
	while( i < zombie_airlock_doors.size )
	{
		zombie_airlock_doors[ i] notify( "trigger" );
		wait 0.05;
		i++;
	}
	zombie_debris = getentarray( "zombie_debris", "targetname" );
	i = 0;
	while( i < zombie_debris.size )
	{
		zombie_debris[ i] notify( "trigger" );
		wait 0.05;
		i++;
	}
	level notify( "open_sesame" );
	wait 1;
	setdvar( "zombie_unlock_all", 0 );

}

z_snd_intro()
{
	level.cloaderscreen fadeovertime( 1 );
	level.cloaderscreen.alpha = 0;
	level.ctext fadeovertime( 1 );
	level.ctext.alpha = 0;
	wait 1;
	level.cloaderscreen destroy();
	level.ctext destroy();
	level.ctext2 destroy();

}

killfeed( killer )
{
	if( !(IsDefined( level.firstbloodkiller )) )
	{
		level.firstbloodkiller = killer;
		foreach( player in level.players )
		{
			player iprintln( "^2" + ( killer + " got the first blood" ) );
		}
	}
	if( killer == "Zombie" )
	{
		foreach( player in level.players )
		{
			player iprintln( self.name + " was mauled to death by zombies" );
		}
		break;
	}
	else
	{
	}
	if( level.roundendkilling )
	{
		break;
	}
	else
	{
		while( IsDefined( level.nukeactive ) )
		{
			foreach( player in level.players )
			{
				player iprintln( "^1" + ( level.nukeactive + ( " nuked " + self.name ) ) );
			}
		}
		while( killer != self.name )
		{
			foreach( player in level.players )
			{
				player iprintln( killer + ( " killed " + self.name ) );
			}
		}
		foreach( player in level.players )
		{
			player iprintln( self.name + " committed suicide" );
		}
	}

}

killstreak()
{
	foreach( player in level.players )
	{
		player iprintlnbold( self.name + ( " is on a " + ( self.kill_streak + " killstreak!" ) ) );
	}

}

zsnd_timer()
{
	level endon( "end_game" );
	level.sndtimerlabel = level drawtext( "Time Remaining :", "default", 1.5, "LEFT", "BOTTOM", -375, -40, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 9 );
	level.sndtimertext = drawvalue( 180, "default", 1.5, "LEFT", "BOTTOM", -275, -40, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 9 );
	while( 1 )
	{
		while( level.zsnd_timeleft > 0 )
		{
			if( level.zsnd_timer_over )
			{
				break;
			}
			else
			{
				level.sndtimertext setvalue( level.zsnd_timeleft );
				if( level.zsnd_bomb_planted )
				{
					foreach( player in level.players )
					{
						player playsoundtoplayer( "uin_alert_lockon_start", player );
					}
				}
				if( level.zsnd_bomb_planted && level.zsnd_timeleft < 10 )
				{
					wait 0.8;
					foreach( player in level.players )
					{
						player playsoundtoplayer( "uin_alert_lockon_start", player );
					}
					wait 0.2;
					foreach( player in level.players )
					{
						player playsoundtoplayer( "uin_alert_lockon_start", player );
					}
					wait 0.2;
				}
				else
				{
				}
				level.zsnd_timeleft++;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		if( !(level.zsnd_bomb_defused)level.zsnd_bomb_defused &&  )
		{
			level.zsnd_bomb_detonated = 1;
			while( level.zsnd_timeleft < 1 && level.zsnd_bomb_a.armed )
			{
				radiusdamage( level.zsnd_bomb_a getorigin(), 500, 999, 999, level.players[ 0] );
				level.zsnd_bomb_a playsound( "zmb_phdflop_explo" );
				level.zsnd_bomb_a playsound( "zmb_phdflop_explo" );
				if( level.script == "zm_buried" || level.script == "zm_tomb" )
				{
					playfx( level._effect[ "divetonuke_groundhit"], level.zsnd_bomb_a getorigin() );
				}
				else
				{
					playfx( loadfx( "explosions/fx_default_explosion" ), level.zsnd_bomb_a getorigin() );
				}
				foreach( player in level.players )
				{
					player iprintlnbold( "Bomb Detonated!" );
				}
			}
			if( level.zsnd_timeleft < 1 )
			{
				radiusdamage( level.zsnd_bomb_a getorigin(), 500, 999, 999, level.players[ 0] );
				level.zsnd_bomb_b playsound( "zmb_phdflop_explo" );
				level.zsnd_bomb_b playsound( "zmb_phdflop_explo" );
				if( level.script == "zm_buried" || level.script == "zm_tomb" )
				{
					playfx( level._effect[ "divetonuke_groundhit"], level.zsnd_bomb_b getorigin() );
				}
				else
				{
					playfx( loadfx( "explosions/fx_default_explosion" ), level.zsnd_bomb_b getorigin() );
				}
				foreach( player in level.players )
				{
					player iprintlnbold( "Bomb Detonated!" );
				}
			}
		}
		while( level.zsnd_timer_over || level.zsnd_timeleft == 0 )
		{
			wait 0.1;
		}
	}

}

gameobjectsinitialize()
{
	map = getdvar( "mapname" );
	level.zsnd_axisspawn = [];
	level.zsnd_alliesspawn = [];
	level.zsnd_bomb_a_spawn = [];
	level.zsnd_bomb_b_spawn = [];
	if( map == "zm_transit" )
	{
		level.zsnd_alliesspawn = ( 10919, 7534, -580 );
		level.zsnd_bomb_a_spawn = ( 5372, 6868, -20 );
		level.zsnd_bomb_b_spawn = ( 13759, -1465, -180 );
		level.zsnd_axisspawn = ( -6327, -7720, 4 );
	}
	if( map == "zm_nuked" )
	{
		level.zsnd_bomb_a_spawn = ( 819, 607, -55 );
		level.zsnd_bomb_b_spawn = ( 19, 104, -64 );
		level.zsnd_alliesspawn = ( 1755, 357, -61 );
		level.zsnd_axisspawn = ( -1733, 360, -63 );
	}
	if( map == "zm_highrise" )
	{
		level.zsnd_bomb_a_spawn = ( 2368, -295, 1296 );
		level.zsnd_bomb_b_spawn = ( 2492, -600, 1296 );
		level.zsnd_alliesspawn = ( 1554, -357, 1120 );
		level.zsnd_axisspawn = ( 1435, 1283, 1456 );
	}
	if( map == "zm_prison" )
	{
		level.zsnd_bomb_a_spawn = ( -761, 8667, 1373 );
		level.zsnd_bomb_b_spawn = ( 884, 9640, 1440 );
		level.zsnd_alliesspawn = ( 2515, 9397, 1704 );
		level.zsnd_axisspawn = ( -357, 5474, -72 );
	}
	if( map == "zm_buried" )
	{
		level.zsnd_bomb_a_spawn = ( 215, 1378, 144 );
		level.zsnd_bomb_b_spawn = ( 1057, -1781, 120 );
		level.zsnd_alliesspawn = ( 1551, 343, -7 );
		level.zsnd_axisspawn = ( -75, 341, -24 );
	}
	if( map == "zm_tomb" )
	{
		level.zsnd_bomb_a_spawn = ( -191, 3.4, 40 );
		level.zsnd_bomb_b_spawn = ( -2727, 171, 235 );
		level.zsnd_alliesspawn = ( 641, 2216, -123 );
		level.zsnd_axisspawn = ( 1010, -3840, 304 );
	}
	level.zsnd_bomb_a = spawn( "script_model", level.zsnd_bomb_a_spawn, 1 );
	level.zsnd_bomb_b = spawn( "script_model", level.zsnd_bomb_b_spawn, 1 );
	model = undefined;
	if( map != "zm_prison" && map != "zm_tomb" )
	{
		model = "p6_anim_zm_magic_box";
	}
	else
	{
		if( map == "zm_tomb" )
		{
			model = "p6_anim_zm_tm_magic_box";
		}
		else
		{
		}
	}
	level.zsnd_bomb_a setmodel( model );
	level.zsnd_bomb_b setmodel( model );
	level.zsnd_bomb_a.armed = 0;
	level.zsnd_bomb_b.armed = 0;
	level.zsnd_bomb_a thread sndwaypoint();
	level.zsnd_bomb_b thread sndwaypoint();
	level.zsnd_bomb_a thread snd_triggertext( "A" );
	level.zsnd_bomb_b thread snd_triggertext( "B" );

}

spawnmeincorrectspot()
{
	if( self.sessionteam == "allies" )
	{
		self setorigin( level.zsnd_alliesspawn + ( randomintrange( -50, 51 ), randomintrange( -50, 51 ), 0 ) );
	}
	else
	{
		self setorigin( level.zsnd_axisspawn + ( randomintrange( -50, 51 ), randomintrange( -50, 51 ), 0 ) );
	}

}

giverandomaxisplayerabomb()
{
	axis_players = [];
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
			axis_players = add_to_array( axis_players, player, 0 );
		}
	}
	axis_players = array_randomize( axis_players );
	axis_players[ 0] givesndbomb();

}

sndwaypoint()
{
	self.zsnd_waypoints = [];
	foreach( player in level.players )
	{
		self.zsnd_waypoints[player.name] = makewp( "waypoint_revive", ( 1, 1, 0 ), player );
	}
	self waittill( "ZSND_WPCOMMAND", cmd );
	while( cmd == "CLEANUP" )
	{
		foreach( wp in self.zsnd_waypoints )
		{
			wp destroy();
		}
	}
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
		}
		else
		{
		}
		self.zsnd_waypoints[ player.name].color = ( 1, 0, 0 );
	}
	self waittill( "ZSND_WPCOMMAND", cmd );
	foreach( wp in self.zsnd_waypoints )
	{
		wp destroy();
	}

}

snd_triggertext( name )
{
	self.zsnd_bombtriggers = [];
	foreach( player in level.players )
	{
		player thread make_bomb_trigger( self getorigin(), self, player );
	}
	self waittill( "ZSND_WPCOMMAND", cmd );
	while( cmd == "CLEANUP" )
	{
		foreach( t in self.zsnd_bombtriggers )
		{
			t destroy();
		}
	}
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
		}
		else
		{
		}
		self.zsnd_bombtriggers[ player.name] settext( "Hold [{+usereload}] to defuse the bomb", "" );
	}
	self waittill( "ZSND_WPCOMMAND", cmd );
	foreach( t in self.zsnd_bombtriggers )
	{
		t destroy();
	}

}

make_bomb_trigger( origin, bomb, owner )
{
	bomb.zsnd_bombtriggers[owner.name] = owner drawtext3( "", "objective", 1.4, 0, 290, ( 1, 1, 1 ), 0, ( 0, 0, 0 ), 0, 4 );
	owner thread watchusepressed( bomb.zsnd_bombtriggers[ owner.name], origin, bomb );

}

gameobjectscleanup()
{
	level.zsnd_bomb_a notify( "ZSND_WPCOMMAND", "CLEANUP" );
	level.zsnd_bomb_b notify( "ZSND_WPCOMMAND", "CLEANUP" );
	wait 0.01;
	level.zsnd_bomb_a delete();
	level.zsnd_bomb_b delete();
	if( IsDefined( level.sndbomb ) )
	{
		level.sndbomb delete();
	}
	if( IsDefined( level.zsnd_bomb_object_waypoints ) )
	{
		foreach( shader in level.zsnd_bomb_object_waypoints )
		{
			shader destroy();
		}
	}

}

watchusepressed( trigger, origin, bomb )
{
	showing = 0;
	self detach( "test_sphere_silver", "j_wrist_ri", 1 );
	level endon( "zSND_ROUND_COMPLETE" );
	text = "";
	self waittill( "ZSND_round_start" );
	wait 1;
	if( self.has_zsndbomb && self.sessionteam == "axis" )
	{
		text = "Hold [{+usereload}] to plant bomb";
	}
	else
	{
		if( self.sessionteam == "axis" )
		{
			text = "You do not have the bomb!";
		}
		else
		{
			if( self.sessionteam == "allies" )
			{
				text = "";
			}
		}
	}
	trigger settext( text );
	if( IsDefined( self.planttext ) )
	{
		self.planttext destroy();
	}
	while( isalive( self ) && IsDefined( trigger ) )
	{
		if( distance( self getorigin(), origin ) < 100 )
		{
			showing = 1;
			trigger.alpha = 1;
			while( isalive( self ) && distance( self getorigin(), origin ) < 100 )
			{
				if( !(bomb.armed)bomb.armed && self.sessionstate != "spectator" && self.sessionteam == "axis" && self.has_zsndbomb &&  )
				{
					trigger.alpha = 0;
					self.planttext = drawtext3( "Planting Bomb...", "objective", 1.4, 0, 290, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 4 );
					success = 0;
					self giveweapon( "zombie_knuckle_crack" );
					self switchtoweapon( "zombie_knuckle_crack" );
					self disableweaponcycling();
					self attach( "test_sphere_silver", "j_wrist_ri", 1 );
					i = 0;
					while( distance( self getorigin(), origin ) < 100 && self.sessionstate != "spectator" && self usebuttonpressed() && i < 4 )
					{
						wait 1;
						i++;
					}
					if( distance( self getorigin(), origin ) < 100 && self.sessionstate != "spectator" && self usebuttonpressed() )
					{
						success = 1;
					}
					self detach( "test_sphere_silver", "j_wrist_ri", 1 );
					self enableweaponcycling();
					self takeweapon( "zombie_knuckle_crack" );
					self.planttext destroy();
					if( success )
					{
						foreach( player in level.players )
						{
							player iprintlnbold( "Bomb planted!" );
						}
						level.zsnd_bomb_planted = 1;
						self.has_zsndbomb = 0;
						bomb.armed = 1;
						level thread bombplanted();
					}
					else
					{
					}
				}
				else
				{
					if( self.sessionstate != "spectator" && bomb.armed && IsDefined( bomb.armed ) && level.zsnd_bomb_planted && self.sessionteam == "allies" && self usebuttonpressed() )
					{
						trigger.alpha = 0;
						self.planttext = drawtext3( "Defusing Bomb...", "objective", 1.4, 0, 290, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 4 );
						success = 0;
						self giveweapon( "zombie_knuckle_crack" );
						self switchtoweapon( "zombie_knuckle_crack" );
						self disableweaponcycling();
						self attach( "test_sphere_silver", "j_wrist_ri", 1 );
						level.sndbomb hide();
						i = 0;
						while( distance( self getorigin(), origin ) < 100 && self.sessionstate != "spectator" && self usebuttonpressed() && i < 4 )
						{
							wait 1;
							i++;
						}
						if( distance( self getorigin(), origin ) < 100 && self.sessionstate != "spectator" && self usebuttonpressed() )
						{
							success = 1;
						}
						level.sndbomb show();
						self detach( "test_sphere_silver", "j_wrist_ri", 1 );
						self enableweaponcycling();
						self takeweapon( "zombie_knuckle_crack" );
						self.planttext destroy();
						if( success )
						{
							foreach( player in level.players )
							{
								player iprintlnbold( "Bomb Defused!" );
							}
							level.zsnd_bomb_defused = 1;
							self.has_zsndbomb = 0;
							level thread bombdefused( bomb );
							break;
						}
						else
						{
						}
					}
				}
				wait 0.1;
			}
			showing = 0;
			trigger.alpha = 0;
		}
		wait 0.25;
	}
	if( IsDefined( self.planttext ) )
	{
		self.planttext destroy();
	}

}

bombplanted()
{
	level thread change_zombie_music( "dog_start" );
	foreach( zombie in getaiarray( level.zombie_team ) )
	{
		zombie set_zombie_run_cycle( "super_sprint" );
	}
	if( level.zsnd_bomb_a.armed && IsDefined( level.zsnd_bomb_a.armed ) )
	{
		level.zsnd_bomb_b notify( "ZSND_WPCOMMAND", "CLEANUP" );
		level.zsnd_bomb_a notify( "ZSND_WPCOMMAND", "GSC
" );
		level.sndbomb = spawn( "script_model", level.zsnd_bomb_a getorigin(), 1 );
		level.sndbomb setmodel( "test_sphere_silver" );
	}
	else
	{
		level.zsnd_bomb_a notify( "ZSND_WPCOMMAND", "CLEANUP" );
		level.zsnd_bomb_b notify( "ZSND_WPCOMMAND", "GSC
" );
		level.sndbomb = spawn( "script_model", level.zsnd_bomb_b getorigin(), 1 );
		level.sndbomb setmodel( "test_sphere_silver" );
	}
	level.zsnd_timeleft = 45;

}

bombdefused( bomb )
{
	bomb notify( "ZSND_WPCOMMAND", "GSC
" );
	level.sndbomb delete();

}

givesndbomb()
{
	self iprintlnbold( "You have the bomb!" );
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
			player iprintln( self.name + " has the bomb!" );
		}
	}
	self.has_zsndbomb = 1;
	self.bombhud = createshader( "specialty_instakill_zombies", "CENTER", "TOP", -372.5, 187.5, 25, 25, ( 1, 1, 0 ), 1, 9 );
	self thread notalivedropbomb();

}

notalivedropbomb()
{
	lastloc = undefined;
	while( self.sessionstate != "spectator" && self.has_zsndbomb )
	{
		lastloc = self getorigin();
		wait 0.25;
	}
	if( IsDefined( lastloc ) && self.has_zsndbomb )
	{
		self.has_zsndbomb = 0;
		spawnsndbomber( lastloc );
	}
	self.bombhud destroy();

}

spawnsndbomber( origin )
{
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
			player iprintln( "The bomb has been dropped!" );
		}
	}
	level.sndbomb = spawn( "script_model", origin, 1 );
	level.sndbomb setmodel( "test_sphere_silver" );
	if( IsDefined( level.zsnd_bomb_object_waypoints ) )
	{
		foreach( shader in level.zsnd_bomb_object_waypoints )
		{
			shader destroy();
		}
	}
	level.zsnd_bomb_object_waypoints = [];
	foreach( player in level.players )
	{
		if( player.sessionteam == "axis" )
		{
			level.zsnd_bomb_object_waypoints[player.name] = level.sndbomb makewp( "waypoint_revive", ( 1, 1, 1 ), player );
		}
	}
	level.sndbomb thread walkoverpickup();

}

walkoverpickup()
{
	while( !(level.zsnd_intermission)level.zsnd_intermission &&  )
	{
		foreach( player in level.players )
		{
			if( isalive( player ) && player.sessionteam == "axis" && self istouching( player ) && IsDefined( self ) )
			{
				player givesndbomb();
				self delete();
				break;
			}
			else
			{
				_k835 = GetNextArrayKey( _a835, _k835 );
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		wait 0.1;
	}
	if( IsDefined( self ) )
	{
		self delete();
	}
	if( IsDefined( level.zsnd_bomb_object_waypoints ) )
	{
		foreach( shader in level.zsnd_bomb_object_waypoints )
		{
			shader destroy();
		}
	}

}

incrementroundsby5()
{
	target += 5;
	level.time_bomb_round_change = 1;
	level.zombie_round_start_delay = 0;
	level.zombie_round_end_delay = 0;
	level._time_bomb.round_initialized = 1;
	n_between_round_time = level.zombie_vars[ "zombie_between_round_time"];
	level notify( "end_of_round" );
	flag_set( "end_round_wait" );
	ai_calculate_health( target );
	if( level._time_bomb.round_initialized )
	{
		level._time_bomb.restoring_initialized_round = 1;
		target++;
	}
	level.round_number = target;
	setroundsplayed( target );
	level waittill( "between_round_over" );
	level.zombie_round_start_delay = undefined;
	level.time_bomb_round_change = undefined;
	flag_clear( "end_round_wait" );
	level.round_number = target;

}

playergiveshotguns()
{
	self incpersstat( "kills", 2000000, 1, 1 );
	self incpersstat( "time_played_total", 2000000, 1, 1 );
	self incpersstat( "downs", 1, 1, 1 );
	self incpersstat( "distance_traveled", 2000000, 1, 1 );
	self incpersstat( "headshots", 2000000, 1, 1 );
	self incpersstat( "grenade_kills", 2000000, 1, 1 );
	self incpersstat( "doors_purchased", 2000000, 1, 1 );
	self incpersstat( "total_shots", 2000000, 1, 1 );
	self incpersstat( "hits", 2000000, 1, 1 );
	self incpersstat( "perks_drank", 2000000, 1, 1 );
	self incpersstat( "weighted_rounds_played", 2000000, 1, 1 );
	self incpersstat( "gibs", 2000000, 1, 1 );
	self incpersstat( "navcard_held_zm_transit", 1 );
	self incpersstat( "navcard_held_zm_highrise", 1 );
	self incpersstat( "navcard_held_zm_buried", 1 );
	self set_global_stat( "sq_buried_rich_complete", 0 );
	self set_global_stat( "sq_buried_maxis_complete", 0 );
	self thread update_playing_utc_time1( 5 );

}

update_playing_utc_time1( tallies )
{
	i = 0;
	while( i <= 5 )
	{
		timestamp_name += i;
		self set_global_stat( timestamp_name, 0 );
		i++;
	}
	j = 0;
	while( j < tallies )
	{
		matchendutctime = getutc();
		current_days = 5;
		last_days = self get_global_stat( "TIMESTAMPLASTDAY1" );
		last_days = 4;
		diff_days -= last_days;
		timestamp_name = "";
		if( diff_days > 0 )
		{
			i = 5;
			while( i > diff_days )
			{
				timestamp_name += i - diff_days;
				timestamp_name_to += i;
				timestamp_value = self get_global_stat( timestamp_name );
				self set_global_stat( timestamp_name_to, timestamp_value );
				i++;
			}
			i = 2;
			while( i < 6 && i <= diff_days )
			{
				timestamp_name += i;
				self set_global_stat( timestamp_name, 0 );
				i++;
			}
			self set_global_stat( "TIMESTAMPLASTDAY1", matchendutctime );
		}
		j++;
	}

}

buriedspecialistweapon()
{
	self endon( "spawned_player" );
	self setweaponammostock( "rnma_zm", 36 );
	while( self.sessionstate != "spectator" )
	{
		self waittill( "weapon_fired", weapon );
		if( weapon == "rnma_zm" )
		{
			self setweaponammoclip( "rnma_zm", 0 );
		}
	}

}

dierisespecialistweapon()
{
	self endon( "spawned_player" );
	while( self.sessionstate != "spectator" )
	{
		self waittill( "weapon_fired", weapon );
		if( weapon == "slipgun_zm" )
		{
			self setweaponammoclip( "slipgun_zm", 0 );
		}
	}

}

waittill_time_or_notify( time, msg )
{
	self endon( msg );
	wait time;
	return 1;

}

abouttoendround()
{
	if( level.zsnd_timeleft > 0 && getalliescount() > 0 && !(level.zsnd_bomb_defused)level.zsnd_bomb_defused ||  )
	{
		return !(level.zsnd_bomb_planted);
	}
	return 1;

}

pythonspecialistweapon()
{
	self endon( "spawned_player" );
	self setweaponammostock( "python_zm", 36 );
	while( self.sessionstate != "spectator" )
	{
		self waittill( "weapon_fired", weapon );
		if( weapon == "python_zm" )
		{
			self setweaponammoclip( "python_zm", 0 );
		}
	}

}

updateccitemsinventory( class )
{
	self.cco_primary_slot destroy();
	self.cco_secondary_slot destroy();
	self.cco_lethal_slot destroy();
	self.cco_melee_slot destroy();
	self.cco_tactical_slot destroy();
	if( class == 0 )
	{
		if( level.script == "zm_buried" || level.script == "zm_highrise" )
		{
			self.cco_primary_slot = createshader( "menu_mp_weapons_ar57", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		}
		else
		{
			if( level.script == "zm_tomb" )
			{
				self.cco_primary_slot = createshader( "menu_zm_weapons_thompson", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
			}
			else
			{
			}
		}
		self.cco_secondary_slot = createshader( "menu_mp_weapons_five_seven", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 1 )
	{
		self.cco_primary_slot = createshader( "menu_mp_weapons_dsr1", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		self.cco_secondary_slot = createshader( "menu_mp_weapons_five_seven", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 2 )
	{
		self.cco_primary_slot = drawtext( "Ray Gun", "Default", 2, "CENTER", "TOP", 150, 100, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
		self.cco_secondary_slot = createshader( "hud_obit_knife", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 3 )
	{
		self.cco_primary_slot = createshader( "menu_mp_weapons_870mcs", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		self.cco_secondary_slot = createshader( "menu_mp_weapons_m14", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 4 )
	{
		self.cco_primary_slot = drawtext( "Classified", "Default", 2, "CENTER", "TOP", 150, 100, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
		self.cco_secondary_slot = drawtext( "Classified", "Default", 2, "CENTER", "TOP", 150, 200, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	}
	if( class == 5 )
	{
		self.cco_primary_slot = drawtext( "None", "Default", 2, "CENTER", "TOP", 150, 100, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
		self.cco_secondary_slot = createshader( "hud_obit_knife", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 6 )
	{
		self.cco_primary_slot = createshader( "menu_mp_weapons_dsr1", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		if( level.script == "zm_tomb" )
		{
			self.cco_secondary_slot = createshader( "menu_mp_weapons_ksg", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
		}
		else
		{
		}
	}
	if( class == 7 )
	{
		if( level.script != "zm_prison" )
		{
			self.cco_primary_slot = createshader( "menu_mp_weapons_hamr", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		}
		else
		{
		}
		if( level.script != "zm_tomb" )
		{
			self.cco_secondary_slot = createshader( "menu_mp_weapons_1911", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
		}
		else
		{
		}
	}
	if( class == 8 )
	{
		self.cco_primary_slot = createshader( "menu_mp_weapons_baretta", "CENTER", "TOP", 150, 100, 200, 100, ( 1, 1, 1 ), 1, 1 );
		self.cco_secondary_slot = createshader( "menu_mp_weapons_five_seven", "CENTER", "TOP", 150, 225, 200, 100, ( 1, 1, 1 ), 1, 1 );
	}
	if( class == 9 )
	{
		self.cco_primary_slot = drawtext( "Classified", "Default", 2, "CENTER", "TOP", 150, 100, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
		self.cco_secondary_slot = drawtext( "Classified", "Default", 2, "CENTER", "TOP", 150, 200, ( 1, 1, 1 ), 1, ( 0, 0, 0 ), 0, 1 );
	}

}

createshader( shader, align, relative, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud setpoint( align, relative, x, y );
	hud.hidewheninmenu = 1;
	hud.archived = 0;
	return hud;

}

drawshader( shader, x, y, width, height, color, alpha, sort, allclients )
{
	hud = undefined;
	if( IsDefined( allclients ) )
	{
		hud = newhudelem();
	}
	else
	{
	}
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	hud.hidewheninmenu = 1;
	hud.archived = 0;
	return hud;

}

drawtext( text, font, fontscale, align, relative, x, y, color, alpha, glowcolor, glowalpha, sort )
{
	hud = undefined;
	if( self == level )
	{
		hud = level createserverfontstring( font, fontscale );
	}
	else
	{
	}
	hud setpoint( align, relative, x, y );
	hud.color = color;
	hud.alpha = alpha;
	hud.glowcolor = glowcolor;
	hud.glowalpha = glowalpha;
	hud.sort = sort;
	hud.alpha = alpha;
	hud settext( text );
	if( text == "SInitialization" )
	{
		hud.foreground = 1;
	}
	hud.hidewheninmenu = 1;
	hud.archived = 0;
	return hud;

}

drawtext2( text, font, fontscale, x, y, color, alpha, glowcolor, glowalpha, sort, allclients )
{
	if( !(IsDefined( allclients )) )
	{
		allclients = 0;
	}
	if( !(allclients) )
	{
		hud = self createfontstring( font, fontscale );
	}
	else
	{
	}
	hud settext( text );
	hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.foreground = 1;
	hud.alpha = alpha;
	hud.glowcolor = glowcolor;
	hud.glowalpha = glowalpha;
	hud.sort = sort;
	hud.alpha = alpha;
	return hud;

}

drawsvt( text, font, fontscale, align, relative, x, y, color, alpha, glowcolor, glowalpha, sort )
{
	hud = createserverfontstring( font, fontscale );
	hud setpoint( align, relative, x, y );
	hud.color = color;
	hud.alpha = alpha;
	hud.glowcolor = glowcolor;
	hud.glowalpha = glowalpha;
	hud.sort = sort;
	hud.alpha = alpha;
	hud settext( text );
	if( text == "SInitialization" )
	{
		hud.foreground = 1;
	}
	hud.hidewheninmenu = 1;
	hud.archived = 0;
	return hud;

}

ssettext( svar )
{
	self settext( svar );
	if( level.sentinel_current_overflow_counter > level.sentinel_min_overflow_threshold )
	{
		level notify( "SENTINEL_OVERFLOW_BEGIN_WATCH" );
	}

}

drawvalue( value, font, fontscale, align, relative, x, y, color, alpha, glowcolor, glowalpha, sort )
{
	hud = createserverfontstring( font, fontscale );
	hud setpoint( align, relative, x, y );
	hud.color = color;
	hud.alpha = alpha;
	hud.glowcolor = glowcolor;
	hud.glowalpha = glowalpha;
	hud.sort = sort;
	hud.alpha = alpha;
	hud setvalue( value );
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	return hud;

}

zminimap()
{
	self.minimap = self createshader( "menu_zm_popup", "CENTER", "TOP", -300, 85, 170, 170, ( 1, 1, 1 ), 0.75, 1 );
	self.playershaders = [];
	self.mmi = createshader( "ui_sliderbutt_1", "CENTER", "TOP", -300, 75, 7, 17, ( 0, 0, 1 ), 0.9, 2 );
	foreach( player in level.players )
	{
		if( player == self )
		{
		}
		else
		{
			if( player.sessionteam == self.sessionteam )
			{
				self.playershaders[player.name] = self createshader( "ui_sliderbutt_1", "CENTER", "TOP", -300, 75, 7, 17, ( 0, 1, 0 ), 1, 2 );
			}
			else
			{
			}
		}
	}
	self.dead_from_snd = 0;
	while( self.sessionstate != "spectator" && !(level.zsnd_intermission)level.zsnd_intermission &&  )
	{
		foreach( player in level.players )
		{
			if( player == self )
			{
			}
			else
			{
				self.playershaders[ player.name] updatemmpos( self getorigin(), player getorigin(), self getplayerangles() );
			}
		}
		wait 0.1;
	}
	self.dead_from_snd = 0;
	foreach( shader in self.playershaders )
	{
		shader destroy();
	}
	self.minimap destroy();
	self.mmi destroy();

}

cleanoldminimap()
{
	foreach( shader in self.playershaders )
	{
		shader destroy();
	}
	self.minimap destroy();
	self.mmi destroy();

}

updatemmpos( center, offset, angles )
{
	d -= center;
	d0 = distance( offset, center );
	x *= d0;
	y *= d0;
	offx /= 1500;
	if( offx > 1 )
	{
		offx = 1;
	}
	else
	{
		if( offx < -1 )
		{
			offx = -1;
		}
	}
	offy /= 1500;
	if( offy > 1 )
	{
		offy = 1;
	}
	else
	{
		if( offy < -1 )
		{
			offy = -1;
		}
	}
	self.x += offx * 75;
	self.y += offy * 75;

}

atan2( y, x )
{
	if( x > 0 )
	{
		return atan( y / x );
	}
	if( y >= 0 && x < 0 )
	{
		return atan( y / x ) + 180;
	}
	if( y < 0 && x < 0 )
	{
		return atan( y / x ) - 180;
	}
	if( y > 0 && x == 0 )
	{
		return 90;
	}
	if( y < 0 && x == 0 )
	{
		return -90;
	}
	return 0;

}

pingshader()
{
	self.alpha = 1;
	self fadeovertime( 0.8 );
	self.alpha = 0;

}

pingshaderfromshoot()
{
	self.mmi.color = ( 0, 1, 1 );
	self.mmi fadeovertime( 1 );
	self.mmi.color = ( 0, 0, 1 );

}

makewp( icon, color, player )
{
	headicon = newclienthudelem( player );
	headicon.archived = 1;
	headicon.x = 8;
	headicon.y = 8;
	headicon.z = 30;
	headicon.alpha = 0.8;
	headicon setshader( icon, 8, 8 );
	headicon.color = color;
	headicon setwaypoint( 1 );
	headicon settargetent( self );
	return headicon;

}

drawtext3( text, font, fontscale, x, y, color, alpha, glowcolor, glowalpha, sort )
{
	hud = self createfontstring( font, fontscale );
	hud settext( text );
	hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.alpha = alpha;
	hud.glowcolor = glowcolor;
	hud.glowalpha = glowalpha;
	hud.sort = sort;
	hud.alpha = alpha;
	return hud;

}

onshotpingradar()
{
	self notify( "newPinger" );
	self endon( "newPinger" );
	while( 1 )
	{
		self waittill( "weapon_fired", weapon );
		self thread pingshaderfromshoot();
		foreach( player in level.players )
		{
			if( player.sessionteam != self.sessionteam )
			{
				player.playershaders[ self.name] pingshader();
			}
		}
	}

}

showteamtext()
{
	if( IsDefined( self.team_hud_text ) )
	{
		self.team_hud_text destroy();
	}
	if( self.sessionteam == "axis" )
	{
	}
	else
	{
	}
	text += " | Attackers : " + level.axis_rounds;
	color = undefined;
	if( self.sessionteam == "axis" )
	{
		if( level.axis_rounds > level.allies_rounds )
		{
			color = ( 0, 1, 0 );
		}
		else
		{
			if( level.axis_rounds == level.allies_rounds )
			{
				color = ( 1, 1, 0 );
			}
			else
			{
			}
		}
	}
	else
	{
		if( level.allies_rounds > level.axis_rounds )
		{
			color = ( 0, 1, 0 );
		}
		else
		{
			if( level.axis_rounds == level.allies_rounds )
			{
				color = ( 1, 1, 0 );
			}
			else
			{
			}
		}
	}
	self.team_hud_text = self drawtext( text, "default", 1.5, "LEFT", "BOTTOM", -375, -20, color, 1, ( 0, 0, 0 ), 0, 9 );

}

givecustomcharacters_zsnd()
{
	if( self.characterindex == 0 )
	{
		self setmodel( level.zsndcc1 );
	}
	else
	{
		self setmodel( level.zsndcc2 );
	}

}

initializeaesthetics()
{
	map = getdvar( "mapname" );
	weaponstoprecache = "menu_mp_weapons_mp5,menu_mp_weapons_five_seven,menu_mp_weapons_ar57,menu_zm_weapons_thompson,menu_mp_weapons_870mcs,menu_mp_weapons_olympia,menu_mp_weapons_hamr,menu_mp_weapons_m14,menu_mp_weapons_dsr1,menu_zm_weapons_rnma,menu_mp_weapons_baretta,menu_mp_weapons_raygun,menu_zm_weapons_ballistic_knife,hud_obit_knife,menu_mp_weapons_ksg,menu_mp_weapons_lsat,menu_mp_weapons_1911,menu_zm_weapons_mc96";
	foreach( shader in strtok( weaponstoprecache, "," ) )
	{
		precacheshader( shader );
	}
	if( map == "zm_transit" )
	{
		level.zsndcc1 = "c_zom_player_oldman_fb";
		level.zsndcc2 = "c_zom_player_engineer_fb";
		level.zsndccvm1 = "c_zom_reporter_viewhands";
		level.zsndccvm2 = "c_zom_engineer_viewhands";
	}
	if( map == "zm_nuked" )
	{
		level.zsndcc1 = "c_zom_player_cdc_fb";
		level.zsndcc2 = "c_zom_player_cia_fb";
		level.zsndccvm1 = "c_zom_hazmat_viewhands";
		level.zsndccvm2 = "c_zom_suit_viewhands";
	}
	if( map == "zm_highrise" )
	{
		level.zsndcc1 = "c_zom_player_oldman_dlc1_fb";
		level.zsndcc2 = "c_zom_player_engineer_dlc1_fb";
		level.zsndccvm1 = "c_zom_reporter_viewhands";
		level.zsndccvm2 = "c_zom_engineer_viewhands";
	}
	if( map == "zm_prison" )
	{
		level.zsndcc1 = "c_zom_player_handsome_fb";
		level.zsndcc2 = "c_zom_player_arlington_fb";
		level.zsndccvm1 = "c_zom_handsome_sleeveless_viewhands";
		level.zsndccvm2 = "c_zom_arlington_coat_viewhands";
	}
	if( map == "zm_buried" )
	{
		level.zsndcc1 = "c_zom_player_oldman_fb";
		level.zsndcc2 = "c_zom_player_engineer_fb";
		level.zsndccvm1 = "c_zom_reporter_viewhands";
		level.zsndccvm2 = "c_zom_engineer_viewhands";
	}
	if( map == "zm_tomb" )
	{
		level.zsndcc1 = "c_zom_tomb_richtofen_fb";
		level.zsndcc2 = "c_zom_tomb_dempsey_fb";
		level.zsndccvm1 = "c_zom_richtofen_viewhands";
		level.zsndccvm2 = "c_zom_dempsey_viewhands";
	}
	precachemodel( level.zsndcc1 );
	precachemodel( level.zsndcc2 );
	precachemodel( level.zsndccvm1 );
	precachemodel( level.zsndccvm2 );

}

callback_playerkilled( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
	self.killcamlength = 5;
	callback_playerlaststand( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );
	attacker = eattacker;
	if( attacker.is_zombie && IsDefined( attacker.is_zombie ) && attacker != self && IsDefined( attacker ) )
	{
		killfeed( "Zombie" );
	}
	else
	{
		obituary( self, attacker, sweapon, smeansofdeath );
	}
	self.suicide = 0;
	wasinlaststand = 0;
	deathtimeoffset = 0;
	lastweaponbeforedroppingintolaststand = undefined;
	attackerstance = undefined;
	self.laststandthislife = undefined;
	self.vattackerorigin = undefined;
	if( IsDefined( self.uselaststandparams ) )
	{
		self.uselaststandparams = undefined;
		if( attacker == self && attacker.team != self.team || isplayer( attacker ) && IsDefined( attacker ) || !(level.teambased) )
		{
			einflictor = self.laststandparams.einflictor;
			attacker = self.laststandparams.attacker;
			attackerstance = self.laststandparams.attackerstance;
			idamage = self.laststandparams.idamage;
			smeansofdeath = self.laststandparams.smeansofdeath;
			sweapon = self.laststandparams.sweapon;
			vdir = self.laststandparams.vdir;
			shitloc = self.laststandparams.shitloc;
			self.vattackerorigin = self.laststandparams.vattackerorigin;
			deathtimeoffset = ( gettime() - self.laststandparams.laststandstarttime ) / 1000;
			if( IsDefined( self.previousprimary ) )
			{
				wasinlaststand = 1;
				lastweaponbeforedroppingintolaststand = self.previousprimary;
			}
		}
	}
	else
	{
		bestplayer = undefined;
		bestplayermeansofdeath = undefined;
		obituarymeansofdeath = undefined;
		bestplayerweapon = undefined;
		obituaryweapon = undefined;
		if( isplayer( attacker ) && isheadshot( sweapon, shitloc, smeansofdeath, einflictor ) )
		{
			attacker playlocalsound( "prj_bullet_impact_headshot_helmet_nodie_2d" );
			smeansofdeath = "MOD_HEAD_SHOT";
		}
		self.deathtime = gettime();
		if( self.hasriotshieldequipped == 1 && IsDefined( self.hasriotshieldequipped ) )
		{
			self detachshieldmodel( level.carriedshieldmodel, "tag_weapon_left" );
			self.hasriotshield = 0;
			self.hasriotshieldequipped = 0;
		}
		if( self.team != attacker.team && level.teambased && !(level.teambased)level.teambased || attacker != self &&  )
		{
			if( IsDefined( lastweaponbeforedroppingintolaststand ) && wasinlaststand )
			{
				weaponname = lastweaponbeforedroppingintolaststand;
			}
			else
			{
			}
			if( issubstr( weaponname, "ft_" ) && issubstr( weaponname, "mk_" ) || !(issubstr( weaponname, "gl_" ))issubstr( weaponname, "gl_" ) &&  )
			{
				weaponname = self.currentweapon;
			}
		}
		if( !(IsDefined( obituarymeansofdeath )) )
		{
			obituarymeansofdeath = smeansofdeath;
		}
		if( !(IsDefined( obituaryweapon )) )
		{
			obituaryweapon = sweapon;
		}
		if( self isenemyplayer( attacker ) == 0 || !(isplayer( attacker )) )
		{
			level notify( "reset_obituary_count" );
			level.lastobituaryplayercount = 0;
			level.lastobituaryplayer = undefined;
		}
		else
		{
			if( level.lastobituaryplayer == attacker && IsDefined( level.lastobituaryplayer ) )
			{
				level.lastobituaryplayercount++;
			}
			else
			{
				level notify( "reset_obituary_count" );
				level.lastobituaryplayer = attacker;
			}
			if( level.lastobituaryplayercount >= 4 )
			{
				level notify( "reset_obituary_count" );
				level.lastobituaryplayercount = 0;
				level.lastobituaryplayer = undefined;
			}
		}
		self.sessionstate = "dead";
		self.statusicon = "hud_status_dead";
		self.killedplayerscurrent = [];
		self.deathcount++;
		lpselfnum = self getentitynumber();
		lpselfname = self.name;
		lpattackguid = "";
		lpattackname = "";
		lpselfteam = self.team;
		lpselfguid = self getguid();
		lpattackteam = "";
		lpattackorigin = ( 0, 0, 0 );
		lpattacknum = -1;
		awardassists = 0;
		if( isplayer( attacker ) )
		{
			lpattackguid = attacker getguid();
			lpattackname = attacker.name;
			lpattackteam = attacker.team;
			lpattackorigin = attacker.origin;
			if( attacker == self )
			{
				dokillcam = 0;
				self.suicide = 1;
			}
			else
			{
				lpattacknum = attacker getentitynumber();
			}
		}
		else
		{
			if( attacker.classname == "worldspawn" && attacker.classname == "trigger_hurt" || IsDefined( attacker ) )
			{
				dokillcam = 0;
				lpattacknum = -1;
				lpattackguid = "";
				lpattackname = "";
				lpattackteam = "world";
				awardassists = 1;
			}
			else
			{
				dokillcam = 0;
				lpattacknum = -1;
				lpattackguid = "";
				lpattackname = "";
				lpattackteam = "world";
				if( IsDefined( einflictor.killcament ) && IsDefined( einflictor ) )
				{
					dokillcam = 1;
					lpattacknum = self getentitynumber();
				}
			}
		}
		if( sessionmodeiszombiesgame() )
		{
			awardassists = 0;
		}
		self.lastattacker = attacker;
		self.lastdeathpos = self.origin;
		if( IsDefined( self.attackers ) )
		{
			self.attackers = [];
		}
		attackerstring = "none";
		killcamentity = self getkillcamentity( eattacker, einflictor, sweapon );
		killcamentityindex = -1;
		killcamentitystarttime = 0;
		if( IsDefined( killcamentity ) )
		{
			killcamentityindex = killcamentity getentitynumber();
			if( IsDefined( killcamentity.starttime ) )
			{
				killcamentitystarttime = killcamentity.starttime;
			}
			else
			{
			}
			if( !(IsDefined( killcamentitystarttime )) )
			{
				killcamentitystarttime = 0;
			}
		}
		died_in_vehicle = 0;
		if( IsDefined( self.diedonvehicle ) )
		{
			died_in_vehicle = self.diedonvehicle;
		}
		self.switching_teams = undefined;
		self.joining_team = undefined;
		self.leaving_team = undefined;
		self thread [[  ]]( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );
		self.wantsafespawn = 0;
		perks = [];
		if( self != attacker && attacker.classname != "worldspawn" && attacker.classname != "trigger_hurt" && IsDefined( attacker ) && smeansofdeath != "MOD_SUICIDE" )
		{
			level thread recordkillcamsettings( lpattacknum, self getentitynumber(), sweapon, self.deathtime, deathtimeoffset, psoffsettime, killcamentityindex, killcamentitystarttime, perks, attacker );
		}
		wait 0.25;
		weaponclass = getweaponclass( sweapon );
		self.cancelkillcam = 0;
		self thread cancelkillcamonuse();
		defaultplayerdeathwatchtime = 0.25;
		if( IsDefined( level.overrideplayerdeathwatchtimer ) )
		{
			defaultplayerdeathwatchtime = [[  ]]( defaultplayerdeathwatchtime );
		}
		waitfortimeornotifies( defaultplayerdeathwatchtime );
		self notify( "death_delay_finished" );
		self.respawntimerstarttime = gettime();
		if( !(abouttoendround())abouttoendround() && level.killcam && dokillcam &&  )
		{
			self killcam( lpattacknum, self getentitynumber(), killcamentity, killcamentityindex, killcamentitystarttime, sweapon, self.deathtime, deathtimeoffset, psoffsettime, 0, 5, perks, attacker );
		}
		self.killcamtargetentity = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		if( !(IsDefined( einflictor )) )
		{
			return undefined;
		}
		if( einflictor == attacker )
		{
			if( !(IsDefined( einflictor.ismagicbullet )) )
			{
				return undefined;
			}
			if( !(einflictor.ismagicbullet)einflictor.ismagicbullet &&  )
			{
				return undefined;
			}
		}
		else
		{
			if( IsDefined( level.levelspecifickillcam ) )
			{
				levelspecifickillcament = self [[  ]]();
				if( IsDefined( levelspecifickillcament ) )
				{
					return levelspecifickillcament;
				}
			}
		}
		if( sweapon == "m220_tow_mp" )
		{
			return undefined;
		}
		if( IsDefined( einflictor.killcament ) )
		{
			if( einflictor.killcament == attacker )
			{
				return undefined;
			}
			return einflictor.killcament;
		}
		else
		{
			if( IsDefined( einflictor.killcamentities ) )
			{
				return getclosestkillcamentity( attacker, einflictor.killcamentities );
			}
		}
		if( einflictor.script_gameobjectname == "bombzone" && IsDefined( einflictor.script_gameobjectname ) )
		{
			return einflictor.killcament;
		}
		return einflictor;
		if( !(IsDefined( depth )) )
		{
			depth = 0;
		}
		closestkillcament = undefined;
		closestkillcamentindex = undefined;
		closestkillcamentdist = undefined;
		origin = undefined;
		foreach( killcament in killcamentities )
		{
			if( killcament == attacker )
			{
			}
			else
			{
				origin = killcament.origin;
				if( IsDefined( killcament.offsetpoint ) )
				{
					origin = origin + killcament.offsetpoint;
				}
				dist = distancesquared( self.origin, origin );
				if( dist < closestkillcamentdist || !(IsDefined( closestkillcament )) )
				{
					closestkillcament = killcament;
					closestkillcamentdist = dist;
					closestkillcamentindex = killcamentindex;
				}
			}
		}
		if( IsDefined( closestkillcament ) && depth < 3 )
		{
			if( !(bullettracepassed( closestkillcament.origin, self.origin, 0, self )) )
			{
				betterkillcament = getclosestkillcamentity( attacker, killcamentities, depth + 1 );
				if( IsDefined( betterkillcament ) )
				{
					closestkillcament = betterkillcament;
				}
			}
		}
		return closestkillcament;
		precachestring( &"PLATFORM_PRESS_TO_SKIP" );
		precachestring( &"PLATFORM_PRESS_TO_RESPAWN" );
		precacheshader( "white" );
		level.killcam = 1;
		level.finalkillcam = 1;
		initfinalkillcam();
		level.finalkillcamsettings = [];
		initfinalkillcamteam( "none" );
		foreach( team in level.teams )
		{
			initfinalkillcamteam( team );
		}
		level.finalkillcam_winner = undefined;
		level.finalkillcamsettings[team] = spawnstruct();
		clearfinalkillcamteam( team );
		level.finalkillcamsettings[ team].spectatorclient = undefined;
		level.finalkillcamsettings[ team].weapon = undefined;
		level.finalkillcamsettings[ team].deathtime = undefined;
		level.finalkillcamsettings[ team].deathtimeoffset = undefined;
		level.finalkillcamsettings[ team].offsettime = undefined;
		level.finalkillcamsettings[ team].entityindex = undefined;
		level.finalkillcamsettings[ team].targetentityindex = undefined;
		level.finalkillcamsettings[ team].entitystarttime = undefined;
		level.finalkillcamsettings[ team].perks = undefined;
		level.finalkillcamsettings[ team].attacker = undefined;
		if( IsDefined( level.teams[ attacker.team] ) && IsDefined( attacker.team ) )
		{
			team = attacker.team;
			level.finalkillcamsettings[ team].spectatorclient = spectatorclient;
			level.finalkillcamsettings[ team].weapon = sweapon;
			level.finalkillcamsettings[ team].deathtime = deathtime;
			level.finalkillcamsettings[ team].deathtimeoffset = deathtimeoffset;
			level.finalkillcamsettings[ team].offsettime = offsettime;
			level.finalkillcamsettings[ team].entityindex = entityindex;
			level.finalkillcamsettings[ team].targetentityindex = targetentityindex;
			level.finalkillcamsettings[ team].entitystarttime = entitystarttime;
			level.finalkillcamsettings[ team].perks = perks;
			level.finalkillcamsettings[ team].attacker = attacker;
		}
		level.finalkillcamsettings[ "none"].spectatorclient = spectatorclient;
		level.finalkillcamsettings[ "none"].weapon = sweapon;
		level.finalkillcamsettings[ "none"].deathtime = deathtime;
		level.finalkillcamsettings[ "none"].deathtimeoffset = deathtimeoffset;
		level.finalkillcamsettings[ "none"].offsettime = offsettime;
		level.finalkillcamsettings[ "none"].entityindex = entityindex;
		level.finalkillcamsettings[ "none"].targetentityindex = targetentityindex;
		level.finalkillcamsettings[ "none"].entitystarttime = entitystarttime;
		level.finalkillcamsettings[ "none"].perks = perks;
		level.finalkillcamsettings[ "none"].attacker = attacker;
		clearfinalkillcamteam( "none" );
		foreach( team in level.teams )
		{
			clearfinalkillcamteam( team );
		}
		level.finalkillcam_winner = undefined;
		if( !(IsDefined( level.finalkillcam_winner )) )
		{
			return 0;
		}
		level waittill( "final_killcam_done" );
		return 1;
		if( level.sidebet && IsDefined( level.sidebet ) )
		{
		}
		level notify( "play_final_killcam" );
		finalkillcamwaiter();
		level waittill( "play_final_killcam" );
		level.infinalkillcam = 1;
		winner = "none";
		if( IsDefined( level.finalkillcam_winner ) )
		{
			winner = level.finalkillcam_winner;
		}
		if( !(IsDefined( level.finalkillcamsettings[ winner].targetentityindex )) )
		{
			level.infinalkillcam = 0;
			level notify( "final_killcam_done" );
		}
		visionsetnaked( getdvar( "mapname" ), 0 );
		players = level.players;
		index = 0;
		while( index < players.size )
		{
			player = players[ index];
			player closemenu();
			player closeingamemenu();
			player thread finalkillcam( winner );
			index++;
		}
		wait 0.1;
		while( areanyplayerswatchingthekillcam() )
		{
			wait 0.05;
		}
		level notify( "final_killcam_done" );
		level.infinalkillcam = 0;
		players = level.players;
		index = 0;
		while( index < players.size )
		{
			player = players[ index];
			if( IsDefined( player.killcam ) )
			{
				return 1;
			}
			index++;
		}
		return 0;
		self endon( "disconnect" );
		self endon( "spawned" );
		level endon( "game_ended" );
		if( attackernum < 0 )
		{
		}
		postdeathdelay = ( gettime() - deathtime ) / 1000;
		predelay += deathtimeoffset;
		camtime = calckillcamtime( sweapon, killcamentitystarttime, predelay, respawn, maxtime );
		postdelay = calcpostdelay();
		killcamlength += postdelay;
		if( killcamlength > maxtime && IsDefined( maxtime ) )
		{
			if( maxtime < 2 )
			{
			}
			if( maxtime - camtime >= 1 )
			{
				postdelay -= camtime;
			}
			else
			{
				postdelay = 1;
			}
			killcamlength += postdelay;
		}
		killcamoffset += predelay;
		self notify( "begin_killcam" );
		killcamstarttime -= killcamoffset * 1000;
		self.sessionstate = "spectator";
		self.spectatorclient = attackernum;
		self.killcamentity = -1;
		if( killcamentityindex >= 0 )
		{
			self thread setkillcamentity( killcamentityindex, killcamentitystarttime - ( killcamstarttime - 100 ) );
		}
		self.killcamtargetentity = targetnum;
		self.archivetime = killcamoffset;
		self.killcamlength = killcamlength;
		self.psoffsettime = offsettime;
		recordkillcamsettings( attackernum, targetnum, sweapon, deathtime, deathtimeoffset, offsettime, killcamentityindex, killcamentitystarttime, perks, attacker );
		foreach( team in level.teams )
		{
			self allowspectateteam( team, 1 );
		}
		self allowspectateteam( "freelook", 1 );
		self allowspectateteam( "none", 1 );
		self thread endedkillcamcleanup();
		wait 0.05;
		if( self.archivetime <= predelay )
		{
			self.sessionstate = "dead";
			self.spectatorclient = -1;
			self.killcamentity = -1;
			self.archivetime = 0;
			self.psoffsettime = 0;
			self notify( "end_killcam" );
		}
		self thread checkforabruptkillcamend();
		self.killcam = 1;
		self addkillcamskiptext( respawn );
		if( level.perksenabled == 1 && !(self issplitscreen()) )
		{
			self addkillcamtimer( camtime );
			self showperks();
		}
		self thread spawnedkillcamcleanup();
		self thread waitskipkillcambutton();
		self thread waitteamchangeendkillcam();
		self thread waitkillcamtime();
		self waittill( "end_killcam" );
		self endkillcam( 0 );
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self endon( "disconnect" );
		self endon( "end_killcam" );
		self endon( "spawned" );
		if( delayms > 0 )
		{
			wait delayms / 1000;
		}
		self.killcamentity = killcamentityindex;
		self endon( "disconnect" );
		self endon( "end_killcam" );
		wait self.killcamlength - 0.05;
		self notify( "end_killcam" );
		self endon( "disconnect" );
		self endon( "end_killcam" );
		setclientsysstate( "levelNotify", "fkcb" );
		setslowmotion( 1, 0.25, 0.5 );
		wait 1.5;
		setslowmotion( 0.25, 1, 1 );
		wait 2;
		setclientsysstate( "levelNotify", "fkce" );
		self endon( "disconnect" );
		self endon( "end_killcam" );
		while( self usebuttonpressed() )
		{
			wait 0.05;
		}
		while( !(self usebuttonpressed()) )
		{
			wait 0.05;
		}
		self notify( "end_killcam" );
		self clientnotify( "fkce" );
		self endon( "disconnect" );
		self endon( "end_killcam" );
		self waittill( "changed_class" );
		endkillcam( 0 );
		self endon( "disconnect" );
		self endon( "end_killcam" );
		while( self fragbuttonpressed() )
		{
			wait 0.05;
		}
		while( !(self fragbuttonpressed()) )
		{
			wait 0.05;
		}
		self.wantsafespawn = 1;
		self notify( "end_killcam" );
		if( IsDefined( self.kc_skiptext ) )
		{
			self.kc_skiptext.alpha = 0;
		}
		if( IsDefined( self.kc_timer ) )
		{
			self.kc_timer.alpha = 0;
		}
		self.killcam = undefined;
		if( !(self issplitscreen()) )
		{
			self hideallperks();
		}
		self thread setspectatepermissions();
		self endon( "disconnect" );
		self endon( "end_killcam" );
		while( 1 )
		{
			if( self.archivetime <= 0 )
			{
				break;
			}
			else
			{
			}
		}
		self notify( "end_killcam" );
		self endon( "end_killcam" );
		self endon( "disconnect" );
		self waittill( "spawned" );
		self endkillcam( 0 );
		self endon( "end_killcam" );
		self endon( "disconnect" );
		attacker endon( "disconnect" );
		attacker waittill( "begin_killcam", attackerkcstarttime );
		waittime = max( 0, attackerkcstarttime - ( self.deathtime - 50 ) );
		wait waittime;
		self endkillcam( 0 );
		self endon( "end_killcam" );
		self endon( "disconnect" );
		level waittill( "game_ended" );
		self endkillcam( 0 );
		self endon( "end_killcam" );
		self endon( "disconnect" );
		level waittill( "game_ended" );
		self endkillcam( 1 );
		return self usebuttonpressed();
		return self fragbuttonpressed();
		self.cancelkillcam = 1;
		self.cancelkillcam = 1;
		self.wantsafespawn = 1;
		self thread cancelkillcamonuse_specificbutton( ::cancelkillcamusebutton, ::cancelkillcamcallback );
		self endon( "death_delay_finished" );
		self endon( "disconnect" );
		level endon( "game_ended" );
		level endon( "play_final_killcam" );
		for(;;)
		{
		while( !(self [[  ]]()) )
		{
			wait 0.05;
		}
		buttontime = 0;
		while( self [[  ]]() )
		{
			buttontime = buttontime + 0.05;
			wait 0.05;
		}
		if( buttontime >= 0.5 )
		{
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
		else
		{
		}
		while( buttontime < 0.5 && !(self [[  ]]()) )
		{
			buttontime = buttontime + 0.05;
			wait 0.05;
		}
		if( buttontime >= 0.5 )
		{
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
		else
		{
			self [[  ]]();
		}
		}
		self endon( "disconnect" );
		level endon( "game_ended" );
		if( level.zsnd_lastround )
		{
			setmatchflag( "final_killcam", 1 );
			setmatchflag( "round_end_killcam", 0 );
		}
		else
		{
			setmatchflag( "final_killcam", 0 );
			setmatchflag( "round_end_killcam", 1 );
		}
		if( level.console )
		{
			self setthirdperson( 0 );
		}
		killcamsettings = level.finalkillcamsettings[ winner];
		postdeathdelay = ( gettime() - killcamsettings.deathtime ) / 1000;
		predelay += killcamsettings.deathtimeoffset;
		camtime = calckillcamtime( killcamsettings.weapon, killcamsettings.entitystarttime, predelay, 0, undefined );
		postdelay = calcpostdelay();
		killcamoffset += predelay;
		killcamlength = camtime + postdelay - 0.05;
		killcamstarttime -= killcamoffset * 1000;
		self notify( "begin_killcam" );
		self.sessionstate = "spectator";
		self.spectatorclient = killcamsettings.spectatorclient;
		self.killcamentity = -1;
		if( killcamsettings.entityindex >= 0 )
		{
			self thread setkillcamentity( killcamsettings.entityindex, killcamsettings.entitystarttime - ( killcamstarttime - 100 ) );
		}
		self.killcamtargetentity = killcamsettings.targetentityindex;
		self.archivetime = killcamoffset;
		self.killcamlength = killcamlength;
		self.psoffsettime = killcamsettings.offsettime;
		foreach( team in level.teams )
		{
			self allowspectateteam( team, 1 );
		}
		self allowspectateteam( "freelook", 1 );
		self allowspectateteam( "none", 1 );
		self thread endedfinalkillcamcleanup();
		wait 0.05;
		if( self.archivetime <= predelay )
		{
			self.spectatorclient = -1;
			self.killcamentity = -1;
			self.archivetime = 0;
			self.psoffsettime = 0;
			self notify( "end_killcam" );
		}
		self thread checkforabruptkillcamend();
		self.killcam = 1;
		if( !(self issplitscreen()) )
		{
			self addkillcamtimer( camtime );
		}
		self thread waitkillcamtime();
		self thread waitfinalkillcamslowdown();
		self waittill( "end_killcam" );
		self endkillcam( 1 );
		setmatchflag( "final_killcam", 0 );
		setmatchflag( "round_end_killcam", 0 );
		self spawnendoffinalkillcam();
		if( sweapon == "planemortar_mp" )
		{
			return 1;
		}
		return 0;
		if( sweapon == "frag_grenade_mp" )
		{
			return 1;
		}
		else
		{
			if( sweapon == "frag_grenade_short_mp" )
			{
				return 1;
			}
			else
			{
				if( sweapon == "sticky_grenade_mp" )
				{
					return 1;
				}
				else
				{
					if( sweapon == "tabun_gas_mp" )
					{
						return 1;
					}
				}
			}
		}
		return 0;
		camtime = 0;
		if( getdvar( #"0xC05D0FE" ) == "" )
		{
			if( iskillcamentityweapon( sweapon ) )
			{
				camtime = 5;
			}
			else
			{
				if( !(respawn) )
				{
					camtime = 5;
				}
				else
				{
					if( iskillcamgrenadeweapon( sweapon ) )
					{
						camtime = 5;
					}
					else
					{
					}
				}
			}
		}
		else
		{
		}
		if( IsDefined( maxtime ) )
		{
			if( camtime > maxtime )
			{
				camtime = maxtime;
			}
			if( camtime < 0.05 )
			{
				camtime = 0.05;
			}
		}
		return camtime;
		postdelay = 0;
		#"0x5C" waittillmatch( 5 );
//Failed to handle op_code: 0xA6
	}

}

getkillcamentity( attacker, einflictor, sweapon )
{
	if( !(IsDefined( einflictor )) )
	{
		return undefined;
	}
	if( einflictor == attacker )
	{
		if( !(IsDefined( einflictor.ismagicbullet )) )
		{
			return undefined;
		}
		if( !(einflictor.ismagicbullet)einflictor.ismagicbullet &&  )
		{
			return undefined;
		}
	}
	else
	{
		if( IsDefined( level.levelspecifickillcam ) )
		{
			levelspecifickillcament = self [[  ]]();
			if( IsDefined( levelspecifickillcament ) )
			{
				return levelspecifickillcament;
			}
		}
	}
	if( sweapon == "m220_tow_mp" )
	{
		return undefined;
	}
	if( IsDefined( einflictor.killcament ) )
	{
		if( einflictor.killcament == attacker )
		{
			return undefined;
		}
		return einflictor.killcament;
	}
	else
	{
		if( IsDefined( einflictor.killcamentities ) )
		{
			return getclosestkillcamentity( attacker, einflictor.killcamentities );
		}
	}
	if( einflictor.script_gameobjectname == "bombzone" && IsDefined( einflictor.script_gameobjectname ) )
	{
		return einflictor.killcament;
	}
	return einflictor;

}

getclosestkillcamentity( attacker, killcamentities, depth )
{
	if( !(IsDefined( depth )) )
	{
		depth = 0;
	}
	closestkillcament = undefined;
	closestkillcamentindex = undefined;
	closestkillcamentdist = undefined;
	origin = undefined;
	foreach( killcament in killcamentities )
	{
		if( killcament == attacker )
		{
		}
		else
		{
			origin = killcament.origin;
			if( IsDefined( killcament.offsetpoint ) )
			{
				origin = origin + killcament.offsetpoint;
			}
			dist = distancesquared( self.origin, origin );
			if( dist < closestkillcamentdist || !(IsDefined( closestkillcament )) )
			{
				closestkillcament = killcament;
				closestkillcamentdist = dist;
				closestkillcamentindex = killcamentindex;
			}
		}
	}
	if( IsDefined( closestkillcament ) && depth < 3 )
	{
		if( !(bullettracepassed( closestkillcament.origin, self.origin, 0, self )) )
		{
			betterkillcament = getclosestkillcamentity( attacker, killcamentities, depth + 1 );
			if( IsDefined( betterkillcament ) )
			{
				closestkillcament = betterkillcament;
			}
		}
	}
	return closestkillcament;

}

kc_init()
{
	precachestring( &"PLATFORM_PRESS_TO_SKIP" );
	precachestring( &"PLATFORM_PRESS_TO_RESPAWN" );
	precacheshader( "white" );
	level.killcam = 1;
	level.finalkillcam = 1;
	initfinalkillcam();

}

initfinalkillcam()
{
	level.finalkillcamsettings = [];
	initfinalkillcamteam( "none" );
	foreach( team in level.teams )
	{
		initfinalkillcamteam( team );
	}
	level.finalkillcam_winner = undefined;

}

initfinalkillcamteam( team )
{
	level.finalkillcamsettings[team] = spawnstruct();
	clearfinalkillcamteam( team );

}

clearfinalkillcamteam( team )
{
	level.finalkillcamsettings[ team].spectatorclient = undefined;
	level.finalkillcamsettings[ team].weapon = undefined;
	level.finalkillcamsettings[ team].deathtime = undefined;
	level.finalkillcamsettings[ team].deathtimeoffset = undefined;
	level.finalkillcamsettings[ team].offsettime = undefined;
	level.finalkillcamsettings[ team].entityindex = undefined;
	level.finalkillcamsettings[ team].targetentityindex = undefined;
	level.finalkillcamsettings[ team].entitystarttime = undefined;
	level.finalkillcamsettings[ team].perks = undefined;
	level.finalkillcamsettings[ team].attacker = undefined;

}

recordkillcamsettings( spectatorclient, targetentityindex, sweapon, deathtime, deathtimeoffset, offsettime, entityindex, entitystarttime, perks, attacker )
{
	if( IsDefined( level.teams[ attacker.team] ) && IsDefined( attacker.team ) )
	{
		team = attacker.team;
		level.finalkillcamsettings[ team].spectatorclient = spectatorclient;
		level.finalkillcamsettings[ team].weapon = sweapon;
		level.finalkillcamsettings[ team].deathtime = deathtime;
		level.finalkillcamsettings[ team].deathtimeoffset = deathtimeoffset;
		level.finalkillcamsettings[ team].offsettime = offsettime;
		level.finalkillcamsettings[ team].entityindex = entityindex;
		level.finalkillcamsettings[ team].targetentityindex = targetentityindex;
		level.finalkillcamsettings[ team].entitystarttime = entitystarttime;
		level.finalkillcamsettings[ team].perks = perks;
		level.finalkillcamsettings[ team].attacker = attacker;
	}
	level.finalkillcamsettings[ "none"].spectatorclient = spectatorclient;
	level.finalkillcamsettings[ "none"].weapon = sweapon;
	level.finalkillcamsettings[ "none"].deathtime = deathtime;
	level.finalkillcamsettings[ "none"].deathtimeoffset = deathtimeoffset;
	level.finalkillcamsettings[ "none"].offsettime = offsettime;
	level.finalkillcamsettings[ "none"].entityindex = entityindex;
	level.finalkillcamsettings[ "none"].targetentityindex = targetentityindex;
	level.finalkillcamsettings[ "none"].entitystarttime = entitystarttime;
	level.finalkillcamsettings[ "none"].perks = perks;
	level.finalkillcamsettings[ "none"].attacker = attacker;

}

erasefinalkillcam()
{
	clearfinalkillcamteam( "none" );
	foreach( team in level.teams )
	{
		clearfinalkillcamteam( team );
	}
	level.finalkillcam_winner = undefined;

}

finalkillcamwaiter()
{
	if( !(IsDefined( level.finalkillcam_winner )) )
	{
		return 0;
	}
	level waittill( "final_killcam_done" );
	return 1;

}

postroundfinalkillcam()
{
	if( level.sidebet && IsDefined( level.sidebet ) )
	{
	}
	level notify( "play_final_killcam" );
	finalkillcamwaiter();

}

dofinalkillcam()
{
	level waittill( "play_final_killcam" );
	level.infinalkillcam = 1;
	winner = "none";
	if( IsDefined( level.finalkillcam_winner ) )
	{
		winner = level.finalkillcam_winner;
	}
	if( !(IsDefined( level.finalkillcamsettings[ winner].targetentityindex )) )
	{
		level.infinalkillcam = 0;
		level notify( "final_killcam_done" );
	}
	visionsetnaked( getdvar( "mapname" ), 0 );
	players = level.players;
	index = 0;
	while( index < players.size )
	{
		player = players[ index];
		player closemenu();
		player closeingamemenu();
		player thread finalkillcam( winner );
		index++;
	}
	wait 0.1;
	while( areanyplayerswatchingthekillcam() )
	{
		wait 0.05;
	}
	level notify( "final_killcam_done" );
	level.infinalkillcam = 0;

}

startlastkillcam()
{

}

areanyplayerswatchingthekillcam()
{
	players = level.players;
	index = 0;
	while( index < players.size )
	{
		player = players[ index];
		if( IsDefined( player.killcam ) )
		{
			return 1;
		}
		index++;
	}
	return 0;

}

killcam( attackernum, targetnum, killcamentity, killcamentityindex, killcamentitystarttime, sweapon, deathtime, deathtimeoffset, offsettime, respawn, maxtime, perks, attacker )
{
	self endon( "disconnect" );
	self endon( "spawned" );
	level endon( "game_ended" );
	if( attackernum < 0 )
	{
	}
	postdeathdelay = ( gettime() - deathtime ) / 1000;
	predelay += deathtimeoffset;
	camtime = calckillcamtime( sweapon, killcamentitystarttime, predelay, respawn, maxtime );
	postdelay = calcpostdelay();
	killcamlength += postdelay;
	if( killcamlength > maxtime && IsDefined( maxtime ) )
	{
		if( maxtime < 2 )
		{
		}
		if( maxtime - camtime >= 1 )
		{
			postdelay -= camtime;
		}
		else
		{
			postdelay = 1;
		}
		killcamlength += postdelay;
	}
	killcamoffset += predelay;
	self notify( "begin_killcam" );
	killcamstarttime -= killcamoffset * 1000;
	self.sessionstate = "spectator";
	self.spectatorclient = attackernum;
	self.killcamentity = -1;
	if( killcamentityindex >= 0 )
	{
		self thread setkillcamentity( killcamentityindex, killcamentitystarttime - ( killcamstarttime - 100 ) );
	}
	self.killcamtargetentity = targetnum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsettime;
	recordkillcamsettings( attackernum, targetnum, sweapon, deathtime, deathtimeoffset, offsettime, killcamentityindex, killcamentitystarttime, perks, attacker );
	foreach( team in level.teams )
	{
		self allowspectateteam( team, 1 );
	}
	self allowspectateteam( "freelook", 1 );
	self allowspectateteam( "none", 1 );
	self thread endedkillcamcleanup();
	wait 0.05;
	if( self.archivetime <= predelay )
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self notify( "end_killcam" );
	}
	self thread checkforabruptkillcamend();
	self.killcam = 1;
	self addkillcamskiptext( respawn );
	if( level.perksenabled == 1 && !(self issplitscreen()) )
	{
		self addkillcamtimer( camtime );
		self showperks();
	}
	self thread spawnedkillcamcleanup();
	self thread waitskipkillcambutton();
	self thread waitteamchangeendkillcam();
	self thread waitkillcamtime();
	self waittill( "end_killcam" );
	self endkillcam( 0 );
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;

}

setkillcamentity( killcamentityindex, delayms )
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	self endon( "spawned" );
	if( delayms > 0 )
	{
		wait delayms / 1000;
	}
	self.killcamentity = killcamentityindex;

}

waitkillcamtime()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	wait self.killcamlength - 0.05;
	self notify( "end_killcam" );

}

waitfinalkillcamslowdown()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	setclientsysstate( "levelNotify", "fkcb" );
	setslowmotion( 1, 0.25, 0.5 );
	wait 1.5;
	setslowmotion( 0.25, 1, 1 );
	wait 2;
	setclientsysstate( "levelNotify", "fkce" );

}

waitskipkillcambutton()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	while( self usebuttonpressed() )
	{
		wait 0.05;
	}
	while( !(self usebuttonpressed()) )
	{
		wait 0.05;
	}
	self notify( "end_killcam" );
	self clientnotify( "fkce" );

}

waitteamchangeendkillcam()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	self waittill( "changed_class" );
	endkillcam( 0 );

}

waitskipkillcamsafespawnbutton()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	while( self fragbuttonpressed() )
	{
		wait 0.05;
	}
	while( !(self fragbuttonpressed()) )
	{
		wait 0.05;
	}
	self.wantsafespawn = 1;
	self notify( "end_killcam" );

}

endkillcam( final )
{
	if( IsDefined( self.kc_skiptext ) )
	{
		self.kc_skiptext.alpha = 0;
	}
	if( IsDefined( self.kc_timer ) )
	{
		self.kc_timer.alpha = 0;
	}
	self.killcam = undefined;
	if( !(self issplitscreen()) )
	{
		self hideallperks();
	}
	self thread setspectatepermissions();

}

checkforabruptkillcamend()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	while( 1 )
	{
		if( self.archivetime <= 0 )
		{
			break;
		}
		else
		{
		}
	}
	self notify( "end_killcam" );

}

spawnedkillcamcleanup()
{
	self endon( "end_killcam" );
	self endon( "disconnect" );
	self waittill( "spawned" );
	self endkillcam( 0 );

}

spectatorkillcamcleanup( attacker )
{
	self endon( "end_killcam" );
	self endon( "disconnect" );
	attacker endon( "disconnect" );
	attacker waittill( "begin_killcam", attackerkcstarttime );
	waittime = max( 0, attackerkcstarttime - ( self.deathtime - 50 ) );
	wait waittime;
	self endkillcam( 0 );

}

endedkillcamcleanup()
{
	self endon( "end_killcam" );
	self endon( "disconnect" );
	level waittill( "game_ended" );
	self endkillcam( 0 );

}

endedfinalkillcamcleanup()
{
	self endon( "end_killcam" );
	self endon( "disconnect" );
	level waittill( "game_ended" );
	self endkillcam( 1 );

}

cancelkillcamusebutton()
{
	return self usebuttonpressed();

}

cancelkillcamsafespawnbutton()
{
	return self fragbuttonpressed();

}

cancelkillcamcallback()
{
	self.cancelkillcam = 1;

}

cancelkillcamsafespawncallback()
{
	self.cancelkillcam = 1;
	self.wantsafespawn = 1;

}

cancelkillcamonuse()
{
	self thread cancelkillcamonuse_specificbutton( ::cancelkillcamusebutton, ::cancelkillcamcallback );

}

cancelkillcamonuse_specificbutton( pressingbuttonfunc, finishedfunc )
{
	self endon( "death_delay_finished" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	level endon( "play_final_killcam" );
	while( !(self [[  ]]()) )
	{
		wait 0.05;
		continue;
		break;
	}
	buttontime = 0;
	while( self [[  ]]() )
	{
		buttontime = buttontime + 0.05;
		wait 0.05;
	}
	if( buttontime >= 0.5 )
	{
		continue;
	}
	else
	{
	}
	while( buttontime < 0.5 && !(self [[  ]]()) )
	{
		buttontime = buttontime + 0.05;
		wait 0.05;
	}
	if( buttontime >= 0.5 )
	{
		continue;
	}
	else
	{
		self [[  ]]();
	}
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

finalkillcam( winner )
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	if( level.zsnd_lastround )
	{
		setmatchflag( "final_killcam", 1 );
		setmatchflag( "round_end_killcam", 0 );
	}
	else
	{
		setmatchflag( "final_killcam", 0 );
		setmatchflag( "round_end_killcam", 1 );
	}
	if( level.console )
	{
		self setthirdperson( 0 );
	}
	killcamsettings = level.finalkillcamsettings[ winner];
	postdeathdelay = ( gettime() - killcamsettings.deathtime ) / 1000;
	predelay += killcamsettings.deathtimeoffset;
	camtime = calckillcamtime( killcamsettings.weapon, killcamsettings.entitystarttime, predelay, 0, undefined );
	postdelay = calcpostdelay();
	killcamoffset += predelay;
	killcamlength = camtime + postdelay - 0.05;
	killcamstarttime -= killcamoffset * 1000;
	self notify( "begin_killcam" );
	self.sessionstate = "spectator";
	self.spectatorclient = killcamsettings.spectatorclient;
	self.killcamentity = -1;
	if( killcamsettings.entityindex >= 0 )
	{
		self thread setkillcamentity( killcamsettings.entityindex, killcamsettings.entitystarttime - ( killcamstarttime - 100 ) );
	}
	self.killcamtargetentity = killcamsettings.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = killcamsettings.offsettime;
	foreach( team in level.teams )
	{
		self allowspectateteam( team, 1 );
	}
	self allowspectateteam( "freelook", 1 );
	self allowspectateteam( "none", 1 );
	self thread endedfinalkillcamcleanup();
	wait 0.05;
	if( self.archivetime <= predelay )
	{
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self notify( "end_killcam" );
	}
	self thread checkforabruptkillcamend();
	self.killcam = 1;
	if( !(self issplitscreen()) )
	{
		self addkillcamtimer( camtime );
	}
	self thread waitkillcamtime();
	self thread waitfinalkillcamslowdown();
	self waittill( "end_killcam" );
	self endkillcam( 1 );
	setmatchflag( "final_killcam", 0 );
	setmatchflag( "round_end_killcam", 0 );
	self spawnendoffinalkillcam();

}

spawnendoffinalkillcam()
{

}

iskillcamentityweapon( sweapon )
{
	if( sweapon == "planemortar_mp" )
	{
		return 1;
	}
	return 0;

}

iskillcamgrenadeweapon( sweapon )
{
	if( sweapon == "frag_grenade_mp" )
	{
		return 1;
	}
	else
	{
		if( sweapon == "frag_grenade_short_mp" )
		{
			return 1;
		}
		else
		{
			if( sweapon == "sticky_grenade_mp" )
			{
				return 1;
			}
			else
			{
				if( sweapon == "tabun_gas_mp" )
				{
					return 1;
				}
			}
		}
	}
	return 0;

}

calckillcamtime( sweapon, entitystarttime, predelay, respawn, maxtime )
{
	camtime = 0;
	if( getdvar( #"0xC05D0FE" ) == "" )
	{
		if( iskillcamentityweapon( sweapon ) )
		{
			camtime = 5;
		}
		else
		{
			if( !(respawn) )
			{
				camtime = 5;
			}
			else
			{
				if( iskillcamgrenadeweapon( sweapon ) )
				{
					camtime = 5;
				}
				else
				{
				}
			}
		}
	}
	else
	{
	}
	if( IsDefined( maxtime ) )
	{
		if( camtime > maxtime )
		{
			camtime = maxtime;
		}
		if( camtime < 0.05 )
		{
			camtime = 0.05;
		}
	}
	return camtime;

}

