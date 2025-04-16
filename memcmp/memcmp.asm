global memcmp_cmpsb
global memcmp_cmpsq
global memcmp_avx
global memcmp_avx2
global memcmp_vpcmpestri

section .text
; int memcmp_cmpsb(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_cmpsb:
	mov rcx, rdx	; rcx = n
	xor rax, rax	; Set return value to zero
	xor rdx, rdx
	repe cmpsb		; for(; rcx != 0 and ZF == true; rcx--)
					;	cmp *(rsi++), *(rdi++)
	setb al			; if(ZF == false and CF == true) al = 1
	seta dl			; if(ZF == false and CF == false) bl = 1
	sub eax, edx	; return al - dl
	ret

; int memcmp_cmpsq(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_cmpsq:
	push rbx
	mov rcx, rdx				; rcx = n
	and rdx, (8 - 1)			; rdx = n % 8
	shr rcx, 3					; rcx = n / 8
	xor eax, eax				; Set return value to zero
	xor ebx, ebx        		; rbx = 0
	repe cmpsq					; for(; rcx != 0 and ZF == true; rcx += 8)
								;	cmp *(rsi++), *(rdi++)
	cmovne edx, ebx				; If a difference was found reset rdx
	mov r8, [rdi + rdx - 0x8]	; Read the last (unaligned) quadword of s1
	mov r9, [rsi + rdx - 0x8]	; Read the last (unaligned) quadword of s2
	bswap r8					; Convert r8 to big-endian for lexical comparison
	bswap r9					; Convert r9 to big-endian for lexical comparison

	cmp r8, r9					; Lexical comparison of quadwords
	seta al						; if (r8 > r9) al = 1
	setb bl						; if (r8 < r9) dl = 1
	sub eax, ebx				; return eax - edx
.exit:
	pop rbx
	ret

; int memcmp_avx(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_avx:
	xor eax, eax					; rax = 0

	test rdx, rdx					; if(n == 0)
	jz .exit						;	 return 0
	mov rcx, rdx					; rcx = n
	shr rcx, 4						; rcx = n / 16
	and rdx, (0x10 - 1)				; rdx = n % 16

.loop:
	vmovdqa xmm2, [rdi]				; xmm2 = *(rsi)
	vmovdqa xmm3, [rsi]				; xmm3 = *(rdi)
	vpcmpeqb xmm0, xmm2, xmm3		; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])
	vpmovmskb r8d, xmm0				; Create a mask from the most significant bit of each byte
	add rdi, 0x10					; rdi += 16
	add rsi, 0x10					; rsi += 16
	cmp r8d, 0xFFFF					; if(xmm2 != xmm3)
	jne .end						; 	 goto .end
	sub rcx, 1						; rcx -= 1
	jnz .loop						; if(rcx != 0) goto .loop
.end:
	cmovne edx, eax					; If a difference was found reset edx
	vmovdqu xmm2, [rdi + rdx - 0x10]; Read the last (unaligned) double quadword of s1
	vmovdqu xmm3, [rsi + rdx - 0x10]; Read the last (unaligned) double quadword of s2

	vpcmpeqb xmm0, xmm2, xmm3		; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])
    vpmovmskb r8d, xmm0  	    	; Create a mask from the most significant bit of each byte
	vpcmpgtb xmm1, xmm2, xmm3		; xmm1 = byte_mask(i => xmm2[i] > xmm3[i])
	vpmovmskb r9d, xmm1				; Create a mask from the most significant bit of each byte
	not r8w							; r8w = bitmask(i => xmm2[i] != xmm3[i])
	test r8w, r8w
	jz .exit
	bsf ecx, r8d					; ecx = index of first differing bytes in xmm1/2
	shr r9d, cl						; Find the corresponding bit in r9d	

	xor edx, edx
	test r9d, 0x1					; If it is set
	setnz al						;	 return 1
	setz dl							; else
	sub eax, edx					;	 return -1
.exit:
	ret

