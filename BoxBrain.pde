class BoxBrain extends Brain {

  BoxBrain(Robot h) {
    super(h);
  }
  
  void update() {
    if(host.rays[0].getDist() < host.rayLength) {
      host.turn(90);
    }
  }
}
