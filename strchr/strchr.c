char *strchr_dummy(const char *s, int c) {
  do {
    if (*s == c)
      return (char *)s;
  } while (*(s++) != '\0');
  return 0;
}
