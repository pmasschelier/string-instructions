default rel

global len

section .text
; size_t len(rdi: const char *s)
len:
	mov      rax, rdi			; get pointer to string
	mov      rcx, rdi			; copy pointer
	vmovdqa  ymm0, [.ddqzero]	; set to zero
	and      rcx,  15			; lower 4 bits indicate misalignment
	and      rax,  -16			; align pointer by 16
	vmovdqa   ymm1, [rax]		; read from nearest preceding boundary
	vpcmpeqb  ymm1, ymm0		; compare 16 bytes with zero
	vpmovmskb edx,  ymm1		; get one bit for each byte result
	shr      edx,  cl			; shift out false bits
	shl      edx,  cl			; shift back again
	bsf      edx,  edx			; find first 1-bit
	jnz      .L2				; found
	; Main loop, search 32 bytes at a time
.L1:
	add      eax,  32				; increment pointer by 16
	vmovdqa   ymm1, [eax]			; read 16 bytes aligned
	vpcmpeqb  ymm1, ymm0			; compare 16 bytes with zero
	vpmovmskb edx,  ymm1			; get one bit for each byte result
	bsf      edx,  edx				; find first 1-bit
	jz       .L1					; loop if not found
.L2:    							; Zero-byte found. Compute string length
	sub      rax,  rdi				; subtract start address
	add      rax,  rdx				; add byte index
	ret

align  32
.ddqzero: times 32 db 0x0
