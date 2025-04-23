#include <string.h>
#include <tap.h>

#include "memcpy.h"

#define STRLEN 35

const char src[STRLEN] = "This is a not very long test string";
char dst[STRLEN];

int main(int argc, char *argv[]) {
  plan(7);

  memset(dst, 0, STRLEN);
  memcpy(dst, src, STRLEN);
  is(dst, src, "Standard memcpy function");

  memset(dst, 0, STRLEN);
  memcpy_dummy(dst, src, STRLEN);
  is(dst, src, "memcpy_dummy function");

  memset(dst, 0, STRLEN);
  memcpy_movsb(dst, src, STRLEN);
  is(dst, src, "memcpy_movsb function");

  memset(dst, 0, STRLEN);
  memcpy_movsq(dst, src, STRLEN);
  is(dst, src, "memcpy_movsq function");

  memset(dst, 0, STRLEN);
  memcpy_movsb_std(dst, src, STRLEN);
  is(dst, src, "memcpy_movsb_std function");

  memset(dst, 0, STRLEN);
  memcpy_avx(dst, src, STRLEN);
  is(dst, src, "memcpy_avx function");

  memset(dst, 0, STRLEN);
  memcpy_avx2(dst, src, STRLEN);
  is(dst, src, "memcpy_avx2 function");

  return EXIT_SUCCESS;
}
