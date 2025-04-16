#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <tap.h>

#include "strlen.h"

const size_t STRLEN = 35;

const char src[] = "This is a not very long test string";

int main(int argc, char *argv[]) {
  size_t len;
  plan(12);

  len = strlen("");
  ok(len == 0, "Standard memcmp function (empty)");
  len = strlen(src);
  ok(len == STRLEN, "Standard memcmp function");

  len = strlen_scasb("");
  ok(len == 0, "strlen_scasb function (empty)");
  len = strlen_scasb(src);
  ok(len == STRLEN, "strlen_scasb function");

  len = strlen_vec64("");
  ok(len == 0, "strlen_vec64 function (empty)");
  len = strlen_vec64(src);
  ok(len == STRLEN, "strlen_vec64 function");

  len = strlen_avx("");
  ok(len == 0, "strlen_avx function (empty)");
  len = strlen_avx(src);
  ok(len == STRLEN, "strlen_avx function");

  len = strlen_avx2("");
  ok(len == 0, "strlen_avx2 function (empty)");
  len = strlen_avx2(src);
  ok(len == STRLEN, "strlen_avx2 function");

  len = strlen_sse2("");
  ok(len == 0, "strlen_avx2 function (empty)");
  len = strlen_sse2(src);
  ok(len == STRLEN, "strlen_avx2 function");

  return EXIT_SUCCESS;
}
