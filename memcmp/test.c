#include <string.h>
#include <tap.h>

#include "memcmp.h"

#define STRLEN 35

const char src1[STRLEN] __attribute__((aligned(32))) =
    "This is a not very long test string";
const char src2[STRLEN] __attribute__((aligned(32))) =
    "This is a not very long test string";
const char src3[STRLEN] __attribute__((aligned(32))) =
    "This is a not very lona test string";
const char src4[STRLEN] __attribute__((aligned(32))) =
    "This is a not very wong test string";

int main(int argc, char *argv[]) {
  int ret;
  plan(24);

  // Standard memcmp
  ret = memcmp(src1, src2, STRLEN);
  ok(ret == 0, "Standard memcpy function (equal)");
  ret = memcmp(src1, src3, STRLEN);
  ok(ret == 1, "Standard memcpy function (superior)");
  ret = memcmp(src1, src4, STRLEN);
  ok(ret == -1, "Standard memcpy function (inferior)");
  ret = memcmp(src1, src4, 0);
  ok(ret == 0, "Standard memcpy function (empty)");

  // memcmp_cmpsb
  ret = memcmp_cmpsb(src1, src2, STRLEN);
  ok(ret == 0, "memcmp_cmpsb function (equal)");
  ret = memcmp_cmpsb(src1, src3, STRLEN);
  ok(ret == 1, "memcmp_cmpsb function (superior)");
  ret = memcmp_cmpsb(src1, src4, STRLEN);
  ok(ret == -1, "memcmp_cmpsb function (inferior)");
  ret = memcmp_cmpsb(src1, src4, 0);
  ok(ret == 0, "memcmp_cmpsb function (empty)");

  // memcmp_cmpsq
  ret = memcmp_cmpsq(src1, src2, STRLEN);
  ok(ret == 0, "memcmp_cmpsq function (equal)");
  ret = memcmp_cmpsq(src1, src3, STRLEN);
  ok(ret == 1, "memcmp_cmpsq function (superior)");
  ret = memcmp_cmpsq(src1, src4, STRLEN);
  ok(ret == -1, "memcmp_cmpsq function (inferior)");
  ret = memcmp_cmpsq(src1, src4, 0);
  ok(ret == 0, "memcmp_cmpsq function (empty)");

  // memcmp_avx
  ret = memcmp_avx(src1, src2, STRLEN);
  ok(ret == 0, "memcmp_avx function (equal)");
  ret = memcmp_avx(src1, src3, STRLEN);
  ok(ret == 1, "memcmp_avx function (superior)");
  ret = memcmp_avx(src1, src4, STRLEN);
  ok(ret == -1, "memcmp_avx function (inferior)");
  ret = memcmp_avx(src1, src4, 0);
  ok(ret == 0, "memcmp_avx function (empty)");

  // memcmp_avx2
  ret = memcmp_avx2(src1, src2, STRLEN);
  ok(ret == 0, "memcmp_avx2 function (equal)");
  ret = memcmp_avx2(src1, src3, STRLEN);
  ok(ret == 1, "memcmp_avx2 function (superior)");
  ret = memcmp_avx2(src1, src4, STRLEN);
  ok(ret == -1, "memcmp_avx2 function (inferior)");
  ret = memcmp_avx2(src1, src4, 0);
  ok(ret == 0, "memcmp_avx2 function (empty)");

  // memcmp_vpcmpestri
  ret = memcmp_vpcmpestri(src1, src2, STRLEN);
  ok(ret == 0, "memcmp_vpcmpestri function (equal)");
  ret = memcmp_vpcmpestri(src1, src3, STRLEN);
  ok(ret == 1, "memcmp_vpcmpestri function (superior)");
  ret = memcmp_vpcmpestri(src1, src4, STRLEN);
  ok(ret == -1, "memcmp_vpcmpestri function (inferior)");
  ret = memcmp_vpcmpestri(src1, src4, 0);
  ok(ret == 0, "memcmp_vpcmpestri function (empty)");

  return EXIT_SUCCESS;
}
