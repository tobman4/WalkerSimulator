class Ray {
  
  PVector home,dir;
  boolean ID = false;
  
  private PVector end;
  private double lastUpdate = 0;
  private PVector hit = null;
  private float hitDist = 0;
  
  Ray(PVector home, PVector d) {
    this.home = home;
    this.dir = d;
    
    globalRays.add(this);
  }
  
  void render() {
    update();
    
    if(hit != null) {
      noStroke();
      ellipse(hit.x,hit.y,10,10);
        
      stroke(0,255,0);
      line(home.x,home.y,hit.x,hit.y);
        
      if(!onlyDrawToHit) {
        stroke(255,0,0);
        line(hit.x,hit.y,end.x,end.y);
      }
    } else if(!onlyDrawHit) {
      stroke(0,255,0);
      line(home.x,home.y,end.x,end.y);
    }
    
    if(ID) {
      stroke(255,0,255);
      line(home.x,home.y,end.x,end.y);
    }
    
  }
  
  void update() {
    if(lastUpdate != frameCount) {
      end = home.copy().add(dir);
      lastUpdate = frameCount;
    }
    
    hit = null;
    for(Wall w : walls) {
      PVector p = intersect(w);
      if(p != null) {
        float d = dist(home.x,home.y,p.x,p.y);
        if(d < hitDist || hit == null) {
          hit = p;
          hitDist = d;
        }
      }
    }
    
    if(DBG && hit != null) {
      noStroke();
      ellipse(hit.x,hit.y,10,10);
    }
  }
  
  float getDist() {
    update();
    if(hit == null) {
      return Float.POSITIVE_INFINITY;
    } else {
      return hitDist;
    }
  }
  
  boolean pointOnLine(PVector start, PVector end, PVector point) {
    int fullDist = (int)dist(start.x,start.y,end.x,end.y);
    int sTop = (int)dist(start.x,start.y,point.x,point.y);
    int eTop = (int)dist(end.x,end.y,point.x,point.y);
    
    return fullDist-1 <= sTop + eTop && fullDist+1 >= sTop + eTop;
  }
  
  PVector intersect(Wall wall) {
    int a1 = (int)end.y - (int)home.y;
    int b1 = (int)home.x - (int)end.x;
    int c1 = a1*((int)home.x) + b1*((int)home.y);
    
    int a2 = (int)wall.p2.y - (int)wall.p1.y;
    int b2 = (int)wall.p1.x - (int)wall.p2.x;
    int c2 = a2*((int)wall.p1.x)+ b2*((int)wall.p1.y);
    
    int determinant = a1*b2 - a2*b1;
    
    if(determinant != 0) {
      int x = (b2*c1 - b1*c2)/determinant;
      int y = (a1*c2 - a2*c1)/determinant;
      PVector p = new PVector(x, y);
      
      if(pointOnLine(home,end,p) && pointOnLine(wall.p1,wall.p2,p)) {
        return p;
      }
    }
    return null;
  }
}
