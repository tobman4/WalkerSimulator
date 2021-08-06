class Robot {
  
  final int size = 10;
  final int rayDensity = 1;
  final int rayLength = 100;
  final int turnSpeed = 1;
  
  PVector pos;
  
  Brain brain;
  
  float speed = 1;
  
  int rot = 0;
  
  private int turnTime = 0;
  private int turnDir = 1;
  
  Ray[] _rays;
  Ray[] rays;
  
  Robot(int x, int y) {
    pos = new PVector(x,y);
    
    _rays = new Ray[floor(360/rayDensity)];
    rays = new Ray[_rays.length];
    PVector ogDir = new PVector(0,-rayLength);
    for(int i = 0; i < _rays.length; i++) {
      PVector dir = ogDir.copy().rotate(radians(rayDensity*i));
      _rays[i] = new Ray(pos,dir);
    }
    brain = new BoxBrain(this);
  }
  
  void update() {
    
    /*
      Copy _rays into rays so that the index math the angle
      
      0deg = front
      
      good doc :)
      
    */
    arrayCopy(_rays,rot,rays,0,rays.length-rot);
    arrayCopy(_rays,0,rays,rays.length-rot,rot);
    
    if(brain != null) {
      brain.update();
    }
    
    rays[0].ID = true;
    rays[90].ID = true;
    rays[180].ID = true;
    rays[270].ID = true;
    
    if(turnTime > 0) {
      turn(turnDir);
      turnTime--;
    } else {
      PVector toAdd = new PVector(0,-speed).rotate(radians(rot));
      pos.add(toAdd);
    }
  }
  
  void render() {
    push();
    translate(pos.x,pos.y);
    rotate(radians(rot));
    fill(255);
    noStroke();
    triangle(
      0,-size,
      -size,size,
      size,size);
    pop();
  }
  
  boolean isTurning() {
    return turnTime > 0;
  }
  
  void fancyTurn(int dir) {
    turnTime = abs(dir)/turnSpeed;
    if(dir < 0) {
      turnDir = -turnSpeed;
    } else if(dir > 0) {
      turnDir = turnSpeed;
    } else {
      turnTime = 0;
    }
    //print("Turn " + turnDir + " for " + turnTime);
  }
  
  void turn(int dir) {
    rot += dir;
    
    while(rot < 0 || rot > 360) {
      if(rot < 0) {
        rot += 360;
      } else if(rot > 360) {
        rot -= 360;
      }
    }
    
  }
}
