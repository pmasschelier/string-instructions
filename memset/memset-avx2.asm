
global set

section .text
set:
	shr rdx, 5
	and esi, 0xFF
	vmovd xmm1, esi
	vpbroadcastb ymm0, xmm1
.loop:
	vmovdqa [rdi], ymm0
	add rdi, 0x20
	sub rdx, 1
	test rdx, rdx
	jnz .loop
	ret
