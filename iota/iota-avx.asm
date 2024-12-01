global iota

section .text
; void *iota(rdi: void s[.n], rsi: size_t n);
iota:
	shr rsi, 4						; Divide n by 16
	jz .exit
	vmovdqa xmm0, [.init_mask]
	vmovdqa xmm1, [.add_mask]
.loop:
	vmovdqa [rdi], xmm0				; Copy the 16 bytes of xmm0 to s
	vpaddb xmm0, xmm0, xmm1
	add rdi, 0x10					; Increment rdi of 16 bytes
	sub rsi, 1						; rdx--
	jnz .loop						;	 jump
.exit:
	ret
align 16
.init_mask: db 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF
.add_mask: times 16 db 0x10
