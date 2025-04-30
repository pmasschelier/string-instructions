#ifndef IOTA_ASM_H
#define IOTA_ASM_H

#include <stddef.h>

void iota_dummy(unsigned char *a, size_t n);
void iota_stosb(unsigned char *a, size_t n);
void iota_stosq(unsigned char *a, size_t n);
void iota_movb(unsigned char *a, size_t n);
void iota_movq(unsigned char *a, size_t n);
void iota_avx(unsigned char *a, size_t n);
void iota_avx2(unsigned char *a, size_t n);

#endif // !IOTA_ASM_H
