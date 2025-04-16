#ifndef MEMCMP_ASM_H
#define MEMCMP_ASM_H

#include <stddef.h>

int memcmp_cmpsb(const void *s1, const void *s2, size_t n);
int memcmp_cmpsq(const void *s1, const void *s2, size_t n);
int memcmp_avx(const void *s1, const void *s2, size_t n);
int memcmp_avx2(const void *s1, const void *s2, size_t n);
int memcmp_vpcmpestri(const void *s1, const void *s2, size_t n);
void test_vpcmpestri();

#endif // !MEMCMP_ASM_H
