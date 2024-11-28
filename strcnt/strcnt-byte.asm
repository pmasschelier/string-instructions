global count

%ifdef MOV_VERSION
%macro load_byte 0 
	movzx eax, byte [rsi]
	add rsi, 1
%endmacro
%else
%macro load_byte 0 
	lodsb
%endmacro
%endif

section .text
; unsigned int count(rdi: const char *s, rsi: char c)
count:
	xor eax, eax
	xor edx, edx
	xor ecx, ecx
	xchg rdi, rsi
	and rdi, 0xff
.loop:
	load_byte
	test eax, eax
	jz .exit
	cmp eax, edi
	sete cl
	add edx, ecx
	jmp .loop
.exit:
	mov eax, edx
	ret

