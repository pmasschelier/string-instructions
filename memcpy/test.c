#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <tap.h>
#include <unistd.h>

#include "memcpy.h"

#define SRCLEN1 35
#define DSTLEN1 36
const char initial1[DSTLEN1];
const char expected1[DSTLEN1] = "This is a not very long test string";
const char src1[SRCLEN1] = "This is a not very long test string";
char dst1[DSTLEN1];

#define SRCLEN2 8
#define DSTLEN2 9
const char expected2[DSTLEN2] = "AAAAAAAA";
const char src2[SRCLEN2] = "Hi there";
char dst2[DSTLEN2] = "AAAAAAAA";

#define SRCLEN3 2
#define DSTLEN3 36
const char initial3[DSTLEN3] = "This is a not very long test string";
const char expected3[DSTLEN3] = "That is a not very long test string";
const char src3[SRCLEN3] = "at";
char dst3[DSTLEN3];

#define SRCLEN4 106
#define DSTLEN4 120
const char initial4[DSTLEN4] =
    "This is a longer string intended to be modified for testing purpose this "
    "shouldn't modify after the colon however: done";
char expected4[DSTLEN4] =
    "This is a modified string after the memcpy I hope there will be no "
    "overflow of the buffer.. 'done' after colon   : done";
const char src4[SRCLEN4] =
    " a modified string after the memcpy I hope there will be no overflow of "
    "the buffer.. 'done' after colon   ";
char dst4[DSTLEN4];

char buffer[1024];
void test_memcpy(void *(*fn)(void *restrict, const void *restrict, size_t),
                 void *restrict dst, size_t dstlen, size_t offset,
                 const void *restrict src, size_t srclen,
                 const void *restrict initial, const void *restrict expected,
                 const char *name) {

  void *ret;
  if (initial != NULL)
    memcpy(dst, initial, dstlen);
  ret = fn(dst + offset, src, srclen);
  is(dst, expected, name);
  snprintf(buffer, 1024, "%s (retval)", name);
  ok(ret == (dst + offset), buffer);
}

int main(int argc, char *argv[]) {
  plan(72);

  // Standard memcpy
  test_memcpy(memcpy, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1, expected1,
              "Standard memcpy function");
  test_memcpy(memcpy, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "Standard memcpy function (0-length)");
  test_memcpy(memcpy, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3, expected3,
              "Standard memcpy (partial)");
  test_memcpy(memcpy, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4, expected4,
              "Standard memcpy function (long partial)");

  // memcpy_dummy
  test_memcpy(memcpy_dummy, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1,
              expected1, "memcpy_dummy function");
  test_memcpy(memcpy_dummy, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_dummy function (0-length)");
  test_memcpy(memcpy_dummy, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3,
              expected3, "memcpy_dummy (partial)");
  test_memcpy(memcpy_dummy, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4,
              expected4, "memcpy_dummy function (long partial)");

  // memcpy_movsb
  test_memcpy(memcpy_movsb, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1,
              expected1, "memcpy_movsb function");
  test_memcpy(memcpy_movsb, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_movsb function (0-length)");
  test_memcpy(memcpy_movsb, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3,
              expected3, "memcpy_movsb (partial)");
  test_memcpy(memcpy_movsb, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4,
              expected4, "memcpy_movsb function (long partial)");

  // memcpy_movsq
  test_memcpy(memcpy_movsq, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1,
              expected1, "memcpy_movsq function");
  test_memcpy(memcpy_movsq, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_movsq function (0-length)");
  test_memcpy(memcpy_movsq, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3,
              expected3, "memcpy_movsq (partial)");
  test_memcpy(memcpy_movsq, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4,
              expected4, "memcpy_movsq function (long partial)");

  // memcpy_movsb_std
  test_memcpy(memcpy_movsb_std, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1,
              expected1, "memcpy_movsb_std function");
  test_memcpy(memcpy_movsb_std, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_movsb_std function (0-length)");
  test_memcpy(memcpy_movsb_std, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3,
              expected3, "memcpy_movsb_std (partial)");
  test_memcpy(memcpy_movsb_std, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4,
              expected4, "memcpy_movsb_std function (long partial)");

  // memcpy_movb
  test_memcpy(memcpy_movb, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1, expected1,
              "memcpy_movb function");
  test_memcpy(memcpy_movb, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_movb function (0-length)");
  test_memcpy(memcpy_movb, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3, expected3,
              "memcpy_movb (partial)");
  test_memcpy(memcpy_movb, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4, expected4,
              "memcpy_movb function (long partial)");

  // memcpy_movq
  test_memcpy(memcpy_movq, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1, expected1,
              "memcpy_movq function");
  test_memcpy(memcpy_movq, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_movq function (0-length)");
  test_memcpy(memcpy_movq, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3, expected3,
              "memcpy_movq (partial)");
  test_memcpy(memcpy_movq, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4, expected4,
              "memcpy_movq function (long partial)");

  // memcpy_avx
  test_memcpy(memcpy_avx, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1, expected1,
              "memcpy_avx function");
  test_memcpy(memcpy_avx, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_avx function (0-length)");
  test_memcpy(memcpy_avx, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3, expected3,
              "memcpy_avx (partial)");
  test_memcpy(memcpy_avx, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4, expected4,
              "memcpy_avx function (long partial)");

  // memcpy_avx2
  test_memcpy(memcpy_avx2, dst1, DSTLEN1, 0, src1, SRCLEN1, initial1, expected1,
              "memcpy_avx2 function");
  test_memcpy(memcpy_avx2, dst2, DSTLEN2, 0, src2, 0, NULL, expected2,
              "memcpy_avx2 function (0-length)");
  test_memcpy(memcpy_avx2, dst3, DSTLEN3, 2, src3, SRCLEN3, initial3, expected3,
              "memcpy_avx2 (partial)");
  test_memcpy(memcpy_avx2, dst4, DSTLEN4, 7, src4, SRCLEN4, initial4, expected4,
              "memcpy_avx2 function (long partial)");

  return EXIT_SUCCESS;
}
