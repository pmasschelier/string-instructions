global count

section .text
; unsigned int count(rdi: const char *s, rsi: char c)
count:
	xor eax, eax					; Reset the count
	vpxor xmm0, xmm0, xmm0			; Fill xmm0 with 0x00

	; Broadcast the sil byte to all bytes of xmm0
	movzx ecx, sil					; Copy sil in eax with zero-extend
	vmovd xmm1, ecx					; Copy the low dword (eax) into xmm0
	vpshufb xmm1, xmm1, xmm0		; Broadcast the first byte of xmm0 to all xmm0
.loop:
	vmovdqa xmm2, [rdi]				; Read 16 bytes from s
	add rdi, 16

	; Look for a 0x00 byte
	vpcmpeqb xmm3, xmm2, xmm0		; Test for 0x00 bytes
	vpmovmskb edx, xmm3				; Get a bitmask of 0x00 bytes
	test edx, edx					; If found goto end
	jnz .end

	; Look for the sil byte count
	vpcmpeqb xmm3, xmm2, xmm1		; Test for c byte
	vpmovmskb edx, xmm3				; Get a bitmask of c bytes
	popcnt edx, edx
	add eax, edx

	jmp .loop

.end:
	bsf ecx, edx					; Get the index of the first 0x00 byte
	jz .exit						; If it is the first one return
	shl ecx, 3						; Convert it to a bit index

	mov r8, -1						; r8 = 0xFFFFFFFFFFFFFFFF
	xor r9d, r9d					; r9 = 0x0000000000000000
	shl rdx, cl						; rdx = 0b1...10...0 with cl % 64 zeroes (all zeroes if cl > 64)
	not rdx							; rdx = 0b0...01...1 with cl % 64 ones (all zeroes if cl > 64)
	test ecx, 0x40					; if(ecx & 0b100'0000)
	cmovz r8, rdx					;	 r8 = rdx
	cmovnz r9, rdx					; else r9 = rdx
	vmovq xmm3, r8					; xmm3 = r8
	vmovq xmm4, r9					; xmm4 = r8
	vpunpcklqdq xmm3, xmm3, xmm4	; xmm3 = 0...01...1 with cl ones
	vpand xmm2, xmm2, xmm3			; Zero out false bytes

	; Look for the sil byte count
	vpcmpeqb xmm3, xmm2, xmm1		; Test for c byte
	vpmovmskb edx, xmm3				; Get a bitmask of c bytes
	popcnt edx, edx
	add eax, edx

.exit:
	ret

; 	vpxor xmm0, xmm0, xmm0
; 	mov      rcx, rdi         ; copy pointer
; 	and      rcx,  15         ; lower 4 bits indicate misalignment
; 	jz .L1
; 	and      rdi,  -16        ; align pointer by 16
; 	vmovdqa   xmm1, [rdi]      ; read from nearest preceding boundary
; 	vpcmpeqb  xmm1, xmm0       ; compare 16 bytes with zero
; 	vpmovmskb edx,  xmm1       ; get one bit for each byte result
; 	shr      edx,  cl         ; shift out false bits
; 	shl      edx,  cl         ; shift back again
; 	bsf      ecx,  edx        ; find first 1-bit
;
;
; 	jnz      .L2               ; found
; 	; Main loop, search 16 bytes at a time
; .L1:
; 	add      eax,  16              ; increment pointer by 16
; 	vmovdqa   xmm1, [eax]           ; read 16 bytes aligned
; 	vpcmpeqb  xmm1, xmm0            ; compare 16 bytes with zero
; 	vpmovmskb edx,  xmm1            ; get one bit for each byte result
; 	bsf      edx,  edx             ; find first 1-bit
; 	jz       .L1                    ; loop if not found
; .L2:     ; Zero-byte found. Compute string length
; 	sub      rax,  rdi         ; subtract start address
; 	add      rax,  rdx             ; add byte index
; 	ret
;
; align  16
; .shuffle_mask: times 16 db 0x0
