
public class Pendulum {
  int radius;
  float x;
  float y;
  float mass;
  float angle;
  float angular_vel;
  float angular_acc;

  public Pendulum(int radius, float mass, float angle) {
    this.radius = radius;
    this.mass = mass;
    this.angle = angle;
  }

  public void render(float x_pos, float y_pos) {
    this.x = x_pos + this.radius * sin(this.angle);
    this.y = y_pos + this.radius * cos(this.angle);
    line(x_pos, y_pos, this.x, this.y);
    ellipse(this.x, this.y, mass, mass);
    
     this.angular_vel += this.angular_acc;
    this.angle += this.angular_vel;
   
  }

  public void render() {
    this.x = this.radius * sin(this.angle);
    this.y = this.radius * cos(this.angle);
    line(0, 0, this.x, this.y);
    ellipse(this.x, this.y, mass, mass);
    
    this.angular_vel += this.angular_acc;
    this.angle += this.angular_vel;
  }
}
