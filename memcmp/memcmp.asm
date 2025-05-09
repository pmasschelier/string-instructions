global memcmp_cmpsb
global memcmp_cmpsq_unaligned
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

; int memcmp_cmpsq_unaligned(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_cmpsq_unaligned:
	lea rcx, [rdx + 0x7]	; rcx = n
	and rdx, (8 - 1)		; rdx = n % 8
	shr rcx, 3				; rcx = n / 8
	xor eax, eax			; rax = 0
	repe cmpsq				; for(; rcx != 0 and ZF == true; rcx += 8)
							;	cmp *(rsi++), *(rdi++)
    je .exit                ; If no difference was found return
	mov r8, [rdi - 0x8]	    ; Read the last (unaligned) quadword of s1
	mov r9, [rsi - 0x8]	    ; Read the last (unaligned) quadword of s2
    test rcx, rcx           ; if(rcx != 0)
    jnz .cmp                ;    goto .cmp
    shl rdx, 3              ; rdx = 8 * (8 - n % 8)
    jz .cmp                 ; if(rdx == 0) goto .cmp
    bzhi r8, r8, rdx        ; r8 <<= 8 * (8 - n % 8)
    bzhi r9, r9, rdx        ; r9 <<= 8 * (8 - n % 8)
.cmp:
	bswap r8				; Convert r8 to big-endian for lexical comparison
	bswap r9				; Convert r9 to big-endian for lexical comparison
	cmp r8, r9				; Lexical comparison of quadwords
	seta al					; if (r8 > r9) al = 1
	setb cl					; if (r8 < r9) cl = 1
	sub eax, ecx			; return eax - ecx
.exit:
	ret

; int memcmp_cmpsq(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_cmpsq:
	xor eax, eax				; rax = 0
    mov rcx, rdx    			; rcx = n
	shr rcx, 3					; rcx = n / 8
    cmpsq                       ; Compare first quadword (increments rsi and rdi)
    jne .end                    ; If quadwords differ jump to .end
    mov rax, rsi                ; rax = s2
    and rax, -8                 ; rax = align(s2, 8)
    sub rax, rsi                ; rax = - (s2 - align(s2, 8))
    add rdx, 8                  ; rdx = n - 8
    sub rdx, rax                ; rdx = n - 8 + (s2 - align(s2, 8))
    add rsi, rax                ; rsi = s2 - (s2 - align(s2, 8))
    add rdi, rax                ; rdi = s1 - (s2 - align(s2, 8))
	xor eax, eax				; rax = 0
	repe cmpsq					; for(; rcx != 0 and ZF == true; rcx += 8)
								;	cmp *(rsi++), *(rdi++)
    je .exit
.end:
	mov r8, [rdi - 0x8]	        ; Read the last quadword of s1
	mov r9, [rsi - 0x8]	        ; Read the last quadword of s2
    test rcx, rcx               ; if(rcx != 0)
    jnz .cmp                    ;    goto .cmp
    and rdx, (8 - 1)            ; rdx = (n - 8 + (s2 - align(s2, 8))) % 8
    mov rcx, 8                  ; rcx = 8
    sub rcx, rdx                ; rcx -= rdx
    shl rcx, 3                  ; rcx *= 8
    shl r8, cl                  ; r8 <<= cl
    shl r9, cl                  ; r9 <<= cl
.cmp:
    xor ecx, ecx                ; rcx = 0
	bswap r8					; Convert r8 to big-endian for lexical comparison
	bswap r9					; Convert r9 to big-endian for lexical comparison
	cmp r8, r9					; Lexical comparison of quadwords
	seta al						; if (r8 > r9) al = 1
	setb cl						; if (r8 < r9) cl = 1
	sub eax, ecx				; return eax - ecx
.exit:
	ret

; int memcmp_avx(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
memcmp_avx:
	xor eax, eax					; rax = 0
	test rdx, rdx					; if(n == 0)
	jz .exit						;	 return 0
	vmovdqu xmm2, [rdi]				; xmm2 = *(rsi)
	vmovdqu xmm3, [rsi]				; xmm3 = *(rdi)
	vpcmpeqb xmm0, xmm2, xmm3		; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])
	vpmovmskb r8d, xmm0				; Create a mask from the most significant bit of each byte
	cmp r8d, 0xFFFF					; if(xmm2 != xmm3)
	jne .end						; 	 goto .end
    lea rcx, [rdi + 15]
    and rcx, -16                    ; rcx = align((src + 15), 16)
    sub rcx, rdi                    ; rcx = align((src + 15), 16) - src
    sub rdx, rcx                     ; rdx = src + n - align((src + 15), 16)
.loop:
	vmovdqa xmm2, [rdi + rcx]		; xmm2 = rdi[rcx]
	vmovdqu xmm3, [rsi + rcx]		; xmm3 = rsi[rcx]
	vpcmpeqb xmm0, xmm2, xmm3		; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])
	vpmovmskb r8d, xmm0				; Create a mask from the most significant bit of each byte
    add rcx, 0x10
	cmp r8d, 0xFFFF					; if(xmm2 != xmm3)
	jne .end						; 	 goto .end
    cmp rdx, 0x10
	jb .end						; if(rcx != 0) goto .loop
    sub rdx, 0x10
    jmp .loop
