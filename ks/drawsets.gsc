welcomeMessage(text, text1, icon, glow){
	hmb=spawnstruct();
	hmb.titleText=text;
	hmb.notifyText=text1;
	hmb.iconName=icon;
	hmb.glowColor= (0.2, 0.3, 0.6);
	hmb.hideWhenInMenu=true;
	hmb.archived=false;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(hmb);}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort, allclients){
	if (!isDefined(allclients))
		allclients = false;
	if (!allclients)
		hud = self createFontString(font, fontScale);
	else
		hud = level createServerFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.alpha = alpha;
	hud.glowColor = glowColor;
	hud.glowAlpha = glowAlpha;
	hud.sort = sort;
	hud.alpha = alpha;
	return hud;}
