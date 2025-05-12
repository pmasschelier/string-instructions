#ifndef STRLEN_ASM_H
#define STRLEN_ASM_H

#include <stddef.h>

size_t strlen_dummy(const char *s);
size_t strlen_scasb(const char *s);
size_t strlen_movb(const char *s);
size_t strlen_movq(const char *s);
size_t strlen_avx(const char *s);
size_t strlen_avx2(const char *s);
size_t strlen_sse2(const char *s);

#endif // !STRLEN_ASM_H
