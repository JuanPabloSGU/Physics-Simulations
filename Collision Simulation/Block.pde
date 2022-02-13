
public class Block {
  int x;
  int y;
  int w;
  int vel;
  int mass;

  public Block (int x, int w, int mass, int vel) {
    this.x = x;
    this.y = height - w;
    this.w = w;
    this.vel = vel;
    this.mass = mass;
  }

  public void render_block(int colour) {
    fill(colour, 255);
    noStroke();
    square(x, y, w);
  }

  public void update() {
    this.x += this.vel;
  }

  public boolean collision(Block other) {
    return !(this.x + this.w < other.x || this.x > other.x + other.w);
  }

  public void hitWall() {
    if (this.x <= 0) {
      this.vel *= -1;
    } else if (this.x >= width - this.w) {
      this.vel *= -1;
    }
  }

  public int interact(Block other) {
    int total_mass = this.mass + other.mass;
    int total_vel = (this.mass - other.mass) / total_mass * this.vel;
    total_vel += (2 * other.mass / total_mass) * other.vel;
    return total_vel;
  }
}
