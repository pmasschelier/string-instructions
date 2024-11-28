global count

%macro find_zero 1
	mov r8, %1
	mov r9, %1
	sub r8, [.one_mask]
	not r9
	and r8, r9
	and r8, [.sign_mask]
%endmacro

%ifdef MOV_VERSION
%macro load_quad 0 
	mov rax, quad [rsi]
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
	xor rdx, rdx
	movzx eax, sil
	mul qword [.one_mask]
	mov rsi, rdi
	mov rdi, rax
.loop:
	load_quad
	find_zero rax
	jnz .end
	xor rax, rdi
	find_zero rax
	popcnt rcx, r8
	add rdx, rcx
	jmp .loop
.end:
	test r8, 0xFF
	jz .exit
	bsf rcx, r8
	and ecx, -8
	mov r9, -1
	shl r9, cl
	not r9
	and rax, r9
	xor rax, rdi
	find_zero rax
	popcnt rcx, r8
	add rdx, rcx
.exit:
	mov eax, edx
	ret
align 8
.one_mask: dq 0x0101010101010101
.sign_mask: dq 0x8080808080808080
