global count

section .text
; unsigned int count(rdi: const char *s, rsi: char c)
count:
	xor eax, eax					; Reset the count
	vpxor ymm0, ymm0, ymm0			; Fill xmm0 with 0x00

	; Broadcast the sil byte to all bytes of xmm0
	movzx ecx, sil					; Copy sil in eax with zero-extend
	vmovd xmm1, ecx					; Copy the low dword (eax) into xmm0
	vpbroadcastb ymm1, xmm1			; Broadcast the first byte of xmm0 to all xmm0
.loop:
	vmovdqa ymm2, [rdi]				; Read 16 bytes from s
	add rdi, 0x20

	; Look for a 0x00 byte
	vpcmpeqb ymm3, ymm2, ymm0		; Test for 0x00 bytes
	vpmovmskb edx, ymm3				; Get a bitmask of 0x00 bytes
	test edx, edx					; If found goto end
	jnz .end

	; Look for the sil byte count
	vpcmpeqb ymm3, ymm2, ymm1		; Test for c byte
	vpmovmskb edx, ymm3				; Get a bitmask of c bytes
	popcnt edx, edx
	add eax, edx

	jmp .loop

.end:
	bsf ecx, edx					; Get the index of the first 0x00 byte
	jz .exit						; If it is the first one return
	shl ecx, 3						; Convert it to a bit index

	mov r8, -1						; r8 = 0xFFFFFFFFFFFFFFFF
	mov rdx, r8						; rdx = 0xFFFFFFFFFFFFFFFF
	xor r9d, r9d					; r9 = 0x0000000000000000
	shl rdx, cl						; rdx = 0b1...10...0 with cl % 64 zeroes (all zeroes if cl > 64)
	not rdx							; rdx = 0b0...01...1 with cl % 64 ones (all zeroes if cl > 64)
	test ecx, 0x40					; if(ecx & 0b100'0000)
	cmovz r8, rdx					;	 r8 = rdx
	cmovnz r9, rdx					; else r9 = rdx

	mov rdx, -1
	xor r10d, r10d
	xor r11d, r11d

	test ecx, 0x80					; if(ecx & 0b1000'0000) ie ecx > 128
	cmovnz r10, r8					;	 r10 = r8
	cmovnz r11, r9					; 	 r11 = r9
	cmovnz r8, rdx					; 	 r8 = 0b1...1
	cmovnz r9, rdx					; 	 r9 = 0b1...1
	vmovq xmm3, r8					; ymm3 = r8
	vmovq xmm4, r9					; ymm4 = r9
	vmovq xmm5, r10					; ymm5 = r10
	vmovq xmm6, r11					; ymm6 = r11
	vpunpcklqdq ymm3, ymm3, ymm4	; ymm3 = r9 | r8 
	vpunpcklqdq ymm5, ymm5, ymm6	; ymm5 = r11 | r10
	vperm2i128 ymm3, ymm3, ymm5, 0x20	; ymm3 = r11 | r10 | r9 | r8

	vpand ymm2, ymm2, ymm3			; Zero out false bytes

	; Look for the sil byte count
	vpcmpeqb ymm3, ymm2, ymm1		; Test for c byte
	vpmovmskb edx, ymm3				; Get a bitmask of c bytes
	popcnt edx, edx
	add eax, edx

.exit:
	ret
