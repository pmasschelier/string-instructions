#ifndef MEMSET_ASM_H
#define MEMSET_ASM_H

#include <stddef.h>

void *memset_dummy(void *s, int c, size_t n);
void *memset_stosb(void *s, int c, size_t n);
void *memset_stosq(void *s, int c, size_t n);
void *memset_movb(void *s, int c, size_t n);
void *memset_movq(void *s, int c, size_t n);
void *memset_avx(void *s, int c, size_t n);
void *memset_avx2(void *s, int c, size_t n);

#endif // !MEMSET_ASM_H
