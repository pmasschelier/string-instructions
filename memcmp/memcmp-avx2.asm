global compare

section .text
compare:
	xor eax, eax
	mov rcx, rdx
.loop:
	test rcx, rcx				; if (rdx == 0)
	jz .exit					;	 return
	sub rcx, 0x20				; rdx -= 16;
	vmovdqa ymm2, [rdi]			; xmm2 = *rdi
	vmovdqa ymm3, [rsi]			; xmm3 = rsi
	add rdi, 0x20				; rdi++
	add rsi, 0x20				; rsi++
	; Compare xmm2 and xmm3 bytewise
	vpcmpeqb ymm0, ymm2, ymm3	; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])

    ; Extract the comparison mask into a 16-bit integer in eax
    vpmovmskb r8d, ymm0  	    ; Create a mask from the most significant bit of each byte
	cmp r8d, 0xFFFFFFFF				; Test if all bytes are equals
	je .loop					;	 goto .loop

	xor edx, edx

	; Compare xmm2 and xmm3 bytewise
	vpcmpgtb ymm1, ymm2, ymm3	; xmm1 = byte_mask(i => xmm2[i] > xmm3[i])
	vpmovmskb r9d, ymm1
	not r8d						; differing bits are now set
	bsf ecx, r8d				; edx = index of first differing bytes in xmm1/2
	shr r9d, cl
	test r9d, 0x1
	setnz al
	setz dl
	sub eax, edx
.exit
	ret
