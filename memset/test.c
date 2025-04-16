#include <string.h>
#include <tap.h>

#include "memset.h"

#define BUFLEN 113
char buffer[113];
char base[113];

int main(int argc, char *argv[]) {
  plan(5);
  memset(base, 0xAF, BUFLEN);

  memset(buffer, 0x00, BUFLEN);
  memset(buffer, 0xAF, BUFLEN);
  cmp_mem(buffer, base, BUFLEN, "Standard memset function");

  memset(buffer, 0x00, BUFLEN);
  memset_stosb(buffer, 0xAF, BUFLEN);
  cmp_mem(buffer, base, BUFLEN, "memset_stosb function");

  memset(buffer, 0x00, BUFLEN);
  memset_stosq(buffer, 0xAF, BUFLEN);
  cmp_mem(buffer, base, BUFLEN, "memset_stosq function");

  memset(buffer, 0x00, BUFLEN);
  memset_avx(buffer, 0xAF, BUFLEN);
  cmp_mem(buffer, base, BUFLEN, "memset_avx function");

  memset(buffer, 0x00, BUFLEN);
  memset_avx2(buffer, 0xAF, BUFLEN);
  cmp_mem(buffer, base, BUFLEN, "memset_avx2 function");

  return EXIT_SUCCESS;
}
