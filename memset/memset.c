#include <string.h>

#define BUF_LEN 1024

unsigned char dest[BUF_LEN];

int main(void) {
  memset(dest, 0xAF, BUF_LEN);
  return 0;
}
