
final int AMOUNT_VEHICLE = 50;

ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();

public void settings() {
  size(500, 500);
}

public void setup() {
  for (int index = 0; index < AMOUNT_VEHICLE; index++) {
    int random_x = floor(random(0, width));
    int random_y = floor(random(0, height));
    vehicles.add(new Vehicle(random_x, random_y));
  }
  // v = new Vehicle(width / 2, height / 2);
}

public void draw() {
  background(0);

  PVector mouse = new PVector(mouseX, mouseY);

  fill(255);
  stroke(0);
  strokeWeight(1);
  ellipse(mouse.x, mouse.y, 24, 24);

  for (Vehicle v : vehicles) {
    v.seek(mouse);
    v.update();
    v.render();
  }
}
