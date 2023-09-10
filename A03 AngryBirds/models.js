class Bird {
  constructor(x, y, img, r = 25) {
    this.body = Matter.Bodies.circle(x, y, r, {
                                      restitution: 0.5,
                                      collisionFilter: {
                                        category: 2
                                      }
                                    });
    Matter.World.add(world, this.body);
    Matter.Body.set(this.body, 10);
    this.img = img;  
  }
  
  show() {
    //ellipse(
    //  this.body.position.x,
    //  this.body.position.y,
    //  this.body.circleRadius * 2
    //);
    push();
    translate(this.body.position.x, this.body.position.y);
    rotate(this.body.angle);
    
    imageMode(CENTER);
    image(this.img, 0, 0,
      this.body.circleRadius * 2, this.body.circleRadius * 2);
    pop();
  }
}

class Box {
  constructor(x, y, w, h, img, options = {}) {
    this.body = Matter.Bodies.rectangle(
      x, y, w, h, options
    );
    this.img = img;
    this.w = w;
    this.h = h;
    Matter.World.add(world, this.body);
  }
  
  show() {
    push();
    translate(this.body.position.x, this.body.position.y);
    rotate(this.body.angle);
    if (this.img) {
      imageMode(CENTER);
      image(this.img, 0, 0,
        this.w, this.h)
    } else {
      rectMode(CENTER);
      fill(50, 200, 0);
      rect(0, 0,
        this.w, this.h);
    }
    pop(); 
  }
}

class Ground extends Box {
  constructor(x, y, w, h) {
    super(x, y, w, h, null, {isStatic: true});
  }
}

class SlingShot {
  constructor(body) {
    this.sling = Matter.Constraint.create({
      pointA: {x: body.position.x, y: body.position.y},
      bodyB: body,
      length: 5,
      stiffness: 0.05
    });
    Matter.World.add(world, this.sling);  
  }
 
 show() {
   if(this.sling.bodyB == null) {return;}
   
   push();
   stroke(0);
   strokeWeight(3);
   line(this.sling.pointA.x, this.sling.pointA.y,
     this.sling.bodyB.position.x, this.sling.bodyB.position.y);
   pop();
 }
 
 fly(mConstraint) {
   if(this.sling.bodyB && mConstraint.mouse.button == -1 && 
       this.sling.bodyB.position.x > this.sling.pointA.x + 15) {
         
       this.sling.bodyB.collisionFilter.category = 1;  
       this.sling.bodyB = null;
   }
 }
 
 attach(body) {
   this.sling.bodyB = body;
 }
}
