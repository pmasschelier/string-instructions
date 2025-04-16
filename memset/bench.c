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

B63_BENCHMARK(stosb, n) {
  for (int i = 0; i < n; i++)
    memset_stosb(bigfile, 0xAF, bigfile_size);
}

B63_BENCHMARK(stosq, n) {
  for (int i = 0; i < n; i++)
    memset_stosq(bigfile, 0xAF, bigfile_size);
}

B63_BENCHMARK(avx, n) {
  for (int i = 0; i < n; i++)
    memset_avx(bigfile, 0xAF, bigfile_size);
}

B63_BENCHMARK(avx2, n) {
  for (int i = 0; i < n; i++)
    memset_avx2(bigfile, 0xAF, bigfile_size);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
