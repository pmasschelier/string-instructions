#include <b63/b63.h>
#include <string.h>

#include "memcpy.h"

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

B63_BASELINE(standard, n) {
  for (int i = 0; i < n; i++)
    memcpy(dst, src, bigfile_size);
}

B63_BENCHMARK(dummy, n) {
  for (int i = 0; i < n; i++)
    memcpy_dummy(dst, src, bigfile_size);
}

B63_BENCHMARK(movsb, n) {
  for (int i = 0; i < n; i++)
    memcpy_movsb(dst, src, bigfile_size);
}

B63_BENCHMARK(movsb_std, n) {
  for (int i = 0; i < n; i++)
    memcpy_movsb_std(dst, src, bigfile_size);
}

B63_BENCHMARK(movsq, n) {
  for (int i = 0; i < n; i++)
    memcpy_movsq(dst, src, bigfile_size);
}

B63_BENCHMARK(avx, n) {
  for (int i = 0; i < n; i++)
    memcpy_avx(dst, src, bigfile_size);
}

B63_BENCHMARK(avx2, n) {
  for (int i = 0; i < n; i++)
    memcpy_avx2(dst, src, bigfile_size);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
