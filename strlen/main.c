#ifdef STD_VERSION
#include <string.h>
#define len strlen
#elif defined(DUMMY_VERSION)

unsigned int __attribute__((optimize("O1"))) len(const char *src) {
  unsigned int size = 0;
  while (*(src++) != 0)
    size++;
  return size;
}
#else
unsigned int len(const char *src);
#endif /* ifdef ASM_VERSION */

extern char bigfile_start[];
extern unsigned int bigfile_size;

int main(void) {
  int n = len(bigfile_start);
  if (n != bigfile_size - 1)
    return -1;
  return 0;
}
