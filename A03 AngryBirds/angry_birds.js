const {Engine, Mouse, MouseConstraint, World, Events, Body} = Matter;

let engine, world, bird, redImage, chuckImage, boxImage, ground, boxes = [], slingShot;

function preload() {
  redImage = loadImage('red.png');
  boxImage = loadImage('box.png');
  box2Image = loadImage('box_2.png');
  chuckImage = loadImage('chuck.png');
}

function setup() {
  const canvas = createCanvas(windowWidth, windowHeight);
  noStroke();
    
  engine = Engine.create();
  world = engine.world;
  
  
  const mouse = Mouse.create(canvas.elt);
  mouse.pixelRatio = pixelDensity();
  
  const mConstraint = MouseConstraint.create(engine, {
    mouse: mouse,
    collisionFilter: {
      mask: 2
    }
  }); 
  
  World.add(world, mConstraint);
  
  bird = new Bird(150, height - 100, redImage);
  slingShot = new SlingShot(bird.body);
  
  ground = new Ground(width/2, height - 10, width, 20);
  
  for(let i = 0; i < 9; i++) {
    boxes.push(new Box(width * 3.0 / 4,
                       50 * 1, 50, 50,
                       i % 2 == 0 ? boxImage : box2Image));
  }
  
  Events.on(engine, 'afterUpdate', () => {
    slingShot.fly(mConstraint);
  });
}


function draw() {
  background(128);
  
  Engine.update(engine);
  slingShot.show();
  bird.show();
  ground.show();
  
  for(const b of boxes) {
    b.show();
  }
}

function keyPressed() {
  if(key == ' ') {
    const img = random(0,1) < 0.5 ? redImage : chuckImage;
    World.remove(world, bird.body);
    bird = new Bird(150, height - 100, img);
    /*Body.set(bird.body, 'position', {
      x: 150,
      y: height - 100
    });*/
    slingShot.attach(bird.body);
  }
}

function windowResized() {
  // Esta función se llama cuando se cambia el tamaño de la ventana del navegador
  resizeCanvas(windowWidth, windowHeight);
}
