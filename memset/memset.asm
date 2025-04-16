global memset_stosb
global memset_stosq
global memset_avx
global memset_avx2

section .text
; void *memset_stosb(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_stosb:
	mov rcx, rdx	; rcx = n
	movzx eax, sil	; eax = c
	mov rdx, rdi	; rdx = s
	rep stosb		; for(; rcx != 0; rcx--)
					;	 *(rdi++) = al
	mov rax, rdx	; return s
	ret

; void *memset_stosq(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_stosq:
	push rdi				; Stores s on stack
	mov rcx, rdx			; rcx = n
	mov r8, rdx				; r8 = n
	shr rcx, 3				; rcx = n / 8
	and r8, (8 - 1)			; r8 = n % 8
	and esi, 0xFF			; Mask the first byte of esi
	mov rax, [.one_mask]	; Load the multiplication mask
	mul rsi 				; Replicate al in all rax register
	rep stosq				; for(; rcx != 0; rcx -= 1)
							;	 *(rdi++) = rax
	mov [rdi + r8 - 8], rax	; Write the remaining bytes
	pop rax					; return s
	ret
.one_mask: dq 0x0101010101010101

; void *memset_avx(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_avx:
	mov rcx, rdx					; rcx = n
	and rdx, (16 - 1)				; rdx = n % 16
	shr rcx, 4						; rcx = n / 16
	mov rax, rdi					; rax = s
	movzx esi, sil					; Copy sil in eax with zero-extend
	vmovd xmm0, esi					; Copy the low dword (eax) into xmm0
	vpxor xmm1, xmm1				; Load a shuffle mask filled with zero indexes
	vpshufb xmm0, xmm0, xmm1		; Broadcast the first byte of xmm0 to all xmm0 bytes 
.loop:
	vmovdqa [rdi], xmm0				; Copy the 16 bytes of xmm0 to s
	add rdi, 0x10					; Increment rdi of 16 bytes
	sub rcx, 1						; rdx--
	test rcx, rcx					; if(rdx != 0)
	jnz .loop						;	 jump
.end:
	vmovdqu [rdi + rdx - 0x10], xmm0
	ret

; void *memset_avx2(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_avx2:
	mov rcx, rdx					; rcx = n
	and rdx, (32 - 1)				; rdx = n % 32
	shr rcx, 5						; rcx = n / 32
	mov rax, rdi					; rax = s
	movzx esi, sil					; Copy sil in eax with zero-extend
	vmovd xmm1, esi					; Copy the low dword (eax) into xmm0
	vpbroadcastb ymm0, xmm1			; Broadcast the first byte of xmm1 to all ymm0
.loop:
	vmovdqa [rdi], ymm0				; Copy the 32 bytes of ymm0 to s
	add rdi, 0x20					; Increment rdi of 32 bytes
	sub rcx, 1						; rdx--
	test rcx, rcx					; if(rdx != 0)
	jnz .loop						;	 jump
.end:
	vmovdqu [rdi + rdx - 0x20], ymm0
	vzeroupper
	ret
