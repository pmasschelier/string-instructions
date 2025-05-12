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

B63_BENCHMARK(dummy, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_dummy(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(scasb, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_scasb(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(movb, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_movb(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(movq, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_movq(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_avx(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(avx2, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_avx2(bigfile);
  B63_KEEP(ret);
}

B63_BENCHMARK(sse2, n) {
  int ret = 0;
  for (int i = 0; i < n; i++)
    ret += strlen_sse2(bigfile);
  B63_KEEP(ret);
}

int main(int argc, char *argv[]) {
  B63_RUN(argc, argv);
  return EXIT_SUCCESS;
}
