PShader gouraudShader;
PShader phongShader;
PVector lightDir; 

void setup() {
  size(400, 400, P3D);
  gouraudShader = loadShader("gouraudfrag.glsl", "gouraudvert.glsl");
  phongShader = loadShader("phongfrag.glsl", "phongvert.glsl");

  lightDir = new PVector(0.5, -1, 0); 
}

void draw() {
  background(240);
  translate(width / 2, height / 2);

  PVector lightInView = new PVector(lightDir.x, lightDir.y, lightDir.z);
  lightInView.normalize();

  shader(gouraudShader); 

  pushMatrix();
  translate(-100, 0, 0);
  directionalLight(255, 255, 255, lightInView.x, lightInView.y, lightInView.z);
  sphere(60);
  popMatrix();



  shader(phongShader); 


pushMatrix();
translate(100, 0, 0); 
directionalLight(255, 255, 255, lightInView.x, lightInView.y, lightInView.z);
sphere(60);
popMatrix();
}
