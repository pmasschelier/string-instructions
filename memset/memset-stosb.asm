global set

section .text
set:
	mov rcx, rdx
	mov eax, esi
	rep stosb
	ret
