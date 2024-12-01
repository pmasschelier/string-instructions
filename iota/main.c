#ifdef STD_VERSION
void __attribute__((optimize("O3"))) iota(void *dest, unsigned long n) {
  for (int i = 0; i < n; i++) {
    *((char *)dest++) = i & 0xFF;
  }
}
#elif defined(DUMMY_VERSION)
void __attribute__((optimize("O1"))) iota(void *dest, unsigned long n) {
  for (int i = 0; i < n; i++) {
    *((char *)dest++) = i & 0xFF;
  }
}
#else
void iota(void *dest, unsigned long n);
#endif

extern char dst[];
extern unsigned int bigfile_size;

int main(void) {
  iota(dst, bigfile_size);

  // Check that the copy executed correctly by
  // checking the last four bytes of dst
  if (*((unsigned int *)&dst[bigfile_size] - 1) != 0xFFFEFDFC)
    return 1;
  return 0;
}
