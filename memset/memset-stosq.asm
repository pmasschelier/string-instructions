global set

section .text
set:
	xor rax, rax
	shr rdx, 3
	mov rcx, rdx
	and esi, 0xFF
	mov rax, 0x0101010101010101
	mul rsi 
	rep stosq
	ret
