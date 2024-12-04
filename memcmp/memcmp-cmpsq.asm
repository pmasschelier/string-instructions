global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	push rbx
	mov rcx, rdx		; rcx = n
	and rdx, (8 - 1)	; rdx = n % 8
	shr rcx, 3			; rcx = n / 8
	xor eax, eax		; Set return value to zero
	xor ebx, ebx
	repe cmpsq			; for(; rcx != 0 and ZF == true; rcx += 8)
						;	cmp *(rsi++), *(rdi++)
	je .end 			; If no difference was found jump to end
	sub rdi, 8
	sub rsi, 8
	mov rdx, -1
	jmp .result
.end:
	mov ecx, edx		; rcx = n % 8
	shl ecx, 3			; rcx *= 8

	mov rdx, -1
	shl rdx, cl
	not rdx

.result:
	mov r8, [rdi]	; Read again the previous quadword of s1
	mov r9, [rsi]	; Read again the previous quadword of s2
	and r8, rdx
	and r9, rdx
	bswap r8			; Convert r8 to big-endian for lexical comparison
	bswap r9			; Convert r9 to big-endian for lexical comparison

	cmp r8, r9			; Lexical comparison of quadwords
	seta al				; if (r8 > r9) al = 1
	setb bl				; if (r8 < r9) dl = 1
	sub eax, ebx		; return eax - edx
.exit:
	pop rbx
	ret
