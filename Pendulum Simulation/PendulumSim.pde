
Pendulum pendulum;
final int len = 100;
final int radius = 30;
final int startX = 500 / 2;
final int startY = 0;
final int endY = 100;

public void settings() {
  size(500, 500);
}

public void setup() {
  pendulum = new Pendulum(new PVector(startX, startY), new PVector(startX, endY), len, radius);
}

public void draw() {
  background(0);
  pendulum.update();
  pendulum.render();
  pendulum.angle += 0.01;
}
