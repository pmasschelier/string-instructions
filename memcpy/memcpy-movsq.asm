global copy

section .text
copy:
	shr rdx, 3
	mov rcx, rdx
	rep movsq
	ret
