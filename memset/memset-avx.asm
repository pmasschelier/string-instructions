global set

section .text
; void *set(rdi: void s[.n], rsi: int c, rdx: size_t n);
set:
	shr rdx, 4						; Divide n by 16
	mov rax, rdi					; rax = s
	movzx ecx, sil					; Copy sil in eax with zero-extend
	vmovd xmm0, ecx					; Copy the low dword (eax) into xmm0
	vpxor xmm1, xmm1, xmm1			; Load a shuffle mask filled with zero indexes
	vpshufb xmm0, xmm0, xmm1		; Broadcast the first byte of xmm0 to all xmm0
.loop:
	vmovdqa [rdi], xmm0				; Copy the 16 bytes of xmm0 to s
	add rdi, 0x10					; Increment rdi of 16 bytes
	sub rdx, 1						; rdx--
	test rdx, rdx					; if(rdx != 0)
	jnz .loop						;	 jump
	ret
