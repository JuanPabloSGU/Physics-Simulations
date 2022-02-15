final int ELIPSE_D = 24;
final int RESOLUTION = 20;
final int AMOUNT_FISH = 50;

boolean setLines = true;

River river;
ArrayList<Fish> school_fish;

public void settings() {
  size(500, 500);
}

public void setup() {
  river = new River(RESOLUTION);
  school_fish = new ArrayList<Fish>();

  for (int index = 0; index < AMOUNT_FISH; index++) {
    float x_location = random(width);
    float y_location = random(height);
    school_fish.add(new Fish(new PVector(x_location, y_location)));
  }
}

public void draw() {
  background(0);

  if (setLines) river.display_current();

  for (Fish fishie : school_fish) {
    fishie.follow_field(river);
    fishie.swim();
  }
  
  fill(255);
  text("Hit the 'f' key to toggle current lines. \n Click the mouse to generate a new river. ", 10, height - 20);
}

public void keyPressed() {
  if (key == 'f') {
    setLines = !setLines;
  }
}

public void mousePressed() {
  river.populate();
}
