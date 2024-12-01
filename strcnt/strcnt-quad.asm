global count

; This macro takes a register or 64 bits value as parameter
; After the function:
; - r8 has all bits null except the sign bit of the bytes which are null in the given value
; - r9 is the bitwise not of the given value
; For instance if %1 = 0xFFFF00FF00FF00FF
; After calling the macro r8 = 0x0000800080008000
%macro find_zero 1
	mov r8, %1
	mov r9, %1
	sub r8, [.one_mask]
	not r9
	and r8, r9
	and r8, [.sign_mask]
%endmacro

; Define load_quad which uses mov if MOV_VERSION is defined and lodsq otherwise
%ifdef MOV_VERSION
%macro load_quad 0 
	mov rax, qword [rsi]
	add rsi, 8
%endmacro
%else
%macro load_quad 0 
	lodsq
	%endmacro
%endif

section .text
; unsigned int count(rdi: const char *s, rsi: char c)
count:
	xor edx, edx			; rdx = 0
	movzx eax, sil			; eax = sil
	mul qword [.one_mask]	; rax *= 0x0101010101010101
	mov rsi, rdi			; rsi = s
	mov rdi, rax			; rdi = rax
.loop:
	load_quad				; rax = *(rsi++)
	find_zero rax			; Set r8 as a sign bit mask for null bytes in rax
	jnz .end				; If one of the bytes is null break
	xor rax, rdi			; XOR rax with c * 0x0101010101010101 to nullify the bytes equal to c
	find_zero rax			; Set r8 as a sign bit mask for null bytes in rax
	popcnt rcx, r8			; Count the null bytes
	add rdx, rcx			; rdx += pop count
	jmp .loop				; loop
.end:
	test r8, 0xFF			; if the first byte of r8 is null
	jz .exit				; return rdx
	bsf rcx, r8				; Put the index of the first set bit of r8 in ecx
	and ecx, -8				; ecx = (ecx >> 3) << 3
	mov r9, -1				; r9 = 0xFFFFFFFFFFFFFFFF
	shl r9, cl				; r9 = 0x1...10...0 with cl zeroes
	not r9					; r9 = 0x0...01...1 with cl ones
	and rax, r9				; Mask false bytes of the last loaded quadword
	xor rax, rdi			; XOR rax with c * 0x0101010101010101 to nullify the bytes equal to c
	find_zero rax			; Set r8 as a sign bit mask for null bytes in rax
	popcnt rcx, r8			; Count the null bytes
	add rdx, rcx			; rdx += pop count
.exit:
	mov eax, edx			; return edx
	ret
align 8
.one_mask: dq 0x0101010101010101
.sign_mask: dq 0x8080808080808080
