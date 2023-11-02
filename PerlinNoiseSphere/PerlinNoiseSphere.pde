import peasy.*;

PeasyCam cam;

PVector[][] sphereTerrain;
int totalPoints = 100;
int globalLimit = 8;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 100);
  
  sphereTerrain = new PVector[totalPoints+1][totalPoints+1];
}

void draw() {
  background(0);
  fill(0);
  lights();
  float radius = 200;
  float yoff = 0.0;
  for (int i = 0; i < totalPoints+1; i++) {
    float latitude = map(i, 0, totalPoints, -HALF_PI, HALF_PI);
    float xoff = 0.0;
    for (int j = 0; j < totalPoints+1; j++) {
      float longitude = map(j, 0, totalPoints, -PI, PI);
      float x = radius * sin(longitude) * cos(latitude);
      float y = radius * sin(longitude) * sin(latitude);
      float z = radius * cos(longitude);
      sphereTerrain[i][j] = new PVector(x, y, z);
      PVector noiseVector = getNoise(xoff, yoff, 35);
      sphereTerrain[i][j].add(noiseVector);
      xoff++;
    }
    yoff++;
  }
  
  for (int i = 0; i < totalPoints; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < totalPoints+1; j++) {
      PVector v1 = sphereTerrain[i][j];
      stroke(200);
      strokeWeight(2);
      vertex(v1.x,v1.y,v1.z);
      PVector v2 = sphereTerrain[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
  
}
PVector getNoise(float xoff, float yoff, int limit) {
  float xNoise = map(noise(xoff, yoff), 0, 1, 0, limit);
  float yNoise = map(noise(xoff , yoff ), 0, 1, 0, limit);
  float zNoise = map(noise(xoff + 2000, yoff + 2000), 0, 1, 0, limit);
  return new PVector(xNoise, yNoise, zNoise);
}
