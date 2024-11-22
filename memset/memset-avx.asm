global set

section .text
set:
	shr rdx, 4
	movzx eax, sil
	vmovd xmm0, eax				; Copy the low dword (eax) into xmm0
	vmovdqa xmm1, [.shuffle_mask]
	vpshufb xmm0, xmm0, xmm1
.loop:
	vmovdqa [rdi], xmm0
	add rdi, 0x10
	sub rdx, 1
	test rdx, rdx
	jnz .loop
	ret
align 16
.shuffle_mask: times 16 db 0x0
