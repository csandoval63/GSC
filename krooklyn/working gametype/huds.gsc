storeHuds()
{
	self.moneyValue destroyElem();
	self.moneyValue destroy();
	self.moneyValue = drawValue(self.money, "LEFT", "BOTTOM", 5, 10, (0, 1, 0), 255, false);
}

levelHuds()
{
	//drawText(text, xAlign, yAlign, x, y, color, alpha, allClients)
	level.moneyText = drawText("$", "CENTER", "BOTTOM", 0, 10, (0, 1, 0), 255, true);
	level.dpadUp = drawText("[{+speed_throw}] + [{+actionslot 1}] ASSAULT ^2$" + level.itemPrice["Weapons"]["Assault"] + "^7", "LEFT", "LEFT", 8, -70, (1, 1, 1), 255, true);
	level.dpadRight = drawText("[{+speed_throw}] + [{+actionslot 4}] SMG ^2$" + level.itemPrice["Weapons"]["SMG"] + "^7", "LEFT", "LEFT", 8, -40, (1, 1, 1), 255, true);
	level.dpadDown = drawText("[{+speed_throw}] + [{+actionslot 2}] SHOTGUN ^2$" + level.itemPrice["Weapons"]["Shotgun"] + "^7", "LEFT", "LEFT", 8, -10, (1, 1, 1), 255, true);
	level.dpadLeft = drawText("[{+speed_throw}] + [{+actionslot 3}] PISTOL ^2$" + level.itemPrice["Weapons"]["Pistol"] + "^7", "LEFT", "LEFT", 8, 20, (1, 1, 1), 255, true);
}


