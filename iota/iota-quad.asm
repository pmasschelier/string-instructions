global iota

%macro store_quad 0
%ifdef MOV_VERSION
	mov [rdi], rax
	add rdi, 0x8
%else
	stosq
%endif
%endmacro

section .text
; void *iota(rdi: void s[.n], rsi: size_t n);
iota:
	mov rcx, rsi
	mov rsi, 0x0706050403020100
	mov rdx, 0x0808080808080808
	mov rax, rsi
	shr rcx, 3
	jz .exit
.loop:
	store_quad
	add rax, rdx
	cmp al, 0x00
	cmove rax, rsi
	sub rcx, 0x1
	jnz .loop
.exit
	ret
