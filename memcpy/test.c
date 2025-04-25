#include <string.h>
#include <tap.h>

#include "memcpy.h"

#define STRLEN1 35
#define STRLEN2 9
#define STRLEN3 2

const char src1[STRLEN1] = "This is a not very long test string";
char dst1[STRLEN1];

const char str2[STRLEN2] = "AAAAAAAA";
const char src2[STRLEN2] = "Hi there";
char dst2[STRLEN2] = "AAAAAAAA";

const char str3[STRLEN1] = "That is a not very long test string";
const char src3[STRLEN3] = "at";
char dst3[STRLEN1];

int main(int argc, char *argv[]) {
  void *ret;
  plan(54);

  // Standard memcpy
  memset(dst1, 0, STRLEN1);
  ret = memcpy(dst1, src1, STRLEN1);
  is(dst1, src1, "Standard memcpy function");
  ok(ret == dst1, "Standard memcpy function (retval)");

  ret = memcpy(dst2, src2, 0);
  is(dst2, str2, "Standard memcpy function (0-length)");
  ok(ret == dst2, "Standard memcpy function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "Standard memcpy function (partial)");
  ok(ret == (dst3 + 2), "Standard memcpy function (partial) (retval)");

  // memcpy_dummy
  memset(dst1, 0, STRLEN1);
  ret = memcpy_dummy(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_dummy function");
  ok(ret == dst1, "memcpy_dummy function (retval)");

  ret = memcpy_dummy(dst2, src2, 0);
  is(dst2, str2, "memcpy_dummy function (0-length)");
  ok(ret == dst2, "memcpy_dummy function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_dummy(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_dummy function (partial)");
  ok(ret == (dst3 + 2), "memcpy_dummy function (partial) (retval)");

  // memcpy_movsb
  memset(dst1, 0, STRLEN1);
  ret = memcpy_movsb(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_movsb function");
  ok(ret == dst1, "memcpy_movsb function (retval)");

  ret = memcpy_movsb(dst2, src2, 0);
  is(dst2, str2, "memcpy_movsb function (0-length)");
  ok(ret == dst2, "memcpy_movsb function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_movsb(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_movsb function (partial)");
  ok(ret == (dst3 + 2), "memcpy_movsb function (partial) (retval)");

  // memcpy_movsq
  memset(dst1, 0, STRLEN1);
  ret = memcpy_movsq(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_movsq function");
  ok(ret == dst1, "memcpy_movsq function (retval)");

  ret = memcpy_movsq(dst2, src2, 0);
  is(dst2, str2, "memcpy_movsq function (0-length)");
  ok(ret == dst2, "memcpy_movsq function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_movsq(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_movsq function (partial)");
  ok(ret == (dst3 + 2), "memcpy_movsq function (partial) (retval)");

  // memcpy_movsb_std
  memset(dst1, 0, STRLEN1);
  ret = memcpy_movsb_std(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_movsb_std function");
  ok(ret == dst1, "memcpy_movsb_std function (retval)");

  ret = memcpy_movsb_std(dst2, src2, 0);
  is(dst2, str2, "memcpy_movsb_std function (0-length)");
  ok(ret == dst2, "memcpy_movsb_std function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_movsb_std(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_movsb_std function (partial)");
  ok(ret == (dst3 + 2), "memcpy_movsb_std function (partial) (retval)");

  // memcpy_movb
  memset(dst1, 0, STRLEN1);
  ret = memcpy_movb(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_movb function");
  ok(ret == dst1, "memcpy_movb function (retval)");

  ret = memcpy_movb(dst2, src2, 0);
  is(dst2, str2, "memcpy_movb function (0-length)");
  ok(ret == dst2, "memcpy_movb function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_movb(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_movb function (partial)");
  ok(ret == (dst3 + 2), "memcpy_movb function (partial) (retval)");

  // memcpy_movq
  memset(dst1, 0, STRLEN1);
  ret = memcpy_movq(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_movq function");
  ok(ret == dst1, "memcpy_movq function (retval)");

  ret = memcpy_movq(dst2, src2, 0);
  is(dst2, str2, "memcpy_movq function (0-length)");
  ok(ret == dst2, "memcpy_movq function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_movq(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_movq function (partial)");
  ok(ret == (dst3 + 2), "memcpy_movq function (partial) (retval)");

  // memcpy_avx
  memset(dst1, 0, STRLEN1);
  ret = memcpy_avx(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_avx function");
  ok(ret == dst1, "memcpy_avx function (retval)");

  ret = memcpy_avx(dst2, src2, 0);
  is(dst2, str2, "memcpy_avx function (0-length)");
  ok(ret == dst2, "memcpy_avx function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_avx(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_avx function (partial)");
  ok(ret == (dst3 + 2), "memcpy_avx function (partial) (retval)");

  // memcpy_avx2
  memset(dst1, 0, STRLEN1);
  ret = memcpy_avx2(dst1, src1, STRLEN1);
  is(dst1, src1, "memcpy_avx2 function");
  ok(ret == dst1, "memcpy_avx2 function (retval)");

  ret = memcpy_avx2(dst2, src2, 0);
  is(dst2, str2, "memcpy_avx2 function (0-length)");
  ok(ret == dst2, "memcpy_avx2 function (0 - length) (retval)");

  memcpy(dst3, src1, STRLEN1);
  ret = memcpy_avx2(dst3 + 2, src3, STRLEN3);
  is(dst3, str3, "memcpy_avx2 function (partial)");
  ok(ret == (dst3 + 2), "memcpy_avx2 function (partial) (retval)");

  return EXIT_SUCCESS;
}
