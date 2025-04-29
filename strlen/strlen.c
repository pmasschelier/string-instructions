#include <stddef.h>

size_t __attribute__((optimize("O1"))) strlen_dummy(const char *s) {
  unsigned int size = 0;
  while (*(s++) != 0)
    size++;
  return size;
}
