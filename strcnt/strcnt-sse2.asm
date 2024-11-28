global len

section .text
; size_t len(rdi: const char *s)
len:
	mov      rax, rdi         ; get pointer to string
	mov      rcx, rdi         ; copy pointer
	pxor     xmm0, xmm0       ; set to zero
	and      rcx,  15         ; lower 4 bits indicate misalignment
	and      rax,  -16        ; align pointer by 16
	movdqa   xmm1, [eax]      ; read from nearest preceding boundary
	pcmpeqb  xmm1, xmm0       ; compare 16 bytes with zero
	pmovmskb edx,  xmm1       ; get one bit for each byte result
	shr      edx,  cl         ; shift out false bits
	shl      edx,  cl         ; shift back again
	bsf      edx,  edx        ; find first 1-bit
	jnz      L2               ; found
	; Main loop, search 16 bytes at a time
L1:
	add      rax,  16              ; increment pointer by 16
	movdqa   xmm1, [rax]           ; read 16 bytes aligned
	pcmpeqb  xmm1, xmm0            ; compare 16 bytes with zero
	pmovmskb edx,  xmm1            ; get one bit for each byte result
	bsf      edx,  edx             ; find first 1-bit
	jz       L1                    ; loop if not found
L2:     ; Zero-byte found. Compute string length
	sub      rax,  rdi         ; subtract start address
	add      rax,  rdx             ; add byte index
	ret
