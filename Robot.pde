class Robot {
  
  final int size = 10;
  final int rayDensity = 1;
  final int rayLength = 100;
  
  PVector pos;
  
  Brain brain;
  
  int speed = 1;
  int rot = 0;
  
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
  
  void update() {
    
    /*
      Copy _rays into rays so that the index math the angle
      
      0deg = front
      
      good doc :)
      
    */
    arrayCopy(_rays,rot,rays,0,rays.length-rot);
    arrayCopy(_rays,0,rays,rays.length-rot,rot);
    
    brain.update();
    
    rays[0].ID = true;
    rays[90].ID = true;
    rays[180].ID = true;
    rays[270].ID = true;
    
    PVector toAdd = new PVector(0,-speed).rotate(radians(rot));
    pos.add(toAdd);
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
}
