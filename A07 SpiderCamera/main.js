/*
  Realizado por
    Jhonatan Steven Rodriguez Ibañez 
    Nestor Sebastian Garzon Contreras 
    Diego Efrain Mojica Mendez 
    Juan Eduardo Bedoya Torres
*/

let delta = 0.005, heightMatrix = [], colorMatrix = [], splinePoints = [], currentPoint = 0;
const NUM_COLS = 10; // Number of columns in the grid
const NUM_ROWS = 10; // Number of rows in the grid
const BOX_SIZE = 40; // Size of each box
const SPACE_BETWEEN_BOXES = 50;
const CONTROL_POINTS = [
  { x: -300, y: -100, z: 320 },
  { x: 400, y: -200, z: 400},
  { x: 700, y: -150, z: -50 },
  { x: 400, y: -10, z: -60 },
  { x: 100, y: -200, z: -50 },
  { x: -300, y: -200, z: -300 },
  { x: -320, y: -200, z: 0 },
];

function setup() {
  createCanvas(680, 480, WEBGL);
  camera = createCamera();
  
  // Create a random heights and colors
  for (let i = 0; i < NUM_COLS; i++) {
    let tempArray = [];
    let tempColorArray = [];
    for (let j = 0; j < NUM_ROWS; j++) {
      tempArray.push(random(50, 200));
      tempColorArray.push(color(random(255), random(255), random(255)));
    }
    heightMatrix.push(tempArray);
    colorMatrix.push(tempColorArray);
    tempArray = [];
    tempColorArray = [];
  }
  splinePoints = createSpline(CONTROL_POINTS);
}

function draw() {
  background(0);
  orbitControl();
  
  //camera.lookAt(0,0,0);
  
  createCity();
  drawSpline(splinePoints); // Draw the spline
  animateCameraOnSpline(); // Animate the camera along the spline
}

function createCity(){
  for (let i = 0; i < NUM_COLS; i++) {
    for (let j = 0; j < NUM_ROWS; j++) {
      const x = i * (BOX_SIZE + SPACE_BETWEEN_BOXES) - (NUM_COLS / 2) * BOX_SIZE;
      const z = j * (BOX_SIZE + SPACE_BETWEEN_BOXES) - (NUM_ROWS / 2) * BOX_SIZE;
      const height = heightMatrix[i][j]; // Random height
      const randomColor = colorMatrix[i][j]; // Random color
      push();
      translate(x, -height / 2, z); // Center buildings on the ground
      fill(randomColor); // Assign the random color to the box
      box(BOX_SIZE, height, BOX_SIZE);
      pop();
    }
  }
}

function createSpline(points) {
  let result = []
  let p0, p1, p2, p3;
  
  for (let i = 0; i < points.length; i++) {
    p0 = points[(i - 1 + points.length) % points.length];
    p1 = points[i];
    p2 = points[(i + 1) % points.length];
    p3 = points[(i + 2) % points.length];
    
    for (let t = 0; t <= 1; t += delta) {
      let t2 = t * t;
      let t3 = t2 * t;
      
      let x = 0.5 * ((-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3 + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 + (-p0.x + p2.x) * t + (2 * p1.x));
      let y = 0.5 * ((-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3 + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 + (-p0.y + p2.y) * t + (2 * p1.y));
      let z = 0.5 * ((-p0.z + 3 * p1.z - 3 * p2.z + p3.z) * t3 + (2 * p0.z - 5 * p1.z + 4 * p2.z - p3.z) * t2 + (-p0.z + p2.z) * t + (2 * p1.z));
      
      result.push(createVector(x, y, z));
    }
  }
  
  return result;
}

function drawSpline(points) {
  push()
  // Draw the path along the defined points
  beginShape();
  noFill();
  stroke(255, 0, 0); // path color
  strokeWeight(3); // path weight
  for (let i = 0; i < points.length; i++) {
    vertex(points[i].x, points[i].y, points[i].z);
  }
  endShape();
  pop()
}

function animateCameraOnSpline() {
  if (currentPoint < splinePoints.length - 1) {
    let currentPos = splinePoints[currentPoint];
    let nextPos = splinePoints[currentPoint + 1];

    // Mover la cámara
    camera.setPosition(currentPos.x, currentPos.y, currentPos.z);
    camera.lookAt(nextPos.x, nextPos.y, nextPos.z);

     currentPoint++;
  } else {
    currentPoint = 0;
  }
}
