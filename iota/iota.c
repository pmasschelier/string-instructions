#include <stddef.h>

void iota_dummy(unsigned char *s, size_t n) {
  for (int i = 0; i < n; i++)
    s[i] = i;
}
