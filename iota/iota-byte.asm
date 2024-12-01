global iota

%macro store_byte 0
%ifdef MOV_VERSION
	mov [rdi], al
	add rdi, 0x1
%else
	stosb
%endif
%endmacro

section .text
; void *iota(rdi: void s[.n], rsi: size_t n);
iota:
	xor eax, eax
	mov rcx, rsi
	test rcx, rcx
	jz .exit
.loop:
	store_byte
	add rax, 0x1
	sub rcx, 0x1
	jnz .loop
.exit
	ret
