final float MAX_SPEED = 5;
final float MAX_FORCE = 0.1;
final float MAX_SIZE = 5;
final float MAX_WEIGHT = 2;
final float DAMP = 100;

public class Fish {

  float max_speed;
  float max_force;
  float size_fish;
  float mass;

  PVector location;
  PVector vel;
  PVector acc;

  public Fish(PVector loc) {
    this.max_speed = MAX_SPEED;
    this.max_force = MAX_FORCE;
    this.size_fish = MAX_SIZE;
    this.mass = MAX_WEIGHT;
    this.location = loc;
    this.vel = new PVector(0, -1);
    this.acc = new PVector(0, 0);
  }

  public void update() {
    vel.add(acc); // update velocity
    vel.limit(MAX_SPEED); // Limit speed to max
    location.add(vel); // update location
    acc.mult(0); // reset accerlation
  }

  public void swim() {
    update();
    river_borders();
    render();
  }

  public void follow_field(River current) {
    PVector final_pos = current.find(location);
    final_pos.mult(MAX_SPEED);

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
    vertex(0, -size_fish * 2);
    vertex(-size_fish, size_fish * 2);
    vertex(size_fish, size_fish * 2);
    endShape();
    popMatrix();
  }

  public void river_borders() {
    if (location.x < -size_fish) location.x = width + size_fish;
    if (location.y < -size_fish) location.y = height + size_fish;
    if (location.x > width + size_fish) location.x = -size_fish;
    if (location.y > height + size_fish) location.y = -size_fish;
  }
}
