
Fluid fluid;

public void settings() {
  size(N * SCALE, N * SCALE);
}

public void setup() {
  fluid = new Fluid(0.1, 0, 0);
}

public void mouseDragged() {
  fluid.add_density(mouseX / SCALE, mouseY / SCALE, 100);
  float amountX = mouseX - pmouseX;
  float amountY = mouseY - pmouseY;
  fluid.add_vel(mouseX / SCALE, mouseY / SCALE, amountX / SCALE, amountY / SCALE);
}

public void draw() {
  background(0);
  fluid.fluid_step();
  fluid.render_d();
  fluid.fade_d();
}
