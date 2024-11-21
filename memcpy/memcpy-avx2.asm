global copy

section .text
copy:
.loop:
	vmovdqa ymm0, [rsi]
	vmovdqa [rdi], ymm0
	add rsi, 32
	add rdi, 32
	sub rdx, 32
	test rdx, rdx
	jnz .loop
	ret
