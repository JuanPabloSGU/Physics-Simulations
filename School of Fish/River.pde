
final int STRENGTH = 1000;
final float ARROW_SIZE = 5;

public class River {
  PVector[][] field;
  int rows;
  int cols;
  int scale;

  public River(int scale) {
    this.scale = scale;
    this.rows = height/scale;
    this.cols = width/scale;
    this.field = new PVector[cols][rows];
    populate();
  }

  public void populate() {
    noiseSeed((int)random(STRENGTH));
    float x_offset = 0;

    for (int i = 0; i < cols; i++) {
      float y_offset = 0;
      for (int j = 0; j < rows; j++) {
        float phi = map(noise(x_offset, y_offset), 0, 1, 0, TWO_PI);
        field[i][j] = new PVector(cos(phi), sin(phi));
        y_offset += 0.1;
      }
      x_offset += 0.1;
    }
  }

  public void display_current() {
    for (int j= 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        display(field[j][i], j * scale, i * scale, scale - 2);
      }
    }
  }

  public void display(PVector arrow, float x, float y, float mag) {
    pushMatrix();
    translate(x, y);
    stroke(255, 255);
    rotate(arrow.heading());
    float arrow_mag = arrow.mag() * mag;
    line(0, 0, arrow_mag, 0);
    line(arrow_mag, 0, arrow_mag - ARROW_SIZE, +ARROW_SIZE / 2);
    line(arrow_mag, 0, arrow_mag - ARROW_SIZE, -ARROW_SIZE / 2);
    popMatrix();
  }
  
  public PVector find(PVector value) {
    int row_loc = int(constrain(value.y / scale, 0, rows - 1));
    int col_loc = int(constrain(value.x / scale, 0, cols - 1));
    return field[col_loc][row_loc].copy();
  }
}
