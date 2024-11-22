#ifdef STD_VERSION
#include <string.h>
#define compare memcmp
#elif defined(DUMMY_VERSION)
int __attribute__((optimize("O1"))) compare(void *dest, void *src,
                                            unsigned long n) {
  int diff;
  for (int i = 0; i < n; i++) {
    diff = *((char *)dest++) - *((char *)src++);
    if (diff == 0)
      continue;
    if (diff < 0)
      return -1;
    else
      return 1;
  }
  return 0;
}
#else
int compare(void *dest, void *src, unsigned long n);
#endif

extern char src[];
extern char dst[];
extern unsigned int bigfile_size;

int main(void) {
  int res = compare(dst, src, bigfile_size);

  // Check result of comparison
  if (res >= 0)
    return 1;
  return 0;
}
