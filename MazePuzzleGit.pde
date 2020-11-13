Map map; 
Player player; 
boolean[] keys; 
PVector initialPos; 
boolean lowMode;
boolean weirdMode;
int fps;
int difficulty;

void setup() {
  fps = 60;
  frameRate(fps);
  fullScreen(P2D);
  //size(800, 600, P2D);

  lowMode = false;
  weirdMode = false; //Toggle with Control if enabled
  difficulty = 0; //0 = Easy, 1 = Medium, 2 = Hard, 3 = Impossible

  initialPos = new PVector(1.5, 1.5);
  player = new Player(0.1, initialPos.x, initialPos.y, width, 0.04, lowMode, fps); 
  map = new Map(player, int(initialPos.x), int(initialPos.y), lowMode, difficulty); 

  keys = new boolean[9];
  keys[0] = false;
  keys[1] = false;
  keys[2] = false;
  keys[3] = false;
  keys[4] = false;
  keys[5] = false;
  keys[6] = false;
  keys[7] = false;
  keys[8] = false;
}

void draw() {
  background(0); 
  player.movement(keys, map);
  map.drawMap(player, map, weirdMode);
  player.checkFinished(keys);
}

void keyPressed() {
  if (keyCode == 87) keys[0] = true; // W
  if (keyCode == 83) keys[1] = true; // S
  if (keyCode == 65) keys[2] = true; // A
  if (keyCode == 68) keys[3] = true; // D
  if (keyCode == 81) keys[4] = true; // Q
  if (keyCode == 69) keys[5] = true; // E 
  if (keyCode == 77) keys[6] = !keys[6]; // M

  if (keyCode == UP) keys[0] = true;
  if (keyCode == DOWN) keys[1] = true;
  if (keyCode == LEFT) keys[2] = true;
  if (keyCode == RIGHT) keys[3] = true;
  if (keyCode == CONTROL && !weirdMode) keys[7] = true;
  else if (keyCode == CONTROL && weirdMode) keys[7] = !keys[7];
}

void keyReleased() {
  if (keyCode == 87) keys[0] = false; // W
  if (keyCode == 83) keys[1] = false; // S
  if (keyCode == 65) keys[2] = false; // A
  if (keyCode == 68) keys[3] = false; // D
  if (keyCode == 81) keys[4] = false; // Q
  if (keyCode == 69) keys[5] = false; // E

  if (keyCode == UP) keys[0] = false;
  if (keyCode == DOWN) keys[1] = false;
  if (keyCode == LEFT) keys[2] = false;
  if (keyCode == RIGHT) keys[3] = false;
  if (keyCode == CONTROL && !weirdMode) keys[7] = false;
}
