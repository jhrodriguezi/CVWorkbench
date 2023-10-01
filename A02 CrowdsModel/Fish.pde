class Fish {
  final float OBSTACLE_AVOID_STRENGTH = 1000;
  PVector velocity, position, acceleration;
  float perceptionRadius, angle, mass, maxSpeed, maxForce, hunger, libido, fear;
  PImage img;
  
  Fish(PVector position, PVector velocity, PVector acceleration) {
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
    perceptionRadius = random(40, 60);
    mass = 1;
    maxSpeed = 3;
    maxForce = 0.06;
    hunger = random(1);
    libido = random(1);
    fear = random(1);
  }
  
  void run(List<Fish> fish, List<Obstacle> obstacles) {
    if(img == null) return;
    flock(fish, obstacles);
    update();
    checkLimits();
    show();
  }
  
  void flock(List<Fish> fish, List<Obstacle> obstacles) {
    PVector sep = separate(fish);   // Separation
    PVector ali = align(fish);      // Alignment
    PVector coh = cohesion(fish);   // Cohesion
    PVector avo = avoidObstacles(obstacles);
    
    // Add the force vectors to acceleration
    applyForce(sep.mult((1 - hunger) + (1 - libido) + fear));
    applyForce(ali.mult(hunger + libido + (1 - fear)));
    applyForce(coh.mult(hunger + libido + (1 - fear)));
    applyForce(avo);
  }
  
  PVector align(List<Fish> fish) {
    PVector sum = new PVector(0, 0), steer;
    int count = 0;
    float d;
    for (Fish f : fish) {
      d = PVector.dist(position, f.position);
      if ((d > 0) && (d < perceptionRadius)) {
        sum.add(f.velocity);
        count++;
      }
    }
    
    if (count > 0) {
      sum.div((float)count);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxSpeed);
      steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } 
    
    return new PVector(0, 0);
  }
  
  PVector separate(List<Fish> fish) {
    PVector steer = new PVector(0, 0), diff;
    int count = 0;
    float d;
    
    // For every boid in the system, check if it's too close
    for (Fish f : fish) {
      d = PVector.dist(position, f.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < perceptionRadius)) {
        // Calculate vector pointing away from neighbor
        diff = PVector.sub(position, f.position);
        diff.normalize();
        diff.div(d * d);        // Inversely proportional to the distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    
    return steer;
  }
  
  PVector cohesion(List<Fish> fish) {
    PVector sum = new PVector(0, 0), desired, steer;   // Start with empty vector to accumulate all positions
    int count = 0;
    float d;
    for (Fish f : fish) {
      d = PVector.dist(position, f.position);
      if ((d > 0) && (d < perceptionRadius)) {
        sum.add(f.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      desired = PVector.sub(sum, position);  // A vector pointing from the position to the target
      // Scale to maximum speed
      desired.normalize();
      desired.mult(maxSpeed);
  
      // Above two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // desired.setMag(maxspeed);
  
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);  // Limit to maximum steering force
      return steer;
    } 
    
    return new PVector(0, 0);
  }
  
  PVector avoidObstacles(List<Obstacle> obstacles) {
    PVector sum = new PVector(0, 0);
    PVector res;
    int count = 0;
    for(Obstacle o : obstacles) {
      res = avoidObstacle(o);
      if(res.x == 0 && res.y == 0) continue;
      sum.add(res);
      count++;
    }
    
    if(count != 0) {
      sum.div((float) count);
    }
    return sum;
  }
  
  PVector avoidObstacle(Obstacle o) {
    PVector vectorToObstacle = PVector.sub(this.position, o.position);
    float squareDistanceToObstacle = vectorToObstacle.mag();
    if(squareDistanceToObstacle < o.reactionDistance) {
      float avoidAmount = map(squareDistanceToObstacle, 0, o.reactionDistance, OBSTACLE_AVOID_STRENGTH, 0);
      return vectorToObstacle.setMag(avoidAmount).limit(6 * maxForce);
    }
    
    return new PVector(0, 0);
  }
  
  void applyForce(PVector force) {
     // Accumulate all forces in acceleration
     acceleration.add(PVector.div(force, mass));
  }
  
  void show() {
    pushMatrix();
    
    translate(this.position.x, this.position.y);
    
    if(angle >= PI / 2 && angle < 3 * PI / 2) {
      scale(1, -1);
      angle *= -1;
    }
    
    rotate(angle);
    
    imageMode(CENTER);
    image(img, 0, 0);
    
    popMatrix();
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.x *= 1.03;
    velocity.limit(maxSpeed);
    
    position.add(velocity);
    
    acceleration.mult(0);
    
    // Calculo del angulo de rotación
    angle = velocity.heading() + PI;
  }
  
  void setImage(PImage fimg) {
    this.img = fimg;
  }
 
  
  void checkLimits() {
    // Si el pez sale de la pantalla por el lado derecho, aparece por el lado izquierdo
    if(this.position.x - img.width > width) {
      this.position.x = -img.width;
      this.position.y = random(height);
    }
    
    // Si el pez sale de la pantalla por el lado izquierdo, aparece por el lado derecho
    if(this.position.x < -img.width) {
      this.position.x = width + img.width;
      this.position.y = random(height);
    }
    
    // Si el pez sale de la pantalla por la parte superior, aparece en la parte inferior
    if(this.position.y < -img.height) {
      this.position.y = height + img.height;
      this.position.x = random(width);
    }
    
    // Si el pez sale de la pantalla por la parte inferior, aparece en la parte superior
    if(this.position.y - img.height > height) {
      this.position.y = -img.height;
      this.position.x = random(width);
    }
  }
}
