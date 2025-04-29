#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <tap.h>

#include "strlen.h"

#define STRLEN1 1
const char str1[STRLEN1] = "";
#define STRLEN2 2
const char str2[STRLEN2] = "T";
#define STRLEN3 3
const char str3[STRLEN3] = "Th";
#define STRLEN4 4
const char str4[STRLEN4] = "Thi";
#define STRLEN5 23
const char str5[STRLEN5] = "This is a short string";
#define STRLEN6 36
const char str6[STRLEN6] = "This is a not very long test string";
#define STRLEN7 71
const char str7[STRLEN7] =
    "This is a not even a string this a looooong text that no one will read";

void test_strlen(size_t (*fn)(const char *), const char *str,
                 const size_t strlen, const char *fmt) {
  size_t len = fn(str);
  cmp_ok(len, "==", strlen - 1, fmt);
}

int main(int argc, char *argv[]) {
  plan(49);

  test_strlen(strlen, str1, STRLEN1, "Standard strlen function (empty)");
  test_strlen(strlen, str2, STRLEN2, "Standard strlen function (1-length)");
  test_strlen(strlen, str3, STRLEN3, "Standard strlen function (2-length)");
  test_strlen(strlen, str4, STRLEN4, "Standard strlen function (3-length)");
  test_strlen(strlen, str5, STRLEN5, "Standard strlen function (short)");
  test_strlen(strlen, str6 + 3, STRLEN6 - 3,
              "Standard strlen function (partial)");
  test_strlen(strlen, str7, STRLEN7, "Standard strlen function (long)");

  test_strlen(strlen_dummy, str1, STRLEN1, "strlen_dummy function (empty)");
  test_strlen(strlen_dummy, str2, STRLEN2, "strlen_dummy function (1-length)");
  test_strlen(strlen_dummy, str3, STRLEN3, "strlen_dummy function (2-length)");
  test_strlen(strlen_dummy, str4, STRLEN4, "strlen_dummy function (3-length)");
  test_strlen(strlen_dummy, str5, STRLEN5, "strlen_dummy function (short)");
  test_strlen(strlen_dummy, str6 + 3, STRLEN6 - 3,
              "strlen_dummy function (partial)");
  test_strlen(strlen_dummy, str7, STRLEN7, "strlen_dummy function (long)");

  test_strlen(strlen_scasb, str1, STRLEN1, "strlen_scasb function (empty)");
  test_strlen(strlen_scasb, str2, STRLEN2, "strlen_scasb function (1-length)");
  test_strlen(strlen_scasb, str3, STRLEN3, "strlen_scasb function (2-length)");
  test_strlen(strlen_scasb, str4, STRLEN4, "strlen_scasb function (3-length)");
  test_strlen(strlen_scasb, str5, STRLEN5, "strlen_scasb function (short)");
  test_strlen(strlen_scasb, str6 + 3, STRLEN6 - 3,
              "strlen_scasb function (partial)");
  test_strlen(strlen_scasb, str7, STRLEN7, "strlen_scasb function (long)");

  test_strlen(strlen_movq, str1, STRLEN1, "strlen_movq function (empty)");
  test_strlen(strlen_movq, str2, STRLEN2, "strlen_movq function (1-length)");
  test_strlen(strlen_movq, str3, STRLEN3, "strlen_movq function (2-length)");
  test_strlen(strlen_movq, str4, STRLEN4, "strlen_movq function (3-length)");
  test_strlen(strlen_movq, str5, STRLEN5, "strlen_movq function (short)");
  test_strlen(strlen_movq, str6 + 3, STRLEN6 - 3,
              "strlen_movq function (partial)");
  test_strlen(strlen_movq, str7, STRLEN7, "strlen_movq function (long)");

  test_strlen(strlen_avx, str1, STRLEN1, "strlen_avx function (empty)");
  test_strlen(strlen_avx, str2, STRLEN2, "strlen_avx function (1-length)");
  test_strlen(strlen_avx, str3, STRLEN3, "strlen_avx function (2-length)");
  test_strlen(strlen_avx, str4, STRLEN4, "strlen_avx function (3-length)");
  test_strlen(strlen_avx, str5, STRLEN5, "strlen_avx function (short)");
  test_strlen(strlen_avx, str6 + 3, STRLEN6 - 3,
              "strlen_avx function (partial)");
  test_strlen(strlen_avx, str7, STRLEN7, "strlen_avx function (long)");

  test_strlen(strlen_avx2, str1, STRLEN1, "strlen_avx2 function (empty)");
  test_strlen(strlen_avx2, str2, STRLEN2, "strlen_avx2 function (1-length)");
  test_strlen(strlen_avx2, str3, STRLEN3, "strlen_avx2 function (2-length)");
  test_strlen(strlen_avx2, str4, STRLEN4, "strlen_avx2 function (3-length)");
  test_strlen(strlen_avx2, str5, STRLEN5, "strlen_avx2 function (short)");
  test_strlen(strlen_avx2, str6 + 3, STRLEN6 - 3,
              "strlen_avx2 function (partial)");
  test_strlen(strlen_avx2, str7, STRLEN7, "strlen_avx2 function (long)");

  test_strlen(strlen_sse2, str1, STRLEN1, "strlen_sse2 function (empty)");
  test_strlen(strlen_sse2, str2, STRLEN2, "strlen_sse2 function (1-length)");
  test_strlen(strlen_sse2, str3, STRLEN3, "strlen_sse2 function (2-length)");
  test_strlen(strlen_sse2, str4, STRLEN4, "strlen_sse2 function (3-length)");
  test_strlen(strlen_sse2, str5, STRLEN5, "strlen_sse2 function (short)");
  test_strlen(strlen_sse2, str6 + 3, STRLEN6 - 3,
              "strlen_sse2 function (partial)");
  test_strlen(strlen_sse2, str7, STRLEN7, "strlen_sse2 function (long)");

  return EXIT_SUCCESS;
}
