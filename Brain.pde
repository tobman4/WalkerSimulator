abstract class Brain {
  Robot host;
  
  Brain(Robot h) {
    host = h;
  }
  
  abstract void update();
}
