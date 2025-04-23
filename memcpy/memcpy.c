void memcpy_dummy(void *dest, void *src, unsigned long n) {
  for (int i = 0; i < n; i++) {
    *((char *)dest++) = *((char *)src++);
  }
}
