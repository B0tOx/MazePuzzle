class Map 
{ 
  int rows, cols;  //Anzahl reihen, spalten, Skalieren zum Malen
  Square[][] squares; //2D Liste für das Spiel feld
  float collumnWidth;
  float WallHeight;
  PImage background, backgroundUp, backgroundDown;
  int startingPointX, startingPointY;
  IntList dir = new IntList();
  int difficulty;

  PImage[] stoneSlice, dirtSlice, cobblestoneSlice, redstoneSlice;

  int rS, gS, bS, rE, gE, bE;
  int backR, backG, backB;

  Map(Player player, int spX, int spY, boolean lowMode, int diff) 
  {
    this.WallHeight = height / 1.2;
    this.collumnWidth = width / player.rays.length;
    this.background = loadImage("backgroundLight.jpg");
    this.backgroundUp = loadImage("backgroundUp.jpg");
    this.backgroundDown = loadImage("backgroundDown.jpg");
    this.startingPointX = spX;
    this.startingPointY = spY;
    this.difficulty = diff;

    dir.append(1);
    dir.append(2);
    dir.append(3);
    dir.append(4);

    this.rS = 45; 
    this.gS = 238; 
    this.bS = 10; 
    this.rE = 201; 
    this.gE = 50; 
    this.bE = 50; 
    this.backR = 140; 
    this.backG = 140; 
    this.backB = 140; 

    stoneSlice = sliceTexture(loadImage("stone.jpg"));
    dirtSlice = sliceTexture(loadImage("dirt.jpg"));
    cobblestoneSlice = sliceTexture(loadImage("cobblestone.jpg"));
    redstoneSlice = sliceTexture(loadImage("redstone_ore.jpg"));

    //LOW

    if (lowMode) {
      stoneSlice = sliceTexture(loadImage("stoneLOW.jpg"));
      dirtSlice = sliceTexture(loadImage("dirtLOW.jpg"));
      cobblestoneSlice = sliceTexture(loadImage("cobblestoneLOW.jpg"));
      redstoneSlice = sliceTexture(loadImage("redstone_oreLOW.jpg"));
    }
    
    newScale(difficulty);
    createMap();
  }

  void newScale(int type) {
    switch (type) { 
      case(0):
      rows = int(random(10, 15));
      cols = int(random(10, 15));
      break;

      case(1):
      rows = int(random(15, 20));
      cols = int(random(15, 20));
      break;

      case(2):
      rows = int(random(25, 25));
      cols = int(random(35, 35));
      break;

      case(3):
      rows = int(random(35, 55));
      cols = int(random(35, 55));
      break;
    }
    if (rows % 2 == 0) rows += 1;
    if (cols % 2 == 0) cols += 1;
  }

  void drawMap(Player player, Map map, boolean weirdMode) {
    drawWalls(player, map, weirdMode);
    if (keys[6]) map.drawMiniMap(player);
  }

  void generateSquares() {        
    recursiveGeneration(startingPointX, startingPointY);
  }

  void createMap() {
    squares = new Square[cols][rows];
    fillMap();
    generateSquares();
    mixMap();
    startFin();
  }

  void mixMap() {
    for (int y = 0; y < rows; y++) 
    {  
      for (int x = 0; x < cols; x++) 
      {
        if (squares[x][y].type != 0) {
          float type = random(1, 5);
          if (type < 2.8) squares[x][y].type = 1;
          if (type >= 2.8 && type < 3.1) squares[x][y].type = 2;
          if (type >= 3.1 && type < 4.6) squares[x][y].type = 3;
          if (type >= 4.6 && type < 6) squares[x][y].type = 4;
        }
      }
    }
  }

  void startFin() {
    squares[cols-1][rows-2].type = 21;
    squares[cols-2][rows-1].type = 21;
    squares[cols-2][rows-2].type = 23;

    squares[1][0].type = 20;
    squares[0][1].type = 20;
    squares[1][1].type = 22;
  }

  void fillMap() {
    for (int y = 0; y < rows; y++) 
    {  
      for (int x = 0; x < cols; x++) 
      {
        squares[x][y] = new Square(1);
      }
    }
  }

  void resetMap(Player player, boolean keys[]) {
    player.pos.x = startingPointX + 0.5;
    player.pos.y = startingPointY + 0.5;

    keys[6] = false;
    println(rows, cols);
    createMap();
  }

  void recursiveGeneration(int x, int y) {
    squares[x][y].type = 0;
    IntList dir1 = dir.copy();
    dir1.shuffle();
    for (int i = 0; i < dir.size(); i++) {   
      switch (dir1.get(i)) {
        case(1):    
        if (y - 1 <= 0 || y - 2 <= 0) break;     
        if (squares[x][y-1].type == 1 && squares[x][y-2].type == 1 && squares[x-1][y-1].type == 1 && squares[x+1][y-1].type == 1 && squares[x-1][y-2].type == 1 && squares[x+1][y-2].type == 1) { 
          squares[x][y-1].type = 0; 
          recursiveGeneration(x, y-2);
        }
        break;

        case(2):       
        if (x + 1 >= cols-1 || x + 2 >= cols-1) break;   
        if (squares[x+1][y].type == 1 && squares[x+2][y].type == 1 && squares[x+1][y-1].type == 1 && squares[x+1][y+1].type == 1 && squares[x+2][y-1].type == 1 && squares[x+2][y+1].type == 1) { 
          squares[x+1][y].type = 0;  
          recursiveGeneration(x+2, y);
        }
        break;

        case(3): 
        if (y + 1 >= rows-1 || y + 2 >= rows-1) break;  
        if (squares[x][y+1].type == 1 && squares[x][y+2].type == 1 && squares[x+1][y+1].type == 1 && squares[x-1][y+1].type == 1 && squares[x+1][y+2].type == 1 && squares[x-1][y+2].type == 1) { 
          squares[x][y+1].type = 0;  
          recursiveGeneration(x, y+2);
        }
        break;

        case(4): 
        if (x - 1 <= 0 || x - 2 <= 0) break;   
        if (squares[x-1][y].type == 1 && squares[x-2][y].type == 1 && squares[x-1][y+1].type == 1 && squares[x-1][y-1].type == 1 && squares[x-2][y+1].type == 1 && squares[x-2][y-1].type == 1) { 
          squares[x-1][y].type = 0;  
          recursiveGeneration(x-2, y);
        }
        break;
      }
    }
  }

  void drawWalls(Player player, Map map, boolean weirdMode)
  {
    tint(backR / 2, backG / 2, backB / 2);
    imageMode(CORNER);
    if (!weirdMode) image(background, 0, 0, width, height);
    else if (weirdMode && keys[7]) image(backgroundUp, 0, 0, width, height);
    else if (weirdMode &! keys[7]) image(backgroundDown, 0, 0, width, height);

    rectMode(CENTER);
    noStroke();
    for (int i = 0; i < player.rays.length; i++)
    {
      PVector rayAngle = new PVector(player.dir.x - player.cameraPlane.x + ((player.cameraPlane.x * 2) / (player.rays.length - 1)) * i, player.dir.y - player.cameraPlane.y + ((player.cameraPlane.y * 2) / (player.rays.length - 1)) * i);

      Ray ray = player.rays[i];

      wallContainer wallCon = ray.cast(player.tilePos(), player.pos, map, degrees(-rayAngle.heading()));

      PVector pt = wallCon.pt;

      float deltaX = pt.x - player.pos.x;
      float deltaY = pt.y - player.pos.y;

      float disAlongView = deltaX * cos(player.dir.heading()) + deltaY * sin(player.dir.heading());

      float visualType = (height / 2) + (player.pos.z / disAlongView);
      if (weirdMode) visualType = (height / 2) + (player.pos.z * disAlongView / 2) + (abs(player.pos.z) / disAlongView);

      switch(wallCon.type) {
        case(0):
        break;

        case(1):
        imageMode(CENTER);
        tint(255 * (1 / sq(disAlongView / 6 + 1)));
        image(stoneSlice[int(map(wallCon.texDisX, 0, 1, 0, stoneSlice.length-1))], (collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

        case(2):
        imageMode(CENTER);
        tint(255 * (1 / sq(disAlongView / 6 + 1)));
        image(dirtSlice[int(map(wallCon.texDisX, 0, 1, 0, dirtSlice.length-1))], (collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

        case(3):
        imageMode(CENTER);
        tint(255 * (1 / sq(disAlongView / 6 + 1)));
        image(cobblestoneSlice[int(map(wallCon.texDisX, 0, 1, 0, dirtSlice.length-1))], (collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

        case(4):
        imageMode(CENTER);
        tint(255 * (1 / sq(disAlongView / 6 + 1)));
        image(redstoneSlice[int(map(wallCon.texDisX, 0, 1, 0, dirtSlice.length-1))], (collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

        case(20):
        //fill(rS * (1 / sq(disAlongView / 6 + 1)), gS * (1 / sq(disAlongView / 6 + 1)), bS * (1 / sq(disAlongView / 6 + 1))); 
        fill(rS, gS, bS);
        rect((collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

        case(21):
        //fill(rE * (1 / sq(disAlongView / 6+ 1)), gE * (1 / sq(disAlongView / 6 + 1)), bE * (1 / sq(disAlongView / 6 + 1))); 
        fill(rE, gE, bE);
        rect((collumnWidth * i) + (collumnWidth / 2), visualType, collumnWidth, WallHeight / disAlongView);
        break;

      default:
        break;
      }
    }
  }

  void drawMiniMap(Player player)
  {
    pushMatrix();
    noStroke();
    fill(70);
    rect(width / 12, height - height / 7, width / 12, width / 12);

    float rectSize = height/135;

    translate(width / 12 - player.pos.x * rectSize, (height - height / 7) - player.pos.y * rectSize);  
    for (int y = constrain(int(player.pos.y) - 9, 0, rows); y < constrain(int(player.pos.y) + 11, 0, rows); y++) {
      for (int x = constrain(int(player.pos.x) - 9, 0, cols); x < constrain(int(player.pos.x) + 11, 0, cols); x++) {
        fill(70);
        if (squares[x][y].type == 0) fill(175);
        if (squares[x][y].type == 22) fill(rS, gS, bS);
        if (squares[x][y].type == 23) fill(rE, gE, bE);
        noStroke();
        square(x * rectSize, y * rectSize, rectSize);

        fill(255, 0, 0);
        circle((player.pos.x * rectSize) - rectSize/2, (player.pos.y * rectSize) - rectSize/2, rectSize);

        strokeWeight(2);
        stroke(255, 0, 0);
        line((player.pos.x * rectSize) - rectSize/2, (player.pos.y * rectSize) - rectSize/2, ((player.pos.x * rectSize) - rectSize/2) + player.dir.x * rectSize, ((player.pos.y * rectSize) - rectSize/2 + player.dir.y * rectSize));
      }
    }    
    popMatrix();
    noFill();
    strokeWeight(height/36);
    stroke(30, 30, 35);
    rect(width / 12, height - height / 7, width / 12, width / 12);
  }

  PImage[] sliceTexture(PImage texture) {
    texture.loadPixels();
    PImage textureArray[] = new PImage[texture.width];
    for (int x = 0; x < texture.width; x++) 
    {  
      PImage textureSlice = createImage(1, texture.height, RGB);
      textureSlice.loadPixels();
      for (int y = 0; y < texture.height; y++) 
      {
        textureSlice.pixels[y] = texture.pixels[y * texture.width + x];
      }
      textureSlice.updatePixels();
      textureArray[x] = textureSlice;
    }   
    return textureArray;
  }
}
