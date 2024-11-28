#ifdef STD_VERSION
unsigned int __attribute__((optimize("O3"))) count(const char *src, char c) {
  unsigned int cnt = 0;
  for (; *src != 0; src++) {
    if (*src == c)
      cnt++;
  }
  return cnt;
}
#elif defined(DUMMY_VERSION)
unsigned int __attribute__((optimize("O1"))) count(const char *src, char c) {
  unsigned int cnt = 0;
  for (; *src != 0; src++) {
    if (*src == c)
      cnt++;
  }
  return cnt;
}
#else
unsigned int count(const char *src, char c);
#endif

extern char bigfile_start[];
extern unsigned int bigfile_size;

int main(void) {
  const char c = 'A';
  int n = count(bigfile_start, c);

  // Check return of count function
  if (n != (bigfile_size - 2) / 2)
    return 1;
  return 0;
}
