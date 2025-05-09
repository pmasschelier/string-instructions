#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <tap.h>

#include "memcmp.h"

#define STRLEN1 70
#define STRLEN2 35
#define STRLEN3 35
#define STRLEN4 35
#define STRLEN5 70
#define STRLEN6 4

const char src1[STRLEN1] =
    "This is a not very long test string used as a base case for the tests";
const char src2[STRLEN2] = "This is a not very long test string";
const char src3[STRLEN3] = "This is a not very lona test string";
const char src4[STRLEN4] = "This is a not very wong test string";
const char src5[STRLEN5] =
    "is a longer string but with l is lower than n so it will stop earlier";
const char src6[STRLEN6] = "Hhis";

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

void test_memcmp(int fn(const void *s1, const void *s2, size_t n),
                 const char *name) {
  int ret;
  // Standard memcmp
  ret = fn(src1, src2, STRLEN2);
  cmp_ok(ret, "==", 0, "%s function (equal)", name);
  ret = fn(src1, src3, STRLEN3);
  cmp_ok(ret, ">", 0, "%s function (superior)", name);
  ret = fn(src1, src4, STRLEN4);
  cmp_ok(ret, "<", 0, "%s function (inferior)", name);
  ret = fn(src1, src4, 0);
  cmp_ok(ret, "==", 0, "%s function (empty)", name);
  ret = fn(src1 + 3, src2 + 3, STRLEN4 - 3);
  cmp_ok(ret, "==", 0, "%s function (partial)", name);
  ret = fn(src1 + 5, src5, STRLEN1 - 5);
  cmp_ok(ret, ">", 0, "%s function (partial long)", name);
  ret = fn(src1 + 1, src6 + 1, STRLEN6 - 1);
  cmp_ok(ret, "==", 0, "%s function (short)", name);
  ret = fn(src1 + 1, src6 + 1, STRLEN6 - 1);
  cmp_ok(ret, "==", 0, "%s function (short)", name);
  ret = fn(src, dst, bigfile_size);
  cmp_ok(ret, ">", 0, "%s function (bigfile)", name);
}

int main(int argc, char *argv[]) {
  plan(72);

  test_memcmp(memcmp, "Standard memcmp");
  test_memcmp(memcmp_dummy, "memcmp_dummy");
  test_memcmp(memcmp_cmpsb, "memcmp_cmpsb");
  test_memcmp(memcmp_cmpsq_unaligned, "memcmp_cmpsq_unaligned");
  test_memcmp(memcmp_cmpsq, "memcmp_cmpsq");
  test_memcmp(memcmp_avx, "memcmp_avx");
  test_memcmp(memcmp_avx2, "memcmp_avx2");
  test_memcmp(memcmp_vpcmpestri, "memcmp_vpcmpestri");

  return EXIT_SUCCESS;
}
