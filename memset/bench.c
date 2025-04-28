#include <b63/b63.h>
#include <string.h>

#include "memset.h"

extern char bigfile[];
extern unsigned int bigfile_size;

B63_BASELINE(standard, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(dummy, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_dummy(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(stosb, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_stosb(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(stosq, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_stosq(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(movb, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_movb(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(movq, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_movq(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_avx(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx2, n) {
  void *ret;
  for (int i = 0; i < n; i++)
    ret = memset_avx2(bigfile, 0xAF, bigfile_size);
  B63_KEEP(ret);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
