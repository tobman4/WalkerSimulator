import java.nio.ByteBuffer;

Wall[] savedWalls;
ArrayList<Wall> walls = new ArrayList<Wall>();
ArrayList<Ray> globalRays = new ArrayList<Ray>();

PVector mouse = new PVector(0,0);

boolean DBG = false;
boolean onlyDrawToHit = true;
boolean onlyDrawHit = true;
boolean pause = false;

Robot bot;

int[] loadConfig(String path) {
  path = ((path == "") ? "conf.json" : path);
  try {
    
    JSONObject json = loadJSONObject(path);
    String[] worldFiles = json.getJSONArray("WorldFiles").getStringArray();
    
    for(String world : worldFiles) {
      println("Loading: " + world);
      loadWorld(world);
    }
    
    return new int[] { 
      (json.getBoolean("Fullscreen",false)) ? 1 : 0,
      json.getInt("Width",600),
      json.getInt("Height",600)
    };
  } catch(Exception e) {
    println("Error on config load");
    return new int[] { 0,600,600 };
  }
}

void settings() {
  int[] winInfo = loadConfig("conf.json");
  if(winInfo[0] == 1) {
    fullScreen();
  } else {
    size(winInfo[1],winInfo[2]);
  }
}

void setup() {
  surface.setTitle("Setup");
  //size(600,600);
  //fullScreen();
  bot = new Robot(width/2,height/2);
  
  textSize(25);
  
  savedWalls = new Wall[walls.size()];
  savedWalls = walls.toArray(savedWalls);
  
  restWalls();
  surface.setTitle("Walker");
}

void draw() {
  double start = millis();
  background(0);
  mouse.x = mouseX;
  mouse.y = mouseY;
  
  if(!pause) {
    bot.update();
    if(bot.pos.x > width) {
      bot.pos.x = 0;
    }
    if(bot.pos.x < 0) {
      bot.pos.x = width;
    }
    if(bot.pos.y > height) {
      bot.pos.y = 0;
    }
    if(bot.pos.y < 0) {
      bot.pos.y = height;
    }
  }
  
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

void loadWorld(String worldFile) {
  if(worldFile.endsWith(".WW")) {
    ByteBuffer bytes = ByteBuffer.wrap(loadBytes(worldFile));
    
    while(bytes.remaining() >= 4) {
      int x1 = bytes.getInt();
      int y1 = bytes.getInt();
      
      int x2 = bytes.getInt();
      int y2 = bytes.getInt();
      
      walls.add(new Wall(x1,y1,x2,y2));
    }
  }
}

void restWalls() {
  walls.clear();
  
  for(Wall w : savedWalls) {
    walls.add(w);
  }
  /*
  walls.add(new Wall(0,0,width-1,0));
  walls.add(new Wall(0,height-1,width-1,height-1));
  
  walls.add(new Wall(0,0,0,height-1));
  walls.add(new Wall(width-1,0,width-1,height-1));
  */
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
   
   case 32: // {SPACE}
     pause = !pause;
     break;
     
   case 80: // P
     for(Wall w : walls) {
       println(String.format("(%s,%s,%s,%s)",w.p1.x,w.p1.y,w.p2.x,w.p2.y));
     }
     break;
    
    default:
      println("KeyCode = " + keyCode);
      break;
  }
}
