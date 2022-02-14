
final float MAX_SPEED = 5;
final float MAX_FORCE = 0.1;
final float MAX_SIZE = 5;
final float MAX_WEIGHT = 2;

public class Vehicle {

  float max_speed;
  float max_force;
  float size_vehicle;
  float mass;

  PVector location;
  PVector vel;
  PVector acc;

  public Vehicle(float x, float y) {
    this.max_speed = MAX_SPEED;
    this.max_force = MAX_FORCE;
    this.size_vehicle = MAX_SIZE;
    this.mass = MAX_WEIGHT;

    location = new PVector(x, y);
    vel = new PVector(0, -1);
    acc = new PVector(0, 0);
  }

  public void update() {
    vel.add(acc); // update velocity
    vel.limit(MAX_SPEED); // Limit speed to max
    location.add(vel); // update location
    acc.mult(0); // reset accerlation
  }

  public void seek(PVector target) {
    PVector final_pos = PVector.sub(target, location);
    final_pos.setMag(MAX_SPEED);
    
    PVector steer = PVector.sub(final_pos, vel);
    steer.limit(MAX_FORCE);
    
    acc.add(steer);
  }
  
  public void render() {
    float phi = vel.heading() + PI/2;
    fill(255);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(phi);
    beginShape();
    vertex(0, -size_vehicle * 2);
    vertex(-size_vehicle, size_vehicle * 2);
    vertex(size_vehicle, size_vehicle * 2);
    endShape();
    popMatrix();
  }
}
