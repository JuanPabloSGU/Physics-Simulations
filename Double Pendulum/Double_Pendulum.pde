PGraphics canvas;

Pendulum pendulum;
Pendulum secondary;

final int gravity = 1;
final int radius = 150;
final int mass = 20;

public void settings() {
  size(500, 500);
}

public void setup() {
  pendulum = new Pendulum(radius, mass, PI/4);
  secondary = new Pendulum(radius, mass, -PI/4);
  
  pendulum.angular_acc = 0.1;
  secondary.angular_acc = -0.01;

  canvas = createGraphics(500, 500);
  canvas.beginDraw();
  canvas.background(0);
  canvas.translate(250, 100);
  canvas.endDraw();
}

public void draw() {
  image(canvas, 0, 0);
  translate(250, 100);
  stroke(255);
  pendulum.render();
  secondary.render(pendulum.x, pendulum.y);

  float p1 = -gravity * (2 * pendulum.mass + secondary.mass) * sin(pendulum.angle);
  float p2 = -secondary.mass * gravity * sin(pendulum.angle - 2 * secondary.angle);
  float p3 = -2 * sin(pendulum.angle - secondary.angle) * secondary.mass;
  float p4 = secondary.angular_vel * secondary.angular_vel * secondary.radius + pendulum.angular_vel * pendulum.angular_vel * pendulum.radius * cos(pendulum.angle - secondary.angle);
  float p5 = pendulum.radius * (2 * pendulum.mass + secondary.mass - secondary.mass * cos(2 * pendulum.angle - 2 * secondary.angle));

  pendulum.angular_acc = (p1 + p2 + p3 * p4) / p5;

  p1 = 2 * sin(pendulum.angle - secondary.angle);
  p2 = (pendulum.angular_vel * pendulum.angular_vel * pendulum.radius * (pendulum.mass + secondary.mass));
  p3 = gravity * (pendulum.mass + secondary.mass) * cos(pendulum.angle);
  p4 = secondary.angular_vel * secondary.angular_vel * secondary.radius * secondary.mass * cos(pendulum.angle - secondary.angle);
  p5 = secondary.radius * (2 * pendulum.mass + secondary.mass - secondary.mass * cos(2 * pendulum.angle - 2 * secondary.angle));
  
  secondary.angular_acc = (p1 * (p2 + p3 + p4)) / p5;

  canvas.beginDraw();
  canvas.strokeWeight(1);
  canvas.stroke(255);
  canvas.translate(250, 100);
  canvas.point(secondary.x, secondary.y);
  canvas.endDraw();
}
