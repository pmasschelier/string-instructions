#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <tap.h>

#include "memcpy.h"

#define STRLEN1 35

const char empty[1024];

const char src1[STRLEN1] = "This is a not very long test string";
char dst1[STRLEN1];

#define STRLEN2 9
const char str2[STRLEN2] = "AAAAAAAA";
const char src2[STRLEN2] = "Hi there";
char dst2[STRLEN2] = "AAAAAAAA";

#define STRLEN3 2
const char str3[STRLEN1] = "That is a not very long test string";
const char src3[STRLEN3] = "at";
char dst3[STRLEN1];

#define STRLEN4 106
#define STRLEN5 125
char str4[STRLEN5] =
    "This is a modified string after the memcpy I hope there will be no "
    "overflow of the buffer.. 'done' after colon   : done";
const char src4[STRLEN4] =
    " a modified string after the memcpy I hope there will be no overflow of "
    "the buffer.. 'done' after colon   ";
const char src5[STRLEN5] =
    "This is a longer string intended to be modified for testing purpose this "
    "shouldn't modify after the colon however: done";
char dst4[STRLEN5];

char buffer[1024];
void test_memcpy(void *(*fn)(void *restrict, const void *restrict, size_t),
                 void *restrict dst, size_t dstlen, size_t offset,
                 const void *restrict src, size_t srclen,
                 const void *restrict initial, const void *restrict expected,
                 const char *name) {

  void *ret;
  memcpy(dst, initial, dstlen);
  ret = fn(dst3 + offset, src, srclen);
  is(dst, expected, name);
  snprintf(buffer, 1024, "%s (retval)", name);
  ok(ret == (dst + offset), buffer);
}

int main(int argc, char *argv[]) {
  void *ret;
  plan(72);

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "Standard memcpy function (long partial)");
  ok(ret == (dst4 + 7), "Standard memcpy function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_dummy(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_dummy function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_dummy function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_movsb(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_movsb function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_movsb function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_movsq(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_movsq function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_movsq function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_movsb_std(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_movsb_std function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_movsb_std function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_movb(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_movb function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_movb function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_movq(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_movq function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_movq function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_avx(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_avx function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_avx function (long partial) (retval)");

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

  memcpy(dst4, src5, STRLEN5);
  ret = memcpy_avx2(dst4 + 7, src4, STRLEN4);
  is(dst4, str4, "memcpy_avx2 function (long partial)");
  ok(ret == (dst4 + 7), "memcpy_avx2 function (long partial) (retval)");

  return EXIT_SUCCESS;
}
