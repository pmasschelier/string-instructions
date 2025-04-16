global strlen_scasb
global strlen_vec64
global strlen_avx
global strlen_avx2
global strlen_sse2

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

; size_t strlen_vec64(rdi: const char *s)
strlen_vec64:
	mov rax, -8			; rax = -8
	mov rdx, [rdi]		; rdx = *s
	and rdi, -8			; align rsi on 8 bytes
.loop:
	add rax, 0x8			; rax += 8
	add rdi, 0x8			; rsi += 8
	mov rcx, rdx		; rcx = rdx
	not rdx				; rdx = ~rdx
	sub rcx, [.one_vec]	; substract 1 from each byte of rcx
	and rcx, rdx		; rcx &= rdx
	mov rdx, [rdi]		; rdx = *rsi
	and rcx, [.mask]	; test all sign bits
	jz .loop			; zero byte found ?
.end:
	bsf rcx, rcx	; find right-most set sign bit
	shr rcx, 3		; divide by 8 = byte index
	add rax, rcx	; rax += rcx
	ret
.one_vec: dq 0x0101010101010101
.mask: dq 0x8080808080808080 		

; size_t strlen_avx(rdi: const char *s)
strlen_avx:
	mov rax, -16		; rax = -16
	vpxor xmm0, xmm0	; xmm0 = 0
	vmovdqu xmm1, [rdi] ; xmm1 = *(rdi)
	and rdi, -16		; align rdi on 16 bytes
.loop:
	add rax, 0x10		; rax += 16
	add rdi, 0x10		; rdi += 16
	vpcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	vpmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	vmovdqa xmm1, [rdi]	; xmm1 = *(rdi)
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	ret

; size_t strlen_avx2(rdi: const char *s)
strlen_avx2:
	mov rax, -32		; rax = -32
	vpxor ymm0, ymm0	; ymm0 = 0
	vmovdqu ymm1, [rdi]	; ymm1 = *(rdi)
	and rdi, -32		; align rdi on 32 bytes
.loop:
	add rax, 0x20		; rax += 32
	add rdi, 0x20		; rdi += 32
	vpcmpeqb ymm1, ymm0	; ymm1 = byte_mask(i => ymm1[i] == ymm0[i])
	vpmovmskb edx, ymm1	; edx = bitmask(i => sign(ymm1[i]))
	vmovdqa ymm1, [rdi]	; ymm1 = *(rdi)
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	vzeroupper
	ret

; size_t strlen_sse2(rdi: const char *s)
strlen_sse2:
	mov rax, -16		; rax = -16
	pxor xmm0, xmm0	; xmm0 = 0
	movdqu xmm1, [rdi] ; xmm1 = *(rdi)
	and rdi, -16		; align rdi on 16 bytes
.loop:
	add rax, 0x10		; rax += 16
	add rdi, 0x10		; rdi += 16
	pcmpeqb xmm1, xmm0	; xmm1 = byte_mask(i => xmm1[i] == xmm0[i])
	pmovmskb edx, xmm1	; edx = bitmask(i => sign(xmm1[i]))
	movdqa xmm1, [rdi]	; xmm1 = *(rdi)
	test edx, edx		; if(edx == 0)
	jz .loop			; 	goto .loop
.end:
	bsf edx, edx		; edx = index of the first set bit in edx
	add rax, rdx		; rax += rdx
	ret

