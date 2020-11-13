class Player
{
  PVector pos; 
  PVector dir;
  PVector cameraPlane;
  float rayNumber;
  Ray[] rays; 
  float size;
  float playerSpeed;
  int waitLoop;
  int waitTime;
  boolean finished;
  PFont font;
  boolean cheated;
  int textType;

  Player(float size, float x, float y, float rayNumber, float playerSpeed, boolean lowMode, int fps) 
  {
    this.pos = new PVector(x, y, 0);
    this.rayNumber = rayNumber;
    this.rays = new Ray[int(this.rayNumber)];
    if (lowMode) this.rays = new Ray[int(this.rayNumber) / 4];
    this.size = size;
    this.playerSpeed = playerSpeed;
    this.dir = new PVector(1, 0);
    this.cameraPlane = new PVector(0, 1);
    this.waitTime = fps * 3;
    this.waitLoop = 0;
    this.finished = false;
    this.font = createFont("font.ttf", 64);
    this.cheated = false;
    this.textType = int(random(0, 7));

    for (int i = 0; i < rays.length; i++)
    {
      this.rays[i] = new Ray(this.pos);
    }
  }

  void checkFinished(boolean keys[]) {
    if (keys[6]) cheated = true;
    if (!finished) finished = checkFinish(map);
    if (finished) {
      if (waitLoop < waitTime) { 
        textAlign(CENTER);
        textFont(font);
        textSize(height / 12);
        fill(200);

        if (!cheated) {
          switch (textType) {        
            case(0):
            text("GG", width/2, height/2);
            break;

            case(1):
            text("High IQ", width/2, height/2);
            break;

            case(2):
            text("Strong", width/2, height/2);
            break;

            case(3):
            text("Best player", width/2, height/2);
            break;

            case(4):
            text("Solve Master", width/2, height/2);
            break;

            case(5):
            text("Not too hard huh?", width/2, height/2);
            break;

            case(6):
            text("Was it fun?", width/2, height/2);
            break;

          default:
            text("Found it", width/2, height/2);
            break;
          }
        }
        else text("Cheater, pff", width/2, height/2);
        waitLoop++;
      } else { 
        textType = int(random(0, 7));
        waitLoop = 0;
        finished = false;
        cheated = false;
        map.resetMap(this, keys);
      }
    }
  }

  void movement(boolean[] keys, Map map) {
    controller(keys);
    collision(map);
  }

  void update(float x, float y)
  {
    this.pos.x = this.pos.x + x;
    this.pos.y = this.pos.y + y;
  }

  void rotateView(float amount)
  {
    this.dir.rotate(degrees(amount));
    this.cameraPlane.rotate(degrees(amount));
  }

  boolean checkFinish(Map map) {
    if (map.squares[int(player.pos.x)][int(player.pos.y)].type == 23) return true;
    else return false;
  }

  void collision(Map map)
  {
    Square square1 = map.squares[int(pos.x) + 1][int(pos.y)]; //Zelle Rechts
    Square square2 = map.squares[int(pos.x)][int(pos.y) + 1]; //Zelle Unten
    Square square3 = map.squares[int(int(pos.x) - 0.1)][int(pos.y)]; //Zelle Links 
    Square square4 = map.squares[int(pos.x)][int(int(pos.y) - 0.1)]; //Zelle Oben

    Square square5 = map.squares[int(pos.x) + 1][int(int(pos.y) - 0.1)]; //Zelle Oben-Rechts
    Square square6 = map.squares[int(pos.x) + 1][int(pos.y) + 1]; //Zelle Unten-Rechts
    Square square7 = map.squares[int(int(pos.x) - 0.1)][int(pos.y) + 1]; //Zelle Unten-Links
    Square square8 = map.squares[int(int(pos.x) - 0.1)][int(int(pos.y) - 0.1)]; //Zelle Oben-Links

    if (square1.type != 0 && square1.type != 22 && square1.type != 23 && player.pos.x + size > int(pos.x) + 1) player.pos.x = int(pos.x) + 1 - size; //Kollision Rechts
    if (square2.type != 0 && square2.type != 22 && square2.type != 23 && player.pos.y + size > int(pos.y) + 1) player.pos.y = int(pos.y) + 1 - size; //Kollision Unten
    if (square3.type != 0 && square3.type != 22 && square3.type != 23 && player.pos.x - size < int(pos.x)) player.pos.x = int(pos.x) + size; //Kollision Links
    if (square4.type != 0 && square4.type != 22 && square4.type != 23 && player.pos.y - size < int(pos.y)) player.pos.y = int(pos.y) + size; //Kollision Oben

    if (square5.type != 0 && square5.type != 22 && square5.type != 23 && (player.pos.x + size > int(pos.x) + 1 || player.pos.y - size < int(pos.y)))
    {
      PVector dis = new PVector((int(pos.x) + 1) - pos.x, int(pos.y) - pos.y); //Distanz zur Ober Rechten Ecke
      if (dis.mag() < size)
      {
        PVector disInner = dis.copy(); //Kopie von der Distanz
        disInner.setMag(size - dis.mag()); //Distanz von der Ecke zum Rand des kreies (Spieler) ausgehend vom diesem Eckpunkt
        update(-disInner.x, -disInner.y); //Wenn es eine Kollision gibt, den spieler um so viel verschieben, wie er in der Wand steckt
      }
    }

    if (square6.type != 0 && square6.type != 22 && square6.type != 23  && (player.pos.x + size > int(pos.x) + 1 || player.pos.y + size > int(pos.y) + 1))
    {
      PVector dis = new PVector((int(pos.x) + 1) - pos.x, (int(pos.y) + 1) - pos.y); //Distanz zur Unter Rechten Ecke
      if (dis.mag() < size)
      {
        PVector disInner = dis.copy(); //Kopie von der Distanz
        disInner.setMag(size - dis.mag()); //Distanz von der Ecke zum Rand des kreies (Spieler) ausgehend vom diesem Eckpunkt        
        update(-disInner.x, -disInner.y); //Wenn es eine Kollision gibt, den spieler um so viel verschieben, wie er in der Wand steckt
      }
    }

    if (square7.type != 0 && square7.type != 22 && square7.type != 23  && (player.pos.x - size < int(pos.x) || player.pos.y + size > int(pos.y) + 1))
    {
      PVector dis = new PVector(int(pos.x) - pos.x, (int(pos.y) + 1) - pos.y); //Distanz zur Unter Linken Ecke
      if (dis.mag() < size)
      {
        PVector disInner = dis.copy(); //Kopie von der Distanz
        disInner.setMag(size - dis.mag()); //Distanz von der Ecke zum Rand des kreies (Spieler) ausgehend vom diesem Eckpunkt
        update(-disInner.x, -disInner.y); //Wenn es eine Kollision gibt, den spieler um so viel verschieben, wie er in der Wand steckt
      }
    }

    if (square8.type != 0 && square8.type != 22 && square8.type != 23  && (player.pos.x - size < int(pos.x) || player.pos.y - size < int(pos.y)))
    {
      PVector dis = new PVector(int(pos.x) - pos.x, int(pos.y) - pos.y); //Distanz zur Ober Linken Ecke
      if (dis.mag() < size)
      {
        PVector disInner = dis.copy(); //Kopie von der Distanz
        disInner.setMag(size - dis.mag()); //Distanz von der Ecke zum Rand des kreies (Spieler) ausgehend vom diesem Eckpunkt
        update(-disInner.x, -disInner.y); //Wenn es eine Kollision gibt, den spieler um so viel verschieben, wie er in der Wand steckt
      }
    }
  }

  void controller(boolean[] keys) 
  {
    PVector movementDir = dir.copy();
    movementDir.setMag(playerSpeed);
    PVector movementDirDiag = movementDir.copy();
    movementDirDiag.rotate(radians(-45));

    if (keys[0] && !keys[1] && !keys[4] && !keys[5]) player.update(movementDir.x, movementDir.y); //Oben
    if (keys[1] && !keys[0] && !keys[4] && !keys[5]) player.update(-movementDir.x, -movementDir.y); //Unten
    if (keys[4] && !keys[1] && !keys[0] && !keys[5]) player.update(movementDir.y, -movementDir.x); //Links
    if (keys[5] && !keys[1] && !keys[4] && !keys[0]) player.update(-movementDir.y, movementDir.x); //Rechts

    if (keys[0] && keys[5] && !keys[1] && !keys[4]) player.update(-movementDirDiag.y, movementDirDiag.x); //Oben-Rechts
    if (keys[1] && keys[5] && !keys[0] && !keys[4]) player.update(-movementDirDiag.x, -movementDirDiag.y); //Unten-Rechts
    if (keys[1] && keys[4] && !keys[0] && !keys[5]) player.update(movementDirDiag.y, -movementDirDiag.x); //Unten-Links
    if (keys[4] && keys[0] && !keys[1] && !keys[5]) player.update(movementDirDiag.x, movementDirDiag.y); //Oben-Links

    if (keys[0] && keys[4] && keys[5] && !keys[1]) player.update(movementDir.x, movementDir.y); //Oben-Sonderfall
    if (keys[1] && keys[4] && keys[5] && !keys[0]) player.update(-movementDir.x, -movementDir.y); //Unten-Sonderfall
    if (keys[4] && keys[1] && keys[0] && !keys[5]) player.update(movementDir.y, -movementDir.x); //Links-Sonderfall
    if (keys[5] && keys[1] && keys[0] && !keys[4]) player.update(-movementDir.y, movementDir.x); //Rechts-Sonderfall

    if (keys[2] && ! keys[3]) player.rotateView(-0.001);
    if (keys[3] && ! keys[2]) player.rotateView(0.001);

    if (!keys[7]) player.pos.z = width / 11;
    else if (keys[7]) player.pos.z = -height / 10;
  }
  
  PVector tilePos() 
  {
    PVector tilePos = new PVector((pos.x - int(pos.x)), (pos.y - int(pos.y)));
    return tilePos;
  }
}
