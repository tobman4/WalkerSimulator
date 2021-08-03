ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Ray> globalRays = new ArrayList<Ray>();

PVector mouse = new PVector(0,0);

boolean DBG = false;
boolean onlyDrawToHit = true;
boolean onlyDrawHit = true;

Robot bot;

void setup() {
  size(600,600);
  //fullScreen();
  
  /*
  PVector ogDir = new PVector(0,-600);
  for(int i = 0; i < 360; i++) {
    PVector d = ogDir.copy().rotate(radians(i));
    Ray r = new Ray(mouse,d);
    globalRays.add(r);
  }
  */
  
  bot = new Robot(width/2,height/2);
  bot.turn(90);
  
  textSize(25);
  restWalls();
}

void draw() {
  double start = millis();
  background(0);
  mouse.x = mouseX;
  mouse.y = mouseY;
  
  
  bot.update();
  
  for(Wall w : walls) {
    w.render();
  }
    for(Ray r : globalRays) {
      r.render();
      r.ID = false;
    }
  
  if(p1 != null) {
    stroke(255,0,255);
    line(p1.x,p1.y,mouseX,mouseY);
  }
  
  bot.render();
  /*
  if(frameCount%2 == 0) {
    bot.rot += 1;
    if(bot.rot >= 360) {
      bot.rot -= 360;
    }
  }
  */
  
  text("Only draw (h)it: " + onlyDrawHit, 0,25);
  text("Only draw (t)o hit: " + onlyDrawToHit, 0,50);
  text("Mouse to place wall", 0,75);
  text("(D)BG: " + DBG, 0,100);
  text("Esc to exit", 0,125);
  
  text("Front dist: " + bot.rays[0].getDist(), 0,height-50);
  text("Step time: " + (millis()-start) + "ms", 0,height-25); 
}

void restWalls() {
  walls.clear();
  walls.add(new Wall(0,0,width-1,0));
  walls.add(new Wall(0,height-1,width-1,height-1));
  
  walls.add(new Wall(0,0,0,height-1));
  walls.add(new Wall(width-1,0,width-1,height-1));
}

void keyPressed() {
  switch(keyCode) {
    
    case 82: // R
      restWalls();
      break;
    case 72: // H
      onlyDrawHit = !onlyDrawHit;
      break;
    case 84: // T
      onlyDrawToHit = !onlyDrawToHit;
      break;
   case 68: // D
     DBG = !DBG;
     break;
    
    default:
      println("KeyCode = " + keyCode);
      break;
  }
}
