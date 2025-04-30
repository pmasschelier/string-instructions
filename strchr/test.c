#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <tap.h>

#include "strchr.h"

const size_t STRLEN1 = 35;
const char src1[] = "This is a not very long test string";

const size_t STRLEN2 = 119;
const char src2[] =
    "This is a longer string and the search letter will be near from the end "
    "(tip: it is the last letter of the alphabet): z";

int main(int argc, char *argv[]) {
  char *ret;
  plan(45);

  ret = strchr("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "Standard strchr function (empty)");
  ret = strchr(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "Standard strchr function (found)");
  ret = strchr(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "Standard strchr function (not found)");
  ret = strchr(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "Standard strchr function (found '\\0')");
  ret = strchr(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "Standard strchr function (found z)");

  ret = strchr_dummy("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_dummy function (empty)");
  ret = strchr_dummy(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_dummy function (found)");
  ret = strchr_dummy(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_dummy function (not found)");
  ret = strchr_dummy(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_dummy function (found '\\0')");
  ret = strchr_dummy(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_dummy function (found z)");

  ret = strchr_lodsb("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_lodsb function (empty)");
  ret = strchr_lodsb(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_lodsb function (found)");
  ret = strchr_lodsb(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_lodsb function (not found)");
  ret = strchr_lodsb(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_lodsb function (found '\\0')");
  ret = strchr_lodsb(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_lodsb function (found z)");

  ret = strchr_movb("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_movb function (empty)");
  ret = strchr_movb(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_movb function (found)");
  ret = strchr_movb(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_movb function (not found)");
  ret = strchr_movb(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_movb function (found '\\0')");
  ret = strchr_movb(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_movb function (found z)");

  ret = strchr_lodsq("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_lodsq function (empty)");
  ret = strchr_lodsq(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_lodsq function (found)");
  ret = strchr_lodsq(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_lodsq function (not found)");
  ret = strchr_lodsq(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_lodsq function (found '\\0')");
  ret = strchr_lodsq(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_lodsq function (found z)");

  ret = strchr_movq("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_movq function (empty)");
  ret = strchr_movq(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_movq function (found)");
  ret = strchr_movq(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_movq function (not found)");
  ret = strchr_movq(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_movq function (found '\\0')");
  ret = strchr_movq(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_movq function (found z)");

  ret = strchr_avx("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_avx function (empty)");
  ret = strchr_avx(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_avx function (found)");
  ret = strchr_avx(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_avx function (not found)");
  ret = strchr_avx(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_avx function (found '\\0')");
  ret = strchr_avx(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_avx function (found z)");

  ret = strchr_avx2("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_avx2 function (empty)");
  ret = strchr_avx2(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_avx2 function (found)");
  ret = strchr_avx2(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_avx2 function (not found)");
  ret = strchr_avx2(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_avx2 function (found '\\0')");
  ret = strchr_avx2(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_avx2 function (found z)");

  ret = strchr_sse2("", 'i');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_sse2 function (empty)");
  ret = strchr_sse2(src1, 'n');
  cmp_ok(ret - src1, "==", 10, "strchr_sse2 function (found)");
  ret = strchr_sse2(src1, 'z');
  cmp_ok((uintptr_t)ret, "==", 0, "strchr_sse2 function (not found)");
  ret = strchr_sse2(src1, '\0');
  cmp_ok(ret - src1, "==", STRLEN1, "strchr_sse2 function (found '\\0')");
  ret = strchr_sse2(src2 + 5, 'z');
  cmp_ok(ret - src2, "==", STRLEN2 - 1, "strchr_sse2 function (found z)");

  return EXIT_SUCCESS;
}
