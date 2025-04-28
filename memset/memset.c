void *__attribute__((optimize("O1"))) memset_dummy(void *dst, unsigned int c,
                                                   unsigned long n) {
  void *const ret = dst;
  for (int i = 0; i < n; i++)
    *((char *)dst++) = (char)c;
  return ret;
}
