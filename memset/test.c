#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <tap.h>

#include "memset.h"

#define DSTLEN1 113
char dst[DSTLEN1];

char buffer[1024];
char base[1024];

void test_memset(void *(*fn)(void *, int, size_t), const char *name) {
  void *ret;

  // Test case 1
  memset(base, 0xAF, DSTLEN1);
  memset(dst, 0x00, DSTLEN1);
  ret = fn(dst, 0xAF, DSTLEN1);
  cmp_mem(dst, base, DSTLEN1, "%s function", name);
  cmp_ok((uintptr_t)ret, "==", (uintptr_t)dst, "%s function (retval)", name);

  // Test case 2
  memset(base, 0x00, DSTLEN1);
  memset(dst, 0x00, DSTLEN1);
  ret = fn(dst, 0xAF, 0);
  cmp_mem(dst, base, DSTLEN1, "%s function (0-length)", name);
  cmp_ok((uintptr_t)ret, "==", (uintptr_t)dst,
         "%s function (0-length) (retval)", name);

  // Test case 3
  const size_t offset3 = 3;
  const size_t count3 = DSTLEN1 - 6;
  memset(base, 0x00, DSTLEN1);
  memset(base + offset3, 0xAF, count3);
  memset(dst, 0x00, DSTLEN1);
  ret = fn(dst + offset3, 0xAF, count3);
  cmp_mem(dst, base, DSTLEN1, "%s function (partial)", name);
  cmp_ok((uintptr_t)ret, "==", (uintptr_t)dst + offset3,
         "%s function (partial) (retval)", name);

  // Test case 4
  const size_t offset4 = 7;
  const size_t count4 = 18;
  memset(base, 0x00, DSTLEN1);
  memset(base + offset4, 0xAF, count4);
  memset(dst, 0x00, DSTLEN1);
  ret = fn(dst + offset4, 0xAF, 18);
  cmp_mem(dst, base, DSTLEN1, "%s function (partial short)", name);
  cmp_ok((uintptr_t)ret, "==", (uintptr_t)dst + offset4,
         "%s function (partial short) (retval)", name);
}

int main(int argc, char *argv[]) {
  plan(72);

  test_memset(memset, "Standard memset");
  test_memset(memset_dummy, "memset_dummy");
  test_memset(memset_dummy, "memset_stosb");
  test_memset(memset_dummy, "memset_stosb_std");
  test_memset(memset_dummy, "memset_movb");
  test_memset(memset_dummy, "memset_stosq");
  test_memset(memset_dummy, "memset_movq");
  test_memset(memset_dummy, "memset_avx");
  test_memset(memset_dummy, "memset_avx2");

  return EXIT_SUCCESS;
}
