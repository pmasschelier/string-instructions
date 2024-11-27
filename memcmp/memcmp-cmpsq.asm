global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	mov rcx, rdx		; rcx = n
	shr rcx, 3			; rcx = n / 8
	xor rax, rax		; Set return value to zero
	xor rdx, rdx
	repe cmpsq			; for(; rcx != 0 and ZF == true; rcx += 8)
						;	cmp *(rsi++), *(rdi++)
	mov r8, [rdi - 8]	; Read again the previous quadword of s1
	mov r9, [rsi - 8]	; Read again the previous quadword of s2
	bswap r8			; Convert r8 to big-endian for lexical comparison
	bswap r9			; Convert r9 to big-endian for lexical comparison
	cmp r8, r9			; Lexical comparison of quadwords
	seta al				; if (r8 > r9) al = 1
	setb dl				; if (r8 < r9) dl = 1
	sub eax, edx		; return eax - edx
	ret
