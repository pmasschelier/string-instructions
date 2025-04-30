#include <stddef.h>
int memcmp_dummy(const void *s1, const void *s2, size_t n) {
  int diff;
  for (int i = 0; i < n; i++) {
    diff = *((char *)s1++) - *((char *)s2++);
    if (diff != 0)
      return diff < 0 ? -1 : 1;
  }
  return 0;
}
