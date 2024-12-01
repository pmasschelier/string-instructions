global count

; Define load_byte which uses movzx if MOV_VERSION is defined and lodsb otherwise
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
	xor edx, edx	; rdx = 0
	xor ecx, ecx	; rcx = 0
	xchg rdi, rsi	; exchange rsi and rdi
	load_byte		; ax = *(rsi++)
	test al, al		; if(al == 0)
	jz .exit		; 	return 0
.loop:
	cmp al, dil		; if(eax == c)
	sete cl			;	 cl = 1
	add edx, ecx	; edx += cl
	load_byte		; ax = *(rsi++)
	test al, al		; if(eax != 0)
	jnz .loop		; 	loop
.exit:
	mov eax, edx	; return edx
	ret

