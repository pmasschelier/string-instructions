#include <b63/b63.h>
#include <stdint.h>
#include <string.h>

#include "strchr.h"

extern char bigfile[];
extern unsigned int bigfile_size;

B63_BASELINE(standard, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(dummy, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_dummy(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(lodsb, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_lodsb(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(losq, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_lodsq(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(movb, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_movb(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(movq, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_movq(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_avx(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx2, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_avx2(bigfile, 0xA);
  B63_KEEP(ret);
}

B63_BENCHMARK(sse2, n) {
  uintptr_t ret = 0;
  for (int i = 0; i < n; i++)
    ret ^= (uintptr_t)strchr_sse2(bigfile, 0xA);
  B63_KEEP(ret);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
