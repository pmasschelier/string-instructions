#include <b63/b63.h>

#include "b63/register.h"
#include "iota.h"

extern unsigned char dst[];
extern unsigned int bigfile_size;

B63_BASELINE(dummy, n) {
  for (int i = 0; i < n; i++)
    iota_dummy(dst, bigfile_size);
}

B63_BENCHMARK(stosb, n) {
  for (int i = 0; i < n; i++)
    iota_stosb(dst, bigfile_size);
}

B63_BENCHMARK(stosq, n) {
  for (int i = 0; i < n; i++)
    iota_stosq(dst, bigfile_size);
}

B63_BENCHMARK(movb, n) {
  for (int i = 0; i < n; i++)
    iota_movb(dst, bigfile_size);
}

B63_BENCHMARK(movq, n) {
  for (int i = 0; i < n; i++)
    iota_movq(dst, bigfile_size);
}

B63_BENCHMARK(avx, n) {
  for (int i = 0; i < n; i++)
    iota_avx(dst, bigfile_size);
}

B63_BENCHMARK(avx2, n) {
  for (int i = 0; i < n; i++)
    iota_avx2(dst, bigfile_size);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
