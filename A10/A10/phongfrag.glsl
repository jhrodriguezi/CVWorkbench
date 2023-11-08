precision mediump float;

varying vec3 fragPosition;
varying vec3 fragNormal;

uniform vec3 lightDirection; 
uniform vec3 ambientColor; 
uniform vec3 diffuseColor;
uniform vec3 specularColor; 
uniform float shininess; 

void main() {
  vec3 normal = normalize(fragNormal);
  vec3 lightDir = normalize(lightDirection);

  // Calculate diffuse component
  float diffuse = max(dot(normal, lightDir), 0.0);
  
  // Calculate reflection vector for the specular component
  vec3 viewDir = normalize(-fragPosition);
  vec3 reflectDir = reflect(-lightDir, normal);
  
  // Calculate the specular component
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
  
  // Calculate the final color
  vec3 result = (ambientColor + diffuseColor * diffuse + specularColor * spec);

  gl_FragColor = vec4(result, 1.0);
}
