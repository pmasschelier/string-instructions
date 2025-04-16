#include <b63/b63.h>
#include <string.h>

#include "b63/register.h"
#include "memcmp.h"

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

B63_BASELINE(standard, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += memcmp(dst, src, bigfile_size);
  B63_KEEP(ret);
}

B63_BENCHMARK(cmpsb, n) {
  for (int i = 0; i < n; i++)
    memcmp_cmpsb(dst, src, bigfile_size);
}

B63_BENCHMARK(cmpsq, n) {
  for (int i = 0; i < n; i++)
    memcmp_cmpsq(dst, src, bigfile_size);
}

B63_BENCHMARK(avx, n) {
  for (int i = 0; i < n; i++)
    memcmp_avx(dst, src, bigfile_size);
}

B63_BENCHMARK(avx2, n) {
  for (int i = 0; i < n; i++)
    memcmp_avx2(dst, src, bigfile_size);
}

B63_BENCHMARK(vpcmpestri, n) {
  for (int i = 0; i < n; i++)
    memcmp_vpcmpestri(dst, src, bigfile_size);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
