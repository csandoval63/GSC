StoreShaders()
{
    self.menu.background = self drawShader("white", 0, -100, 250, 1000, (0, 0, 0), 0, 0);
    self.menu.background1 = self drawShader("white", 0, -100, 250, 1000, (1, 0, 0), 0, 0);
    
    self.menu.scroller = self drawShader("white", 0, -100, 250, 18, (0, 0, 0), 255, 1);
    
    self.menu.line = self drawShader("white", 125, -1000, 2, 500, (0, 0, 0), 255, 2);
    self.menu.line2 = self drawShader("white", -125, -1000, 2, 500, (0, 0, 0), 255, 3);
    self.menu.line3 = self drawShader("white", 0, -100, 250, 2, (0, 0, 0), 255, 4);
    
    self.menu.Material = self drawShader("white", 168, -1000, 170, 2, (0, 0, 0), 1, 0);
}


