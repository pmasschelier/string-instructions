global len

section .text
; size_t len(rdi: const char *s)
len:
	push rbx		; rbx must be saved
	mov rax, rdi	; copy pointer
	mov rcx, rdi	; copy pointer
	and rcx, 7		; lower 3 bits, check alignment
	jz .L2			; s is aligned by 8. Go to loop
	and rax, -8		; align pointer by 8
	mov rbx, [rax]	; read from preceding boundary
	shl rcx, 3		; *8 = displacement in bits

	mov rdx, -1
	shl rdx, cl		; make bit mask
	not rdx			; mask = 0FFH for false bytes
	or rdx, rbx		; mask out false bytes

	; check first eight bytes for zero
	mov rcx, rbx
	sub rcx, [.one_vec]	; substract 1 from each byte
	not rbx								; invert all bytes
	and rcx, rbx
	and rcx, [.mask] 		; test all sign bits
	jnz .L3								; zero-byte found
	; Main loop, read 8 bytes aligned
.L1:
	add rax, 8			; increment pointer
.L2:
	mov rbx, [rax]		; read 8 bytes of string
	mov rcx, rbx
	sub rcx, [.one_vec]	; substract 1 from each byte
	not rbx 			; invert all bytes
	and rcx, rbx
	and rcx, [.mask] 	; test all sign bits
	jz .L1				; no zero-byte, continue loop
.L3:
	bsf rcx, rcx	; find right-most 1-bit
	shr rcx, 3		; divide by 8 = byte index
	sub rax, rdi	; subtract start address
	add rax, rcx	; add index to byte
	pop rbx
	ret
.one_vec: dq 0x0101010101010101
.mask: dq 0x8080808080808080 		
