PShape figure;
float[][] u, v, nextU, nextV;
float feed = 0.0367;
float kill = 0.0649;
int cols, rows;
float theta;

void setup() {
  size(500, 500, P3D);
  
  cols = 1500; // ajusta según tus necesidades
  rows = 1500; // ajusta según tus necesidades
  
  u = new float[cols][rows];
  v = new float[cols][rows];
  nextU = new float[cols][rows];
  nextV = new float[cols][rows];
  

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      u[i][j] = random(0.8, 1.0);
      v[i][j] = random(0, 0.2);
    }
  }
  
  figure = createFigure();
}

void draw() {
  background(0);
  updateReactionDiffusion();
  render3DObject();
  theta += 0.01;
}

void updateReactionDiffusion() {
  float dt = 1.0;
  float F = 0.0367;
  float K = 0.0649;
  
  for (int i = 1; i < cols - 1; i++) {
    for (int j = 1; j < rows - 1; j++) {
      float laplaceU = u[i - 1][j] + u[i + 1][j] + u[i][j - 1] + u[i][j + 1] - 4 * u[i][j];
      float laplaceV = v[i - 1][j] + v[i + 1][j] + v[i][j - 1] + v[i][j + 1] - 4 * v[i][j];
      
      nextU[i][j] = u[i][j] + (laplaceU - u[i][j] * v[i][j] * v[i][j] + feed * (1 - u[i][j])) * dt;
      nextV[i][j] = v[i][j] + (laplaceV + u[i][j] * v[i][j] * v[i][j] - (kill + F) * v[i][j]) * dt;
      
      nextU[i][j] = constrain(nextU[i][j], 0, 1);
      nextV[i][j] = constrain(nextV[i][j], 0, 1);
    }
  }
  

  swapArrays();
}

void swapArrays() {
  float[][] temp = u;
  u = nextU;
  nextU = temp;
  
  temp = v;
  v = nextV;
  nextV = temp;
}

PShape createFigure() {
  PShape obj = loadShape("C:/codigos/visual/VCWorkbench/KoalaPlush_Obj_Quads/OBJ/daxhound.obj");
  PImage texture = createTexture();
  obj.setTexture(texture);
  return obj;
}

PImage createTexture() {
  PGraphics pg = createGraphics(cols, rows);
  pg.beginDraw();
  pg.loadPixels();
  
  // Map the reaction-diffusion values to grayscale colors
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int pix = i + j * cols;
      float grayscale = map(u[i][j] - v[i][j], -1, 1, 0, 255);
      pg.pixels[pix] = color(grayscale);
    }
  }
  
  pg.updatePixels();
  pg.endDraw();
  
  PImage texture = pg.get();
  return texture;
}

void render3DObject() {
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(theta);
  rotateY(theta / 2);
  scale(25);
  shape(figure);
  popMatrix();
}
