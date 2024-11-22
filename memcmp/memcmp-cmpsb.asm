global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	mov rcx, rdx	; rcx = n
	xor rax, rax	; Set return value to zero
	xor rdx, rdx
	repe cmpsb		; for(; rcx != 0 and ZF == true; rcx--)
					;	cmp *(rsi++), *(rdi++)
	setb al			; if(ZF == false and CF == true) al = 1
	seta dl			; if(ZF == false and CF == false) bl = 1
	sub eax, edx	; return al - bl
	ret
