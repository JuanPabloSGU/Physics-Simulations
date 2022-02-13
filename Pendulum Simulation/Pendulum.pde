final float constant = 0.01;
final float damp = 0.99;

public class Pendulum {
  int len;
  int radius;
  PVector pos;
  PVector end;
  float angle = PI/4;
  float angular_vel = 0.0;
  float angular_acc = 0.0;

  public Pendulum(PVector pos, PVector end, int len, int radius) {
    this.pos = pos;
    this.end = end;
    this.len = len;
    this.radius = radius;
  }

  public void render() {
    line(pos.x, pos.y, end.x, end.y);
    stroke(255);
    ellipse(end.x, end.y, radius, radius);
    noFill();
  }

  public void update() {
    end.x = pos.x + len * sin(angle);
    end.y = pos.y + len * cos(angle);
    
    angular_acc = -constant * sin(angle);
    
    angle += angular_vel;
    angular_vel += angular_acc;
    
    angular_vel *= damp;
  }
}
