PACKED_UBYTE 			equ	0b00
PACKED_UWORD 			equ	0b00
PACKED_BYTE 			equ	0b00
PACKED_WORD 			equ	0b00
CMP_STR_EQU_ANY 		equ	(0b00 << 2)
CMP_STR_EQU_RANGES 		equ	(0b01 << 2)
CMP_STR_EQU_EACH 		equ	(0b10 << 2)
CMP_STR_EQU_ORDERED		equ	(0b11 << 2)
CMP_STR_INV_ALL			equ	(0b01 << 4)
CMP_STR_INV_VALID_ONLY	equ (0b11 << 4)
CMP_STR_FIND_LSB_SET	equ (0b00 << 6)
CMP_STR_FIND_MSB_SET	equ (0b01 << 6)

BYTEWISE_CMP equ (PACKED_UBYTE | CMP_STR_EQU_EACH | CMP_STR_INV_ALL | CMP_STR_FIND_LSB_SET)

global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	push rbx
	xor ebx, ebx				; rax = 0

	test rdx, rdx				; if(n == 0)
	jz .exit					;	 return 0

	mov rax, rdx
.loop:
	vmovdqa xmm2, [rdi]			; xmm2 = *rdi
	vmovdqa xmm3, [rsi]			; xmm3 = *rsi

	add rdi, 0x10				; rdi++
	add rsi, 0x10				; rsi++

	; Compare xmm2 and xmm3 bytewise
	vpcmpestri xmm2, xmm3, BYTEWISE_CMP ; Compare xmm2 and xmm3 for equality and write the index of the differing byte in ecx
	jbe .end 					; If the second string ends (ie. rdx < 16) jump to end

	sub rdx, 0x10				; n -= 16
	jmp .loop					; If all bytes are equals (ie IntRes2 == 0) jump to loop
.end:
	test rdx, rdx
	jz .exit

	cmp rcx, rdx
	jae .exit

	vmovd xmm0, ecx				; Use the byte index as a shuffle_mask
	vpshufb xmm2, xmm2, xmm0	; Put the byte found at index 0
	vpshufb xmm3, xmm3, xmm0	; Put the byte found at index 0
	vmovd ebx, xmm2				; eax = xmm2
	vmovd edx, xmm3				; ebx = xmm3

	sub ebx, edx				; return xmm2 - xmm3

.exit:
	mov rax, rbx
	pop rbx
	ret
