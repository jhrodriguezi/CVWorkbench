precision mediump float;

varying vec4 vertColor;
varying vec3 fragNormal;
varying vec3 lightDir;

void main() {
  vec3 normal = normalize(fragNormal);
  float shading = max(0.0, dot(normal, lightDir));
  gl_FragColor = vertColor * shading;
}
