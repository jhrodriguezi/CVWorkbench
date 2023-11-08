uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec3 normal;

varying vec3 fragPosition;
varying vec3 fragNormal;

void main() {
  gl_Position = transform * position;
  fragPosition = vec3(modelview * position);
  fragNormal = normalize(normalMatrix * normal);
}
