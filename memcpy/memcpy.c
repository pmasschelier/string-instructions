#include <stddef.h>

__attribute__((optimize("O1"))) void *
memcpy_dummy(void *restrict dst, const void *restrict src, size_t n) {
  void *const ret = dst;
  for (int i = 0; i < n; i++)
    *((char *)dst++) = *((char *)src++);
  return ret;
}
