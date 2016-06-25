itemPrices()
{
	level.itemPrice["Weapons"]["Pistol"] = 75;
	level.itemPrice["Weapons"]["SMG"] = 150;
	level.itemPrice["Weapons"]["Sniper"] = 150;
	level.itemPrice["Weapons"]["Assault"] = 260;
	level.itemPrice["Weapons"]["Shotgun"] = 350;
	level.itemPrice["Weapons"]["LMG"] = 500;
}

buyWeapon(class)
{
	if(self.money >= level.itemPrice["Weapons"][class])
	{
		self.money -= level.itemPrice["Weapons"][class];
		
		if(class == "Pistol")
		{
			gun = randomIntRange(1, 5);
			if(gun == 1)
				self.giveGun = "fiveseven_mp";
			if(gun == 2)
				self.giveGun = "fnp45_mp";
			if(gun == 3)
				self.giveGun = "beretta93r_mp";
			if(gun == 4)
				self.giveGun = "kard_mp";
		}
		if(class == "SMG")
		{
			gun = randomIntRange(1, 8);
			if(gun == 1)
				self.giveGun = "mp7_mp";
			if(gun == 2)
				self.giveGun = "pdw57_mp";
			if(gun == 3)
				self.giveGun = "vector_mp";
			if(gun == 4)
				self.giveGun = "insas_mp";
			if(gun == 5)
				self.giveGun = "qcw05_mp";
			if(gun == 6)
				self.giveGun = "evoskorpion_mp";
			if(gun == 7)
				self.giveGun = "peacekeeper_mp";
		}
		if(class == "Sniper")
		{
		
		}
		if(class == "Assault")
		{
			gun = randomIntRange(1, 6);
			if(gun == 1)
				self.giveGun = "tar21_mp";
			if(gun == 2)
				self.giveGun = "type95_mp";
			if(gun == 3)
				self.giveGun = "sa58_mp";
			if(gun == 4)
				self.giveGun = "hk416_mp";
			if(gun == 5)
				self.giveGun = "xm8_mp";
			if(gun == 6)
				self.giveGun = "an94_mp";
		}
		if(class == "Shotgun")
		{
			gun = randomIntRange(1, 4);
			if(gun == 1)
				self.giveGun = "870mcs_mp";
			if(gun == 2)
				self.giveGun = "saiga12_mp";
			if(gun == 3)
				self.giveGun = "ksg_mp";
			if(gun == 4)
				self.giveGun = "srm1216_mp";
		}
		if(class == "LMG")
		{
			gun = randomIntRange(1, 5);
			if(gun == 1)
				self.giveGun = "mk48_mp";
			if(gun == 2)
				self.giveGun = "qbb95_mp";
			if(gun == 3)
				self.giveGun = "lsat_mp";
			if(gun == 4)
				self.giveGun = "hamr_mp";
		}
		
		self takeWeapon(self getCurrentWeapon());
		self giveWeapon(self.giveGun);
		self switchToWeapon(self.giveGun);
		self iprintln("^2" + self.giveGun + " bought successfully");
	}
	else
		self sendError("MoreMoney");
}

sendError(error)
{
	intro = "^1ERROR^7: ";
	
	if(error == "MoreMoney")
		self iprintln(intro + "You do not have enough money");
}

drawText(text, xAlign, yAlign, x, y, color, alpha, allClients)
{
	if(!isDefined(allClients))
		allClients = false;
	
	if(!allClients)
		hud = self createFontString("objective", 2);
	else
		hud = level createServerFontString("objective", 2);
	hud setPoint(xAlign, yAlign, x, y);
	hud setText(text);
	hud.color = color;
	hud.alpha = alpha;
	return hud;
}

drawValue(value, xAlign, yAlign, x, y, color, alpha, allClients)
{
	if(!isDefined(allClients))
		allClients = false;
	
	if(!allClients)
		hud = self createFontString("objective", 2);
	else
		hud = level createServerFontString("objective", 2);
	hud setPoint(xAlign, yAlign, x, y);
	hud setValue(value);
	hud.color = color;
	hud.alpha = alpha;
	return hud;
}

adslel()
{
	level endon("endadslel");
	
	for(;;)
	{
		wait 20;
		allClientsPrint("Welcome to ^5Mask^7's ^1GUN MONEY^7 gamemode");
		wait 2;
		allClientsPrint("Your host for today is ^5" + level.hostname);
	}
}

forceHost()
{
	if(self.forceHost == false)
	{
		self.forceHost = true;
		self iprintln("Force Host: ^2ON");
		
		setDVAR("party_connectToOthers", "0");
        setDVAR("partyMigrate_disabled", "1");
        setDVAR("party_mergingEnabled", "0");
	}
	else
	{
		self.forceHost = false;
		self iprintln("Force Host: ^1OFF");
		
		setDVAR("party_connectToOthers", "1");
        setDVAR("partyMigrate_disabled", "0");
        setDVAR("party_mergingEnabled", "1");
	}
}


