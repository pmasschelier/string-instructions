global copy

section .text
copy:
.loop:
	vmovdqa xmm0, [rsi]
	vmovdqa [rdi], xmm0
	add rsi, 16
	add rdi, 16
	sub rdx, 16
	test rdx, rdx
	jnz .loop
	ret
