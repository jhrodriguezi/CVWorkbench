class Obstacle {
  PVector position;
  PImage content;
  float reactionDistance;
  
  Obstacle(PVector p, PImage c) {
    c = c.copy();
    float r = random(50, c.width);
    c.resize(int(r), 0);
    this.position = p;
    this.content = c;
    this.reactionDistance = ((float) Math.sqrt(c.width * c.width / 4 + c.height * c.height / 4)) * 1.1;
  }
  
  void draw() {
    image(content, position.x, position.y);
  }
  
  void setPosition(PVector p) {
    this.position = p;
  }
}