; int memcmp_avx2(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_avx2:
	xor eax, eax					; rax = 0

	test rdx, rdx					; if(n == 0)
	jz .exit						;	 return 0
	mov rcx, rdx					; rcx = n
	shr rcx, 5						; rcx = n / 32
	and rdx, (0x20 - 1)				; rdx = n % 32

.loop:
	vmovdqa ymm2, [rdi]				; ymm2 = *(rsi)
	vmovdqa ymm3, [rsi]				; ymm3 = *(rdi)
	vpcmpeqb ymm0, ymm2, ymm3		; ymm0 = byte_mask(i => ymm2[i] == ymm3[i])
	vpmovmskb r8d, ymm0				; Create a mask from the most significant bit of each byte
	add rdi, 0x20					; rdi += 32
	add rsi, 0x20					; rsi += 32
	cmp r8d, 0xFFFFFFFF				; if(ymm2 != ymm3)
	jne .end						; 	 goto .end
	sub rcx, 1						; rcx -= 1
	jnz .loop						; if(rcx != 0) goto .loop
.end:
	cmovne edx, eax					; If a difference was found reset edx
	vmovdqu ymm2, [rdi + rdx - 0x20]; Read the last (unaligned) double quadword of s1
	vmovdqu ymm3, [rsi + rdx - 0x20]; Read the last (unaligned) double quadword of s2

	vpcmpeqb ymm0, ymm2, ymm3		; ymm0 = byte_mask(i => ymm2[i] == ymm3[i])
    vpmovmskb r8d, ymm0  	    	; Create a mask from the most significant bit of each byte
	vpcmpgtb ymm1, ymm2, ymm3		; ymm1 = byte_mask(i => ymm2[i] > ymm3[i])
	vpmovmskb r9d, ymm1				; Create a mask from the most significant bit of each byte
	not r8d							; r8w = bitmask(i => xmm2[i] != xmm3[i])
	test r8d, r8d
	jz .exit
	bsf ecx, r8d					; ecx = index of first differing bytes in xmm1/2
	shr r9d, cl						; Find the corresponding bit in r9d	

	xor edx, edx
	test r9d, 0x1					; If it is set
	setnz al						;	 return 1
	setz dl							; else
	sub eax, edx					;	 return -1
.exit:
	vzeroupper
	ret

PACKED_UBYTE 			equ	0b00
PACKED_UWORD 			equ	0b01
PACKED_BYTE 			equ	0b10
PACKED_WORD 			equ	0b11
CMP_STR_EQU_ANY 		equ	(0b00 << 2)
CMP_STR_EQU_RANGES 		equ	(0b01 << 2)
CMP_STR_EQU_EACH 		equ	(0b10 << 2)
CMP_STR_EQU_ORDERED		equ	(0b11 << 2)
CMP_STR_INV_ALL			equ	(0b01 << 4)
CMP_STR_INV_VALID_ONLY	equ (0b11 << 4)
CMP_STRI_FIND_LSB_SET	equ (0b00 << 6)
CMP_STRI_FIND_MSB_SET	equ (0b01 << 6)
CMP_STRM_BIT_MASK		equ (0b00 << 6)
CMP_STRM_BYTE_MASK	equ (0b01 << 6)

BYTEWISE_CMP equ (PACKED_UBYTE | CMP_STR_EQU_EACH | CMP_STR_INV_VALID_ONLY | CMP_STRI_FIND_LSB_SET)

; int memcmp_vpcmpestri(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_vpcmpestri:
	xor r8d, r8d				; r8 = 0
	xor r9d, r9d				; r9 = 0
	mov rax, rdx				; rax = n
	test rdx, rdx				; if(n == 0)
	jz .exit					;	 return 0
.loop:
	vmovdqa xmm2, [rdi]			; xmm2 = *rdi
	vmovdqa xmm3, [rsi]			; xmm3 = *rsi

	; Compare xmm2 and xmm3 for equality and write the index of the differing byte in ecx
	; If all byte are the same rcx = 16
	vpcmpestri xmm2, xmm3, BYTEWISE_CMP 
	test cx, 0x10				; if(rcx != 16)
	jz .end						; 	break

	add rdi, 0x10				; rdi++
	add rsi, 0x10				; rsi++

	sub rdx, 0x10				; rdx -= 16
	ja .loop					; if(rdx > 0) goto .loop
	xor eax, eax				; rax = 0
	ret							; return
.end:
	xor eax, eax				; rax = 0
	xor edx, edx				; rdx = 0
	mov r8b, [rdi + rcx]		; r8b = rdi[rcx]
	mov r9b, [rsi + rcx]		; r9b = rsi[rcx]
	cmp r8b, r9b				; if(r8b > r9b)
	seta al						; 	return 1
	setb dl						; else
	sub eax, edx				; 	return -1
.exit:
	ret
