drawValue(value, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort, allclients)
{
    if (!isDefined(allclients))
        allclients = false;
    
    if (!allclients)
        hud = self createFontString(font, fontScale);
    else
        hud = level createServerFontString(font, fontScale);
    hud setValue(value);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    return hud;
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort, allclients)
{
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
    return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort, allclients)
{
    if (!isDefined(allclients))
        allclients = false;
    
    if (!allclients)
        hud = newClientHudElem(self);
    else
        hud = newHudElem();
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

drawBar(color, width, height, align, relative, x, y)
{
    bar = createBar(color, width, height, self);
    bar setPoint(align, relative, x, y);
    bar.hideWhenInMenu = true;
    return bar;
}

createText( font, fontScale, text, point, relative, xOffset, yOffset, sort, hideWhenInMenu, alpha, color, glowAlpha, glowColor )
{
    textElem = createFontString(font, fontScale);
    textElem setPoint( point, relative, xOffset, yOffset );
    textElem.sort = sort;
    textElem.hideWhenInMenu = hideWhenInMenu;
    textElem.alpha = alpha;
    textElem.color = color;
    textElem.glowAlpha = glowAlpha;
    textElem.glowColor = glowColor;
    level.result += 1;
    textElem setText(text);
    level notify("textset");

    return textElem;
}

createRectangle(align, relative, x, y, width, height, sort, shader)
{
    shaderElem = newClientHudElem(self);
    shaderElem.elemType = "bar";
    shaderElem.children = [];
    shaderElem.sort = sort;
    shaderElem setParent(level.uiParent);
    shaderElem setShader(shader, width , height);
    shaderElem.hideWhenInMenu = false;
    shaderElem setPoint(align, relative, x, y);
    shaderElem.type = "shader";
    
    return shaderElem;
}

setColor(r, g, b, a)
{
    self.color = (r, g, b);
    self.alpha = a;
}

setGlow(r, g, b, a)
{
    self.glowColor = (r, g, b);
    self.glowAlpha = a;
}

Typewriter(arg1, arg2, arg3, arg4)
{
    notifyData = spawnstruct();
    notifyData.titleText = arg1;
    notifyData.notifyText = arg2;
    notifyData.glowColor = arg3;
    notifyData.duration = arg4;
    notifyData.font = "objective"; //font
    notifyData.hideWhenInMenu = false;
    self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}


