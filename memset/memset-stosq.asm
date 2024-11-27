global set

section .text
; void *set(rdi: void s[.n], rsi: int c, rdx: size_t n);
set:
	shr rdx, 3				; Divide n by 8
	mov rcx, rdx			; rcx = n / 8
	mov rdx, rdi			; rdx = s
	and esi, 0xFF			; Mask the first byte of esi
	mov rax, [.one_mask]	; Load the multiplication mask
	mul rsi 				; Replicate al in all rax register
	rep stosq				; for(; rcx != 0; rcx -= 1)
							;	 *(rdi++) = rax
	mov rax, rdx			; return s
	ret
.one_mask: dq 0x0101010101010101
