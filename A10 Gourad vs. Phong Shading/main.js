/*
  Realizado por
    Jhonatan Steven Rodriguez Ibañez 
    Nestor Sebastian Garzon Contreras 
    Diego Efrain Mojica Mendez 
    Juan Eduardo Bedoya Torres
    
  Con espacio se cambia el método utilizado para el shading
*/

let phongShader, alpha = 32, defaultShader, gouraudShader;

function setup() {
  createCanvas(640, 480, WEBGL);
  gouraudShader = createShader(vertGouraud, fragGouraud);
  phongShader = createShader(vertPhong, fragPhong);
  defaultShader = phongShader;
  noStroke();
}

function draw() {
  background(50); 
  orbitControl();

  createSphere(-150, 0, 0, 50, color(255, 0, 0));
  createSphere(   0, 0, 0, 50, color(0, 255, 0));
  createSphere(150, 0, 0, 50, color(0, 0, 255));
  
  createSphere(-75, 150, 0, 50, color(255, 255, 0));
  createSphere( 75, 150, 0, 50, color(0, 255, 255));
  
  describe("Alpha: " + alpha, LABEL);
}

function createSphere(x, y, z, radius, col) {
  push();
  translate(x, y, z);
  
  const lightX = map(mouseX, 0, width, -1.0, 1.0);
  const lightY = map(mouseY, 0, height, -1.0, 1.0);
  
  defaultShader.setUniform("uColor", [red(col)/255, green(col)/255, blue(col)/255]);
  defaultShader.setUniform("uLightDirection", [lightX, lightY, 1.0]);
  defaultShader.setUniform("uAlpha", alpha);
  
  shader(defaultShader);
  
  sphere(radius);
  pop();
}

function keyPressed(){
  if (key === '+'){
    alpha *= 2;
    return;
  } else if (key === '-'){
    alpha /= 2;
    return;
  } 
  
  if (key == ' ' && phongShader == defaultShader) {
    defaultShader = gouraudShader;
  } else {
    defaultShader = phongShader;
  }
}

const vertPhong = `
precision mediump float;

attribute vec3 aPosition;
attribute vec3 aNormal;

uniform mat4 uProjectionMatrix;
uniform mat4 uModelViewMatrix;
uniform mat3 uNormalMatrix;

varying vec3 vNormal;
varying vec3 vPosition;

void main() {
  vNormal = normalize(uNormalMatrix * aNormal);
  vPosition = (uModelViewMatrix * vec4(aPosition, 1.0)).xyz;
  gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
}
`;

const fragPhong = `
precision mediump float;

varying vec3 vNormal;
varying vec3 vPosition;

uniform vec3 uColor;
uniform vec3 uLightDirection;
uniform float uAlpha;

void main() {
  vec3 normal = normalize(vNormal);
  vec3 eyeDirection = normalize(-vPosition);
  vec3 lightDirection = normalize(uLightDirection);

  vec3 ambient = vec3(0.2, 0.2, 0.2);
  
  vec3 diffuse = uColor * max(0.0, dot(normal, lightDirection));
  
  vec3 reflectionDirection = reflect(-lightDirection, normal);
  vec3 specular = pow(max(dot(reflectionDirection, eyeDirection), 0.0), uAlpha) 
                  * vec3(1.0, 1.0, 1.0);

  gl_FragColor = vec4(ambient + diffuse + specular, 1.0);
}
`;

const vertGouraud = `
precision mediump float;

attribute vec3 aPosition;
attribute vec3 aNormal;

uniform mat4 uProjectionMatrix;
uniform mat4 uModelViewMatrix;
uniform mat3 uNormalMatrix;

varying vec3 vNormal;
varying vec3 vPosition;
varying vec3 vColor;

uniform vec3 uColor;
uniform vec3 uLightDirection;
uniform float uAlpha;

void main() {
  vNormal = normalize(uNormalMatrix * aNormal);
  vPosition = (uModelViewMatrix * vec4(aPosition, 1.0)).xyz;

  // Cálculo de la luz ambiente y difusa
  vec3 ambient = vec3(0.2, 0.2, 0.2);
  vec3 diffuse = uColor * max(0.0, dot(normalize(uLightDirection), vNormal));
  

  // Cálculo del componente especular en el vértice
  vec3 eyeDirection = normalize(-vPosition);
  vec3 reflectionDirection = reflect(-normalize(uLightDirection), vNormal);
  vec3 specular = pow(max(dot(reflectionDirection, eyeDirection), 0.0), uAlpha) 
                  * vec3(1.0, 1.0, 1.0);
                  
  vColor = ambient + diffuse + specular;

  gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
}
`;

const fragGouraud = `
precision mediump float;

varying vec3 vColor;

void main() {
  gl_FragColor = vec4(vColor, 1.0);
}
`;
