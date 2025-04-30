global iota_stosb
global iota_stosq
global iota_movb
global iota_movq
global iota_avx
global iota_avx2

%macro store_movb 0
	mov [rdi], al
	add rdi, 0x1
%endmacro

%macro iota_byte 1
	xor eax, eax
	mov rcx, rsi
	test rcx, rcx
	jz %%exit
%%loop:
    %1
	add rax, 0x1
	sub rcx, 0x1
	jnz %%loop
%%exit:
	ret
%endmacro

%macro store_movq 0
	mov [rdi], rax
	add rdi, 0x8
%endmacro

%macro iota_quad 1
	mov r8, 0x0706050403020100
	mov r9, 0x0808080808080808
	mov rax, r8
	cmp rsi, 8
	jb %%end
%%loop:
    %1
	add rax, r9
	test al, al
	cmovz rax, r8
    sub rsi, 0x8
	cmp rsi, 0x8
	jae %%loop
%%end:
;     cmp rsi, 0x4
;     jb %%word
;     mov [rdi], eax
;     add rdi, 0x4
;     sub rsi, 0x4
;     shr rax, 32
; %%word:
;     cmp rsi, 0x2
;     jb %%byte
;     mov [rdi], ax
;     add rdi, 0x2
;     sub rsi, 0x2
;     shr rax, 16
; %%byte:
;     test rsi, rsi
;     jz %%exit
;     mov [rdi], al
; %%exit:
    ret
%endmacro

section .text
; void *iota_stosb(rdi: unsigned char s[.n], rsi: size_t n);
iota_stosb:
    iota_byte stosb

; void *iota_movb(rdi: unsigned char s[.n], rsi: size_t n);
iota_movb:
    iota_byte store_movb

; void *iota_stosq(rdi: unsigned char s[.n], rsi: size_t n);
iota_stosq:
    iota_quad stosq

; void *iota_movq(rdi: unsigned char s[.n], rsi: size_t n);
iota_movq:
    iota_quad store_movq

; void *iota_avx(rdi: void s[.n], rsi: size_t n);
iota_avx:
    cmp rsi, 0x10
	jb .exit
	vmovdqa xmm0, [.init_mask]
	vmovdqa xmm1, [.add_mask]
.loop:
	vmovdqu [rdi], xmm0				; Copy the 16 bytes of xmm0 to s
	vpaddb xmm0, xmm0, xmm1
	add rdi, 0x10					; Increment rdi of 16 bytes
	sub rsi, 0x10						; rdx--
    cmp rsi, 0x10
	jae .loop						;	 jump
.exit:
	ret
align 16
.init_mask: db 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF
.add_mask: times 16 db 0x10

; void *iota_avx2(rdi: void s[.n], rsi: size_t n);
iota_avx2:
	shr rsi, 5						; Divide n by 32
	jz .exit
	vmovdqa ymm0, [.init_mask]
	vmovdqa ymm1, [.add_mask]
.loop:
	vmovdqu [rdi], ymm0				; Copy the 16 bytes of xmm0 to s
	vpaddb ymm0, ymm0, ymm1
	add rdi, 0x20					; Increment rdi of 16 bytes
	sub rsi, 1						; rdx--
	jnz .loop						;	 jump
.exit:
	ret
align 32
.init_mask:
	db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
	db 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
.add_mask: times 32 db 0x20
