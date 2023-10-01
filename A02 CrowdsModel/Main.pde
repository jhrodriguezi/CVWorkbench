import java.util.List;
import java.lang.Math;

PImage IMFish, IMRock, IMBackground, IMFishYellow, IMFishYB;
float angle;
FishShoal fishShoalBlue, fishShoalYellow, fishShoalYB;
List<Obstacle> obstacles;
Obstacle currentObstacle;
boolean holdingObstacle = false;

void setup() {
  fullScreen();
  noStroke();
  fill(102);
  
  obstacles = new ArrayList();
  
  IMFish = loadImage("assets/fish-blue.png");
  IMFish.resize(50, 0);
  
  IMFishYellow = loadImage("assets/fish-yellow.png");
  IMFishYellow.resize(50, 0);
  
  IMFishYB = loadImage("assets/fish-yb.png");
  IMFishYB.resize(50, 0);
  
  IMRock = loadImage("assets/rock.png");
  
  IMBackground = loadImage("assets/background.jpg");
  IMBackground.resize(width, height);

  fishShoalBlue = new FishShoal(IMFish);
  fishShoalYellow = new FishShoal(IMFishYellow);
  fishShoalYB = new FishShoal(IMFishYB);
  
  for(int i = 0; i < 50; i++){
    angle = random(2 * PI);
    fishShoalBlue.addFish(new Fish(new PVector(random(width), random(height)),
              new PVector(cos(angle), sin(angle)),
              new PVector(0, 0)));
              
    fishShoalYellow.addFish(new Fish(new PVector(random(width), random(height)),
              new PVector(cos(angle), sin(angle)),
              new PVector(0, 0)));
              
    fishShoalYB.addFish(new Fish(new PVector(random(width), random(height)),
              new PVector(cos(angle), sin(angle)),
              new PVector(0, 0)));
  }
}

void draw() {
  background(IMBackground);
  
  fishShoalBlue.run(obstacles);
  fishShoalYellow.run(obstacles);
  fishShoalYB.run(obstacles);
  
  for(Obstacle o : obstacles){
    o.draw();
  }
  
  if(holdingObstacle) {
    currentObstacle.setPosition(new PVector(mouseX, mouseY));
    currentObstacle.draw();
  }
}

void keyPressed() {
  if (key == '1') {
    currentObstacle = new Obstacle(new PVector(mouseX, mouseY), IMRock);
    holdingObstacle = true;
  }
}

void mousePressed() {
  if(holdingObstacle) {
    obstacles.add(currentObstacle);
    holdingObstacle = false;
  }
}
