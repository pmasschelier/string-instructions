#ifndef MEMCPY_ASM_H
#define MEMCPY_ASM_H

#include <stddef.h>

void memcpy_movsb(void *restrict dst, const void *restrict src, size_t n);
void memcpy_movsq(void *restrict dst, const void *restrict src, size_t n);
void memcpy_movsb_std(void *restrict dst, const void *restrict src, size_t n);
void memcpy_avx(void *restrict dst, const void *restrict src, size_t n);
void memcpy_avx2(void *restrict dst, const void *restrict src, size_t n);

#endif // !MEMCPY_ASM_H
