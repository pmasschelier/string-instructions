#include <b63/b63.h>
#include <string.h>

#include "strlen.h"

extern char bigfile[];
extern unsigned int bigfile_size;

B63_BASELINE(standard, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(scasb, n) {
  for (int i = 0; i < n; i++)
    strlen_scasb(bigfile);
}

B63_BENCHMARK(vec64, n) {
  for (int i = 0; i < n; i++)
    strlen_vec64(bigfile);
}

B63_BENCHMARK(avx, n) {
  for (int i = 0; i < n; i++)
    strlen_avx(bigfile);
}

B63_BENCHMARK(avx2, n) {
  for (int i = 0; i < n; i++)
    strlen_avx2(bigfile);
}

B63_BENCHMARK(sse2, n) {
  for (int i = 0; i < n; i++)
    strlen_sse2(bigfile);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
