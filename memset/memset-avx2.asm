
global set

section .text
; void *set(rdi: void s[.n], rsi: int c, rdx: size_t n);
set:
	shr rdx, 5					; Divide n by 32
	mov rax, rdi				; rax = s
	movzx ecx, sil				; Copy sil in ecx with zero-extend
	vmovd xmm1, ecx				; Copy ecx in xmm1[0:31]
	vpbroadcastb ymm0, xmm1		; Broadcast the first byte of xmm1 to all ymm0
.loop:
	vmovdqa [rdi], ymm0			; Copy the 32 bytes of ymm0 to s
	add rdi, 0x20               ; Increment rdi of 32 bytes
	sub rdx, 1					; Decrement rdx
	test rdx, rdx				; if(rdx != 0)
	jnz .loop					;	 jump
	ret							; return s
