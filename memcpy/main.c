#ifdef STD_VERSION
#include <string.h>
#define copy memcpy
#elif defined(DUMMY_VERSION)
void __attribute__((optimize("O2"))) copy(void *dest, void *src,
                                          unsigned long n) {
  for (int i = 0; i < n; i++) {
    *((char *)dest++) = *((char *)src++);
  }
}
#else
void copy(void *dest, void *src, unsigned long n);
#endif /* ifdef ASM_VERSION */

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

int main(void) {
  copy(dst, src, bigfile_size);
  if (*((unsigned int *)&dst[bigfile_size] - 1) != 0x000A4141)
    return -1;
  return 0;
}
