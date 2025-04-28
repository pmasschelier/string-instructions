#include <stddef.h>
#include <string.h>
#include <tap.h>

#include "memset.h"

#define DSTLEN1 113
char dst[DSTLEN1];

char buffer[1024];
char base[1024];
void test_memset(void *(*fn)(void *, int, size_t), void *dst, size_t dstlen,
                 int value, unsigned offset, unsigned count, const char *name) {
  void *ret;
  memset(base, 0, dstlen);
  memset(base + offset, value, count);
  memset(dst, 0, dstlen);
  ret = fn(dst + offset, value, count);
  cmp_mem(dst, base, dstlen, name);
  snprintf(buffer, 1024, "%s (retval)", name);
  ok(ret == (dst + offset), buffer);
}

int main(int argc, char *argv[]) {
  plan(64);

  test_memset(memset, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "Standard memset function");
  test_memset(memset, dst, DSTLEN1, 0xAF, 0, 0,
              "Standard memset function (0-length)");
  test_memset(memset, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "Standard memset function (partial)");
  test_memset(memset, dst, DSTLEN1, 0xAF, 7, 18,
              "Standard memset function (partial short)");

  test_memset(memset_dummy, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_dummy function");
  test_memset(memset_dummy, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_dummy function (0-length)");
  test_memset(memset_dummy, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_dummy function (partial)");
  test_memset(memset_dummy, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_dummy function (partial short)");

  test_memset(memset_stosb, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_stosb function");
  test_memset(memset_stosb, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_stosb function (0-length)");
  test_memset(memset_stosb, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_stosb function (partial)");
  test_memset(memset_stosb, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_stosb function (partial short)");

  test_memset(memset_stosq, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_stosq function");
  test_memset(memset_stosq, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_stosq function (0-length)");
  test_memset(memset_stosq, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_stosq function (partial)");
  test_memset(memset_stosq, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_stosq function (partial short)");

  test_memset(memset_movb, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_movb function");
  test_memset(memset_movb, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_movb function (0-length)");
  test_memset(memset_movb, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_movb function (partial)");
  test_memset(memset_movb, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_movb function (partial short)");

  test_memset(memset_movq, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_movq function");
  test_memset(memset_movq, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_movq function (0-length)");
  test_memset(memset_movq, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_movq function (partial)");
  test_memset(memset_movq, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_movq function (partial short)");

  test_memset(memset_avx, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_avx function");
  test_memset(memset_avx, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_avx function (0-length)");
  test_memset(memset_avx, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_avx function (partial)");
  test_memset(memset_avx, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_avx function (partial short)");

  test_memset(memset_avx2, dst, DSTLEN1, 0xAF, 0, DSTLEN1,
              "memset_avx2 function");
  test_memset(memset_avx2, dst, DSTLEN1, 0xAF, 0, 0,
              "memset_avx2 function (0-length)");
  test_memset(memset_avx2, dst, DSTLEN1, 0xAF, 3, DSTLEN1 - 6,
              "memset_avx2 function (partial)");
  test_memset(memset_avx2, dst, DSTLEN1, 0xAF, 7, 18,
              "memset_avx2 function (partial short)");

  return EXIT_SUCCESS;
}
