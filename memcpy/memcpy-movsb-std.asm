global copy

section .text
copy:
	std
	mov rcx, rdx
	sub rdx, 1
	add rdi, rdx
	add rsi, rdx
	rep movsb
	cld
	ret
