global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	mov rcx, rdx	; rcx = n
	shr rcx, 3		; rcx = n / 8
	xor rax, rax	; Set return value to zero
	xor rdx, rdx
	repe cmpsq		; for(; rcx != 0 and ZF == true; rcx += 8)
					;	cmp *(rsi++), *(rdi++)
	mov r8, [rdi - 8]
	mov r9, [rsi - 8]
	bswap r8
	bswap r9
	cmp r8, r9
	seta al
	setb dl
	sub eax, edx
	ret
