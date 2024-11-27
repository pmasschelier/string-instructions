global set

section .text
; void *set(rdi: void s[.n], rsi: int c, rdx: size_t n);
set:
	mov rcx, rdx	; rcx = 5
	mov eax, esi	; eax = c
	mov rdx, rdi	; rdx = s
	rep stosb		; for(; rcx != 0; rcx--)
					;	 *(rdi++) = al
	mov rax, rdx	; return s
	ret
