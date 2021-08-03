class Wall {
  PVector p1,p2;
  
  Wall(int x1, int y1, int x2, int y2) {
    p1 = new PVector(x1,y1);
    p2 = new PVector(x2,y2);
  }
  
  Wall(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  
  void render() {
    stroke(255);
    line(p1.x,p1.y,p2.x,p2.y);
  }
  
}

//############################
//##        Ghost line      ##
//############################
//# static class dont work w draw stuff?

PVector p1;

void mousePressed() {
  if(p1 == null) {
    p1 = new PVector(mouseX,mouseY);
  } else {
    walls.add(new Wall((int)p1.x,(int)p1.y,mouseX,mouseY));
    p1 = null;
  }
  
}
