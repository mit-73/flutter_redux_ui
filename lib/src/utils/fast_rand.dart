int x = 123456789, y = 362436069, z = 521288629;

int get fastRand {
  int t;
  
  x ^= x << 16;
  x ^= x >> 5;
  x ^= x << 1;

  t = x;
  x = y;
  y = z;

  return t ^ x ^ y;
}
