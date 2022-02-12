final int N = 128;
final int iteration_val = 4;
final int SCALE = 4;

// This method returns the one dimentional location in a 2d array
public int IX(int a, int b) {
  return a + b * N;
}

// This method precalculates the diffusion value for any arbitrary array of values
public void diffuse(int b, float[] x, float[] x0, float diff, float dt) {
  float a = dt * diff * (N - 2) * (N - 2);
  lin_solve(b, x, x0, a, 1 + 6 * a);
}

// This method solves a linear equation (kinda messy)
public void lin_solve(int b, float[] x, float[] x0, float a, float c) {
  float cRecip = 1.0 / c;
  for (int k = 0; k < iteration_val; k++) {
    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        // Value of itself and its neighboors
        x[IX(i, j)] = (x0[IX(i, j)] + a*(x[IX(i+1, j)] + x[IX(i-1, j)] + x[IX(i, j+1)] + x[IX(i, j-1)])) * cRecip;
      }
    }
  }
  set_bnd(b, x);
}

// This method clean up stage to put everthing back to equilibrium
public void project(float[] velX, float[] velY, float[] p, float[] div) {
  for (int j = 1; j < N - 1; j++) {
    for (int i = 1; i < N - 1; i++) {
      div[IX(i, j)] = -0.5f * (velX[IX(i+1, j)] - velX[IX(i-1, j)] + velY[IX(i, j+1)] - velY[IX(i, j-1)]) / N;
      p[IX(i, j)] = 0;
    }
  }
  set_bnd(0, div);
  set_bnd(0, p);
  lin_solve(0, p, div, 1, 6);

  for (int j = 1; j < N - 1; j++) {
    for (int i = 1; i < N - 1; i++) {
      velX[IX(i, j)] -= 0.5f * (p[IX(i+1, j)] - p[IX(i-1, j)]) * N;
      velY[IX(i, j)] -= 0.5f * (p[IX(i, j+1)] - p[IX(i, j-1)]) * N;
    }
  }
  set_bnd(1, velX);
  set_bnd(2, velY);
}

// This method makes things moves (advection)
public void advect(int b, float[] d, float[] d0, float[] velX, float[] velY, float dt) {
  float i0, i1, j0, j1;

  float dtX = dt * (N - 2);
  float dtY = dt * (N - 2);

  float s0, s1, t0, t1;
  float temp1, temp2, x, y;

  float Nfloat = N;
  float ifloat, jfloat;
  int i, j;

  for (j = 1, jfloat = 1; j < N - 1; j++, jfloat++) {
    for (i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
      temp1 = dtX * velX[IX(i, j)];
      temp2 = dtY * velY[IX(i, j)];
      x = ifloat - temp1;
      y = jfloat - temp2;

      if (x < 0.5f) x = 0.5f;
      if (x > Nfloat + 0.5f) x = Nfloat + 0.5f;

      i0 = floor(x);
      i1 = i0 + 1.0f;

      if (y < 0.5f) y = 0.5f;
      if (y > Nfloat + 0.5f) y = Nfloat + 0.5f;

      j0 = floor(y);
      j1 = j0 + 1.0f;

      s1 = x - i0;
      s0 = 1.0f - s1;

      t1 = y - j0;
      t0 = 1.0f - t1;

      int i0i = int(i0);
      int i1i = int(i1);

      int j0i = int(j0);
      int j1i = int(j1);

      d[IX(i, j)] = s0 * (t0 * d0[IX(i0i, j0i)] + t1 * d0[IX(i0i, j1i)]) + s1 * (t0 * d0[IX(i1i, j0i)] + t1 * d0[IX(i1i, j1i)]);
    }
  }
  set_bnd(b, d);
}

// This method sets the boundary cells at the outer edge of the cube so that it can interact with their neighboors
public void set_bnd(int b, float[] x) {
  for (int i = 1; i < N - 1; i++) {
    x[IX(i, 0)] = b == 2 ? -x[IX(i, 1)] : x[IX(i, 1)];
    x[IX(i, N-1)] = b == 2 ? -x[IX(i, N-2)] : x[IX(i, N-2)];
  }

  for (int j = 1; j < N - 1; j++) {
    x[IX(0, j)] = b == 1 ? -x[IX(1, j)] : x[IX(1, j)];
    x[IX(N-1, j)] = b == 1 ? -x[IX(N-2, j)] : x[IX(N-2, j)];
  }

  x[IX(0, 0)] = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
  x[IX(0, N-1)] = 0.5f * (x[IX(1, N-1)] + x[IX(0, N-2)]);
  x[IX(N-1, 0)] = 0.5f * (x[IX(N-2, 0)] + x[IX(N-1, 1)]);
  x[IX(N-1, N-1)] = 0.5f * (x[IX(N-2, N-1)] + x[IX(N-1, N-2)]);
}

public class Fluid {
  int size; // size
  float dt; // time difference
  float diff; // diffusion rate
  float visc; // viscosity (thickness)

  float[] prev_density; // previous density value
  float[] density; // density value

  float[] Vx; // X-direction velocity
  float[] Vy; // Y-direction velocity

  float[] Vx0; // Initial X-direction velocity
  float[] Vy0; // Initial Y-direciton velocity

  public Fluid(float dt, float diffusion, float viscosity) {
    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;
    this.prev_density = new float[N * N];
    this.density = new float[N * N];
    this.Vx = new float[N * N];
    this.Vy = new float[N * N];
    this.Vx0 = new float[N * N];
    this.Vy0 = new float[N * N];
  }

  private void add_density(int x, int y, float value) {
    int index = IX(x, y);
    this.density[index] += value;
  }

  private void add_vel(int x, int y, float amountX, float amountY) {
    int index = IX(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }

  // Puts pixels on the screen
  public void render_d() {

    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[IX(i, j)];
        
        fill(255, d);
        noStroke();
        square(x, y, SCALE);
      }
    }
  }

  // Removes faded pixels on the screen
  public void fade_d() {
    for (int i = 0; i < this.density.length; i++) {
      float d = density[i];
      density[i] = constrain(d-0.05, 0, 255);
    }
  }

  // This method is a time step method
  public void fluid_step() {
    float dt = this.dt;
    float diff = this.diff;
    float visc = this.visc;
    float[] prev_density = this.prev_density;
    float[] density = this.density;
    float[] Vx = this.Vx;
    float[] Vy = this.Vy;
    float[] Vx0 = this.Vx0;
    float[] Vy0 = this.Vy0;

    // Diffuse the velocity
    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);

    // Clean
    project(Vx0, Vy0, Vx, Vy);

    // Advect all of the velocity
    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);

    // Clean up
    project(Vx, Vy, Vx0, Vy0);

    diffuse(0, prev_density, density, diff, dt);
    advect(0, density, prev_density, Vx, Vy, dt);
  }
}
