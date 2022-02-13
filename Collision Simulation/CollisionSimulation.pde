
Block block;
Block other_block;

public void settings() {
  size(500, 500);
}

public void setup() {
  block = new Block(100, 20, 10, 0);
  other_block = new Block(300, 40, 10, -2);
}

public void draw() {
  background(0);
  if (block.collision(other_block)) {
    int block_vel = block.interact(other_block);
    int block_vel2 = other_block.interact(block);

    block.vel = block_vel;
    other_block.vel = block_vel2;
  }

  block.update();
  other_block.update();
  block.render_block(255);
  other_block.render_block(100);
  block.hitWall();
  other_block.hitWall();
}
