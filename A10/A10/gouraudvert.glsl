uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec3 normal;
attribute vec4 color;

varying vec4 vertColor;
varying vec3 fragNormal;
varying vec3 lightDir;

void main() {
  gl_Position = transform * position;
  fragNormal = normalize(normalMatrix * normal);
  lightDir = normalize(vec3(1.0, -1.0, 1.0)); 
  vertColor = color;
}
