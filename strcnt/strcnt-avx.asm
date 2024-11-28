default rel

global count

section .text
	; unsigned int count(rdi: const char *s, rsi: char c)
len:
	mov      rax, rdi         ; get pointer to string
	mov      rcx, rdi         ; copy pointer
	vmovdqa  xmm0, [.dqzero]       ; set to zero
	and      rcx,  15         ; lower 4 bits indicate misalignment
	and      rax,  -16        ; align pointer by 16
	vmovdqa   xmm1, [rax]      ; read from nearest preceding boundary
	vpcmpeqb  xmm1, xmm0       ; compare 16 bytes with zero
	vpmovmskb edx,  xmm1       ; get one bit for each byte result
	shr      edx,  cl         ; shift out false bits
	shl      edx,  cl         ; shift back again
	bsf      edx,  edx        ; find first 1-bit
	jnz      .L2               ; found
	; Main loop, search 16 bytes at a time
.L1:
	add      eax,  16              ; increment pointer by 16
	vmovdqa   xmm1, [eax]           ; read 16 bytes aligned
	vpcmpeqb  xmm1, xmm0            ; compare 16 bytes with zero
	vpmovmskb edx,  xmm1            ; get one bit for each byte result
	bsf      edx,  edx             ; find first 1-bit
	jz       .L1                    ; loop if not found
.L2:     ; Zero-byte found. Compute string length
	sub      rax,  rdi         ; subtract start address
	add      rax,  rdx             ; add byte index
	ret

align  16
.dqzero: times 16 db 0x0
