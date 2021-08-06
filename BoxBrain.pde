enum Mode {
  Find,
  GetClose,
  ThinkHard,
  GetAway,
}

class BoxBrain extends Brain {
  
  Mode m = Mode.Find;
  
  float turnChanse = 0.35;
  float closestDist = 20;
  int minTurnDeley = 1500;

  float fastSpeed = 1.0;
  float medSpeed = 0.5;
  float slowSpeed = 0.2;
  
  int escapeTime = 5000;
  
  
  int thinkSpeed = 1500;
  String[] thoughts = {
    "", // i am lazy
    "Wtf is this?",
    "Why is it a rock here?",
    "HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",
    "Cool... ok bye"
  };
  
  private int runStart = 0;
  private int thinkIndex = 0;
  private double lastThink = 0;
  private double lastTurn = 0;
  
  BoxBrain(Robot h) {
    super(h);
  }
  
  void update() {
    
    if(host.isTurning()) {
      return;
    }
    
    switch(m) {
      case Find:
        walkStep();
        break;
      case GetClose: 
        getCloseStep();
        break;
      case ThinkHard:
        thinkStep();
        break;
      case GetAway:
        getAwayStep();
        break;
    }
  }
  
  void getAwayStep() {
    if(runStart == 0) {
      runStart = millis();
    } else if(millis() - runStart > escapeTime) {
      m = Mode.Find;
      runStart = 0;
      return;
    }
    
    
    host.speed = fastSpeed;
    if(host.rays[0].getDist() < 15) {
      if(random(1) > .5) {
        host.fancyTurn(-45);
      } else {
        host.fancyTurn(45);
      }
    }
  }
  
  void getCloseStep() {
    if(host.rays[0].getDist() <= closestDist) {
      host.speed = 0;
      m = Mode.ThinkHard;
    } else {
      host.speed = slowSpeed;
    }
  }
  
  void thinkStep() { //<>//
    if(thinkIndex >= thoughts.length) {
      m = Mode.GetAway;
      thinkIndex = 0;
      host.fancyTurn(180);
      return;
    }
    
    text(thoughts[thinkIndex],host.pos.x-25,host.pos.y);
    
    if(millis() - lastThink >thinkSpeed) {
      thinkIndex++;
      lastThink = millis();
    }
  }
  
  void walkStep() {
    
    // look for a object
    int objStart = -1;
    int objEnd = -1;
    
    for(int i = 0; i < host.rays.length; i++) {
      float len = host.rays[i].getDist();
      if(len < Float.POSITIVE_INFINITY && objStart == -1) {
        objStart = i;
        host.rays[i].ID = true;
      } else if(objStart != -1 && objEnd == -1 && len >= Float.POSITIVE_INFINITY) {
        objEnd = i;
        if(objEnd - objStart > 5) {
          //go to
          host.speed = 0;
          host.fancyTurn((objEnd+objStart)/2);
          m = Mode.GetClose;
          return;
        }
      }
    }
    
    // Random walk
    host.speed = fastSpeed;
    if(millis()-lastTurn > minTurnDeley && random(1) > turnChanse) {
      int toTurn = round((random(1)*90)-45);
      host.fancyTurn(toTurn);
      lastTurn = millis();
    }
    
  }
}
