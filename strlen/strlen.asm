global strlen_scasb
global strlen_movb
global strlen_movq
global strlen_avx
global strlen_avx2
global strlen_sse2

%include "find_zero.asm"

section .text
; size_t strlen_scasb(rdi: const char *s)
strlen_scasb:
	xor eax, eax	; rax = 0
	mov rcx, -1		; rcx = -1
	repnz scasb		; for(; rcx != 0 and ZF == false; rcx--)
					;	cmp rax, *(rdi++)
	not rcx			; before this insn rcx = - (len(rdi) + 2)
	dec rcx			; after this insn rcx = ~(- (len(rdi) + 2)) - 1
					;                     = -(- (len(rdi) + 2)) - 1 - 1
					;                     = len(rdi)
	mov rax, rcx	; rax = len(rdi)
	ret

; size_t strlen_movb(rdi: const char *s)
strlen_movb:
	xor eax, eax	; rax = 0
.loop:
    movzx rdx, byte [rdi + rax]
    test edx, edx
    jz .end
    add rax, 1
    jmp .loop
.end:
	ret

; size_t strlen_movq(rdi: const char *s)
strlen_movq:
	xor eax, eax            ; rax = s
	mov rdx, [rdi]          ; rdx = *s
    find_zero rcx, rdx
    jnz .end
    mov rax, rdi
	and rax, -8	            ; rax = align(s, 8)
    sub rax, rdi
.loop:
	add rax, 0x8            ; rax += 8
    find_zero rcx, rdx      ; Put 1 in sign bits of rcx bytes where rdx bytes are 0
    mov rdx, [rdi + rax]          ; rdx = *rsi
	jz .loop			    ; zero byte found ?
    sub rax, 8
.end:
	bsf rcx, rcx		    ; find right-most set sign bit
	shr rcx, 3			    ; divide by 8 = byte index
	add rax, rcx		    ; rax += rcx
	ret
.one_vec: dq 0x0101010101010101
.mask: dq 0x8080808080808080 		


; size_t strlen_avx(rdi: const char *s)
strlen_avx:
	xor eax, eax		; rax = -16
	vpxor xmm0, xmm0	; xmm0 = 0
	vmovdqu xmm1, [rdi] ; xmm1 = *(rdi)
	vpcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	vpmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	test edx, edx		; if(edx == 0)
	jnz .end			; 	goto .loop
    mov rax, rdi
	and rax, -16		; align rdi on 16 bytes
    sub rax, rdi
.loop:
	add rax, 0x10		; rax += 16
	vmovdqa xmm1, [rdi + rax]	; xmm1 = *(rdi)
	vpcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	vpmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	ret

; size_t strlen_avx2(rdi: const char *s)
strlen_avx2:
	xor eax, eax		; rax = -32
	vpxor ymm0, ymm0	; ymm0 = 0
	vmovdqu ymm1, [rdi]	; ymm1 = *(rdi)
	vpcmpeqb ymm1, ymm0	; ymm1 = byte_mask(i => ymm1[i] == ymm0[i])
	vpmovmskb edx, ymm1	; edx = bitmask(i => sign(ymm1[i]))
	test edx, edx		; if(edx == 0)
	jnz .end			; 	goto .loop
    mov rax, rdi
	and rax, -32		; align rdi on 16 bytes
    sub rax, rdi
.loop:
	add rax, 0x20		; rax += 32
	vmovdqa ymm1, [rdi + rax]	; ymm1 = *(rdi)
	vpcmpeqb ymm1, ymm0	; ymm1 = byte_mask(i => ymm1[i] == ymm0[i])
	vpmovmskb edx, ymm1	; edx = bitmask(i => sign(ymm1[i]))
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	vzeroupper
	ret

; size_t strlen_sse2(rdi: const char *s)
strlen_sse2:
	xor eax, eax        ; rax = 0
	pxor xmm0, xmm0		; xmm0 = 0
	movdqu xmm1, [rdi]	; xmm1 = *(rdi)
	pcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	pmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	test edx, edx		; if(edx == 0)
	jnz .end			; 	goto .loop
    mov rax, rdi
	and rax, -16		; align rdi on 16 bytes
    sub rax, rdi
.loop:
	add rax, 0x10		; rax += 16
	movdqa xmm1, [rdi + rax]	; xmm1 = *(rdi)
	pcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	pmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	ret

