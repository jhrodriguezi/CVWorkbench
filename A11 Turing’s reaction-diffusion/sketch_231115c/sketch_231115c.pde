PShape figure;
float[][] u, v, nextU, nextV;
float feed = 0.055;
float kill = 0.062;
float du = 1.0;
float dv = 0.5;
float dt = 1.0;
int cols, rows;
float theta;

void setup() {
  size(500, 500, P3D);
  
  pixelDensity(1);
  
  cols = 1000; // ajusta según tus necesidades
  rows = 1000; // ajusta según tus necesidades
  
  u = new float[cols][rows];
  v = new float[cols][rows];
  nextU = new float[cols][rows];
  nextV = new float[cols][rows];
  

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      u[i][j] = 1;
      v[i][j] = 0;
      nextU[i][j] = 1;
      nextV[i][j] = 0;
    }
  }

  for (int i = 500; i < 600; i++) {
    for (int j = 500; j < 550; j++) {
      v[i][j] = 1;
    }
  }
  
  for (int i = 510; i < 590; i++) {
    for (int j = 510; j < 590; j++) {
      v[i][j] = 0;
    }
  }
  
  figure = createFigure();
}

void draw() {
  background(51);
  updateReactionDiffusion();
  PImage newTexture = createTexture();
  figure.setTexture(newTexture);
  render3DObject();
  theta += 0.01;
  dt += 0.01;
}

void updateReactionDiffusion() {
  
  for (int i = 1; i < cols - 1; i++) {
    for (int j = 1; j < rows - 1; j++) {
      var cu = u[i][j];
      var cv = v[i][j];
      
      float lapU = laplaceU(i,j);
      float lapV = laplaceV(i,j);
      
      nextU[i][j] = cu + (du*lapU*lapU*cu - cu * cv * cv + feed * (1 - cu))*dt;
      nextV[i][j] = cv + (dv*lapV*lapV*cv + cu * cv * cv - (kill + feed) * cv)*dt;
      //nextU[i][j] = constrain(nextU[i][j], 0, 1);
      //nextV[i][j] = constrain(nextV[i][j], 0, 1);
    }
  }
  
  for (int i = 110; i < 250; i++) {
    for (int j = 110; j < 250; j++) {
      v[i][j] = 1;
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
  PShape obj = loadShape("daxhound.obj");
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
      float uValue = (Float.isNaN(u[i][j])) ? 0 : u[i][j];
      float vValue = (Float.isNaN(v[i][j])) ? 0 : v[i][j];
      float constrainedU = constrain(uValue, -10, 10);
      float constrainedV = constrain(vValue, -10, 10);
      float grayscale = map(constrainedU-constrainedV, -10, 10, 0, 255);
      if (grayscale < 255.0 && grayscale != 140.25 && grayscale != 127.5) {
        System.out.println(grayscale);
      }
      pg.pixels[pix] = color(grayscale);
    }
  }
  
  pg.updatePixels();
  pg.endDraw();
  
  PImage texture = pg.get();
  return texture;
}

public float laplaceU(int x,int y) {
  float sumU = 0;
  sumU += u[x][y]*-1;
  sumU += u[x-1][y]*0.2;
  sumU += u[x+1][y]*0.2;
  sumU += u[x][y-1]*0.2;
  sumU += u[x][y+1]*0.2;
  sumU += u[x-1][y-1]*0.05;
  sumU += u[x+1][y-1]*0.05;
  sumU += u[x-1][y+1]*0.05;
  sumU += u[x+1][y+1]*0.05;
  return sumU;
}

public float laplaceV(int x,int y) {
  float sumV = 0;
  sumV += v[x][y]*-1;
  sumV += v[x-1][y]*0.2;
  sumV += v[x+1][y]*0.2;
  sumV += v[x][y-1]*0.2;
  sumV += v[x][y+1]*0.2;
  sumV += v[x-1][y-1]*0.05;
  sumV += v[x+1][y-1]*0.05;
  sumV += v[x-1][y+1]*0.05;
  sumV += v[x+1][y+1]*0.05;
  return sumV;
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
