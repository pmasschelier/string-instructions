#ifndef STRCHR_ASM_H

char *strchr_dummy(const char *s, int c);
char *strchr_lodsb(const char *s, int c);
char *strchr_movb(const char *s, int c);
char *strchr_lodsq(const char *s, int c);
char *strchr_movq(const char *s, int c);
char *strchr_avx(const char *s, int c);
char *strchr_avx2(const char *s, int c);
char *strchr_sse2(const char *s, int c);

#endif // !STRCHR_ASM_H
