global len

section .text
; size_t len(rdi: const char *s)
len:
	xor eax, eax
	mov rcx, -1
	repnz scasb		; for(; rcx != 0 and ZF == false; rcx--)
					;	cmp rax, *(rdi++)
	not rcx			; before this insn rcx = - (len(rdi) + 2)
	dec rcx			; after this insn rcx = ~(- (len(rdi) + 2)) - 1
					;                     = -(- (len(rdi) + 2)) - 1 - 1
					;                     = len(rdi)
	xchg rax, rcx	; rax = len(rdi)
	ret
