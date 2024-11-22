#ifdef STD_VERSION
#include <string.h>
#define set memset
#elif defined(DUMMY_VERSION)
void __attribute__((optimize("O1"))) set(void *dest, unsigned int c,
                                         unsigned long n) {
  for (int i = 0; i < n; i++) {
    *((char *)dest++) = (char)c;
  }
}
#else
void set(void *dest, unsigned int c, unsigned long n);
#endif

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

int main(void) {
  set(dst, 0x01AF, bigfile_size);

  // Check that the copy executed correctly by
  // checking the last four bytes of dst
  if (*((unsigned int *)&dst[bigfile_size] - 1) != 0xAFAFAFAF)
    return 1;
  return 0;
}