.end:
	vpcmpgtb xmm1, xmm2, xmm3		; xmm1 = byte_mask(i => xmm2[i] > xmm3[i])
	vpmovmskb r9d, xmm1				; Create a mask from the most significant bit of each byte
	not r8w							; r8w = bitmask(i => xmm2[i] != xmm3[i])
	test r8w, r8w
	jz .exit
	bsf ecx, r8d					; ecx = index of first differing bytes in xmm1/2
    cmp ecx, edx
    jae .exit

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
	xor eax, eax				; rax = 0
	test rdx, rdx				; if(n == 0)
	jz .exit					;	 return 0
	vmovdqu ymm2, [rdi]			; ymm2 = *(rsi)
	vmovdqu ymm3, [rsi]			; ymm3 = *(rdi)
	vpcmpeqb ymm0, ymm2, ymm3	; ymm0 = byte_mask(i => ymm2[i] == ymm3[i])
	vpmovmskb r8d, ymm0			; Create a mask from the most significant bit of each byte
	cmp r8d, 0xFFFFFFFF			; if(ymm2 != ymm3)
	jne .end					; 	 goto .end
    lea rcx, [rdi + 31]
    and rcx, -32                ; rcx = align((src + 15), 16)
    sub rcx, rdi                ; rcx = align((src + 15), 16) - src
    sub rdx, rcx                ; rdx = src + n - align((src + 15), 16)
.loop:
	vmovdqa ymm2, [rdi + rcx]	; ymm2 = rdi[rcx]
	vmovdqu ymm3, [rsi + rcx]	; ymm3 = rsi[rcx]
	vpcmpeqb ymm0, ymm2, ymm3	; ymm0 = byte_mask(i => ymm2[i] == ymm3[i])
	vpmovmskb r8d, ymm0			; Create a mask from the most significant bit of each byte
    add rcx, 0x20               ; rcx += 32
	cmp r8d, 0xFFFFFFFF			; if(ymm2 != ymm3)
	jne .end					; 	 goto .end
    cmp rdx, 0x20               ; if(rcx < 32)
	jb .end						;    goto .end
    sub rdx, 0x20               ; rdx -= 32
    jmp .loop
.end:
	vpcmpgtb ymm1, ymm2, ymm3	; ymm1 = byte_mask(i => ymm2[i] > ymm3[i])
	vpmovmskb r9d, ymm1			; Create a mask from the most significant bit of each byte
	not r8d						; r8w = bitmask(i => ymm2[i] != ymm3[i])
	test r8d, r8d
	jz .exit
	bsf ecx, r8d				; ecx = index of first differing bytes in xmm1/2
    cmp ecx, edx
    jae .exit
	shr r9d, cl					; Find the corresponding bit in r9d	

	xor edx, edx
	test r9d, 0x1				; If it is set
	setnz al					;	 return 1
	setz dl						; else
	sub eax, edx				;	 return -1
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
    xor r10d, r10d
	xor r8d, r8d				; r8 = 0
	xor r9d, r9d				; r9 = 0
	mov rax, rdx				; rax = n
	test rdx, rdx				; if(n == 0)
	jz .exit					;	 return 0
	vmovdqu xmm2, [rdi]			; xmm2 = *rdi
	vmovdqu xmm3, [rsi]			; xmm3 = *rsi

	; Compare xmm2 and xmm3 for equality and write the index of the differing byte in ecx
    ; rax contains the length of the xmm2 string, rdx contains the length of the xmm3 string
	; If all byte are the same rcx = 16
	vpcmpestri xmm2, xmm3, BYTEWISE_CMP 
	test cx, 0x10				; if(rcx != 16)
	jz .end						; 	break
    lea r10, [rdi + 15]         ; r10 = s1 + 15
    and r10, -16                ; r10 = align(s1 + 15, 16)
    sub r10, rdi                ; rdi = s1 - align(s1 + 15, 16)
    sub rdx, r10                ; rdx = n - (s1 - align(s1 + 15, 16))
.loop:
	vmovdqa xmm2, [rdi + r10]			; xmm2 = rdi[r10]
	vmovdqu xmm3, [rsi + r10]			; xmm3 = rsi[r10]

	; Compare xmm2 and xmm3 for equality and write the index of the differing byte in ecx
    ; rax contains the length of the xmm2 string, rdx contains the length of the xmm3 string
	; If all byte are the same rcx = 16
	vpcmpestri xmm2, xmm3, BYTEWISE_CMP 
	test cx, 0x10				; if(rcx != 16)
	jz .end						; 	break

	add r10, 0x10				; r10 += 10

	sub rdx, 0x10				; rdx -= 16
	ja .loop					; if(rdx > 0) goto .loop
	xor eax, eax				; rax = 0
	ret							; return
.end:
	xor eax, eax				; rax = 0
    cmp rcx, rdx                ; if(index >= rdx)
    jae .exit                   ;    return;
	xor edx, edx				; rdx = 0
    add r10, rcx
	mov r8b, [rdi + r10]		; r8b = rdi[rcx]
	mov r9b, [rsi + r10]		; r9b = rsi[rcx]
	cmp r8b, r9b				; if(r8b > r9b)
	seta al						; 	return 1
	setb dl						; else
	sub eax, edx				; 	return -1
.exit:
	ret
