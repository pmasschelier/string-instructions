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

int main(int argc, char *argv[]) {
  int ret;
  plan(49);

  // Standard memcmp
  ret = memcmp(src1, src2, STRLEN2);
  ok(ret == 0, "Standard memcmp function (equal)");
  ret = memcmp(src1, src3, STRLEN3);
  ok(ret == 1, "Standard memcmp function (superior)");
  ret = memcmp(src1, src4, STRLEN4);
  ok(ret == -1, "Standard memcmp function (inferior)");
  ret = memcmp(src1, src4, 0);
  ok(ret == 0, "Standard memcmp function (empty)");
  ret = memcmp(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "Standard memcmp function (partial)");
  ret = memcmp(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "Standard memcmp function (partial long)");
  ret = memcmp(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "Standard memcmp function (short)");

  // memcmp_dummy
  ret = memcmp_dummy(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_dummy function (equal)");
  ret = memcmp_dummy(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_dummy function (superior)");
  ret = memcmp_dummy(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_dummy function (inferior)");
  ret = memcmp_dummy(src1, src4, 0);
  ok(ret == 0, "memcmp_dummy function (empty)");
  ret = memcmp_dummy(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_dummy function (partial)");
  ret = memcmp_dummy(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_dummy function (partial long)");
  ret = memcmp_dummy(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_dummy function (short)");

  // memcmp_cmpsb
  ret = memcmp_cmpsb(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_cmpsb function (equal)");
  ret = memcmp_cmpsb(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_cmpsb function (superior)");
  ret = memcmp_cmpsb(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_cmpsb function (inferior)");
  ret = memcmp_cmpsb(src1, src4, 0);
  ok(ret == 0, "memcmp_cmpsb function (empty)");
  ret = memcmp_cmpsb(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_cmpsb function (partial)");
  ret = memcmp_cmpsb(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_cmpsb function (partial long)");
  ret = memcmp_cmpsb(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_cmpsb function (short)");

  // memcmp_cmpsq
  ret = memcmp_cmpsq(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_cmpsq function (equal)");
  ret = memcmp_cmpsq(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_cmpsq function (superior)");
  ret = memcmp_cmpsq(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_cmpsq function (inferior)");
  ret = memcmp_cmpsq(src1, src4, 0);
  ok(ret == 0, "memcmp_cmpsq function (empty)");
  ret = memcmp_cmpsq(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_cmpsq function (partial)");
  ret = memcmp_cmpsq(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_cmpsq function (partial long)");
  ret = memcmp_cmpsq(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_cmpsq function (short)");

  // memcmp_avx
  ret = memcmp_avx(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_avx function (equal)");
  ret = memcmp_avx(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_avx function (superior)");
  ret = memcmp_avx(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_avx function (inferior)");
  ret = memcmp_avx(src1, src4, 0);
  ok(ret == 0, "memcmp_avx function (empty)");
  ret = memcmp_avx(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_avx function (partial)");
  ret = memcmp_avx(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_avx function (partial long)");
  ret = memcmp_avx(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_avx function (short)");

  // memcmp_avx2
  ret = memcmp_avx2(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_avx2 function (equal)");
  ret = memcmp_avx2(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_avx2 function (superior)");
  ret = memcmp_avx2(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_avx2 function (inferior)");
  ret = memcmp_avx2(src1, src4, 0);
  ok(ret == 0, "memcmp_avx2 function (empty)");
  ret = memcmp_avx2(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_avx2 function (partial)");
  ret = memcmp_avx2(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_avx2 function (partial long)");
  ret = memcmp_avx2(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_avx2 function (short)");

  // memcmp_vpcmpestri
  ret = memcmp_vpcmpestri(src1, src2, STRLEN2);
  ok(ret == 0, "memcmp_vpcmpestri function (equal)");
  ret = memcmp_vpcmpestri(src1, src3, STRLEN3);
  ok(ret == 1, "memcmp_vpcmpestri function (superior)");
  ret = memcmp_vpcmpestri(src1, src4, STRLEN4);
  ok(ret == -1, "memcmp_vpcmpestri function (inferior)");
  ret = memcmp_vpcmpestri(src1, src4, 0);
  ok(ret == 0, "memcmp_vpcmpestri function (empty)");
  ret = memcmp_vpcmpestri(src1 + 3, src2 + 3, STRLEN4 - 3);
  ok(ret == 0, "memcmp_vpcmpestri function (partial)");
  ret = memcmp_vpcmpestri(src1 + 5, src5, STRLEN1 - 5);
  ok(ret == 1, "memcmp_vpcmpestri function (partial long)");
  ret = memcmp_vpcmpestri(src1 + 1, src6 + 1, STRLEN6 - 1);
  ok(ret == 0, "memcmp_vpcmpestri function (short)");

  return EXIT_SUCCESS;
}
