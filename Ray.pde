class Ray 
{
  PVector pos, dir;
  float tangent90, tangent180, tangent270, tangent360;

  Ray(PVector pos1) 
  {
    this.pos = pos1;
  }

  wallContainer cast(PVector tpos, PVector ppos, Map map, float angle) 
  {
    if (angle <= 0) angle = 360 + angle;
    if (angle >= 360) angle = angle - 360;

    this.tangent90 = tan(radians(angle));
    this.tangent180 = tan(radians(abs(180 - angle)));
    this.tangent270 = tan(radians(abs(270 - angle)));
    this.tangent360 = tan(radians(abs(360 - angle)));

    if (angle >= 0 && angle < 90 || angle == 360)
    {
      float dy = tpos.y;
      float tanDy = dy / tangent90;
      PVector intersectY1 = new PVector(ppos.x + tanDy, ppos.y - dy);
      float deltaY = 1/ tangent90;

      float dx = 1 - tpos.x;
      float tanDx = -dx * tangent90;
      PVector intersectX1 = new PVector(ppos.x + dx, ppos.y + tanDx);
      float deltaX = -tangent90;

      for (;; ) 
      {
        while (intersectY1.x <= intersectX1.x || intersectY1.y >= intersectX1.y) 
        {           
          Square square1 = map.squares[int(intersectY1.x)][int(intersectY1.y - 0.1)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23 && square1.type != 22 && square1.type != 23) {
            PVector pt = new PVector(intersectY1.x, intersectY1.y);
            return new wallContainer(pt, map.squares[int(intersectY1.x)][int(intersectY1.y - 0.1)].type, pt.x - int(pt.x));
          }
          intersectY1.y -= 1;
          intersectY1.x += deltaY;
        }
        while (intersectX1.x <= intersectY1.x || intersectX1.y >= intersectY1.y ) 
        {
          Square square1 = map.squares[int(intersectX1.x + 0.1)][int(intersectX1.y)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23) {
            PVector pt = new PVector(intersectX1.x, intersectX1.y);
            return new wallContainer(pt, map.squares[int(intersectX1.x + 0.1)][int(intersectX1.y)].type, pt.y - int(pt.y));
          }
          intersectX1.x += 1;
          intersectX1.y += deltaX;
        }
      }
    } else if (angle >= 90 && angle <= 180) 
    {
      float dy = tpos.y;
      float tanDy = -dy / tangent180;
      PVector intersectY1 = new PVector(ppos.x + tanDy, ppos.y - dy);
      float deltaY = -1 / tangent180;

      float dx = tpos.x;
      float tanDx = -dx * tangent180;
      PVector intersectX1 = new PVector(ppos.x - dx, ppos.y + tanDx);
      float deltaX = -tangent180;

      for (;; )
      {
        while (intersectY1.x >= intersectX1.x || intersectY1.y >= intersectX1.y) 
        {           
          Square square1 = map.squares[int(intersectY1.x)][int(intersectY1.y - 0.1)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23) {
            PVector pt = new PVector(intersectY1.x, intersectY1.y);
            return new wallContainer(pt, map.squares[int(intersectY1.x)][int(intersectY1.y - 0.1)].type, pt.x - int(pt.x));
          }
          intersectY1.y -= 1;
          intersectY1.x += deltaY;
        }
        while (intersectX1.x >= intersectY1.x || intersectX1.y >= intersectY1.y ) 
        {
          Square square1 = map.squares[int(intersectX1.x - 0.1)][int(intersectX1.y)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23) {
            PVector pt = new PVector(intersectX1.x, intersectX1.y);
            return new wallContainer(pt, map.squares[int(intersectX1.x - 0.1)][int(intersectX1.y)].type, pt.y - int(pt.y));
          }
          intersectX1.x -= 1;
          intersectX1.y += deltaX;
        }
      }
    } else if (angle > 180 && angle < 270) 
    {
      float dy = 1 - tpos.y;
      float tanDy =  -dy * tangent270;
      PVector intersectY1 = new PVector(ppos.x + tanDy, ppos.y + dy);
      float deltaY = -1 * tangent270;

      float dx = tpos.x;
      float tanDx = dx / tangent270;
      PVector intersectX1 = new PVector(ppos.x - dx, ppos.y + tanDx);
      float deltaX = 1 / tangent270;

      for (;; )
      {
        while (intersectY1.x >= intersectX1.x || intersectY1.y <= intersectX1.y) 
        {           
          Square square1 = map.squares[int(intersectY1.x)][int(intersectY1.y + 0.1)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23) 
          {
            PVector pt = new PVector(intersectY1.x, intersectY1.y);
            return new wallContainer(pt, map.squares[int(intersectY1.x)][int(intersectY1.y + 0.1)].type, pt.x - int(pt.x));
          }
          intersectY1.y += 1;
          intersectY1.x += deltaY;
        }
        while (intersectX1.x >= intersectY1.x || intersectX1.y <= intersectY1.y )
        {
          Square square1 = map.squares[int(intersectX1.x - 0.1)][int(intersectX1.y)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23)
          {
            PVector pt = new PVector(intersectX1.x, intersectX1.y);
            return new wallContainer(pt, map.squares[int(intersectX1.x - 0.1)][int(intersectX1.y)].type, pt.y - int(pt.y));
          }
          intersectX1.x -= 1;
          intersectX1.y += deltaX;
        }
      }
    } else if (angle >= 270 && angle < 360) 
    {
      float dy = 1 - tpos.y;
      float tanDy = dy / tangent360;
      PVector intersectY1 = new PVector(ppos.x + tanDy, ppos.y + dy);
      float deltaY = 1/tangent360;

      float dx = 1 - tpos.x;
      float tanDx = dx * tangent360;
      PVector intersectX1 = new PVector(ppos.x + dx, ppos.y + tanDx);
      float deltaX = tangent360;

      for (;; ) {
        while (intersectY1.x <= intersectX1.x || intersectY1.y <= intersectX1.y)
        {           
          Square square1 = map.squares[int(intersectY1.x)][int(intersectY1.y + 0.1)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23)
          {
            PVector pt = new PVector(intersectY1.x, intersectY1.y);
            return new wallContainer(pt, map.squares[int(intersectY1.x)][int(intersectY1.y + 0.1)].type, pt.x - int(pt.x));
          }
          intersectY1.y += 1;
          intersectY1.x += deltaY;
        }
        while (intersectX1.x <= intersectY1.x || intersectX1.y <= intersectY1.y )
        {
          Square square1 = map.squares[int(intersectX1.x + 0.1)][int(intersectX1.y)];
          if (square1.type != 0 && square1.type != 22 && square1.type != 23) 
          {
            PVector pt = new PVector(intersectX1.x, intersectX1.y);
            return new wallContainer(pt, map.squares[int(intersectX1.x + 0.1)][int(intersectX1.y)].type, pt.y - int(pt.y));
          }
          intersectX1.x += 1;
          intersectX1.y += deltaX;
        }
      }
    }
    return new wallContainer(null, 0, 0);
  }
}
