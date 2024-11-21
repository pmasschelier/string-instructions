global copy

section .text
copy:
	mov rcx, rdx
	rep movsb
	ret
