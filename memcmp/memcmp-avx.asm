global compare

section .text
compare:
	xor eax, eax
	mov rcx, rdx
.loop:
	test rcx, rcx				; if (rdx == 0)
	jz .exit					;	 return
	sub rcx, 0x10				; rdx -= 16;
	vmovdqa xmm2, [rdi]			; xmm2 = *rdi
	vmovdqa xmm3, [rsi]			; xmm3 = rsi
	add rdi, 0x10				; rdi++
	add rsi, 0x10				; rsi++
	; Compare xmm2 and xmm3 bytewise
	vpcmpeqb xmm0, xmm2, xmm3	; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])

    ; Extract the comparison mask into a 16-bit integer in eax
    vpmovmskb r8d, xmm0  	    ; Create a mask from the most significant bit of each byte
	cmp r8d, 0xFFFF				; Test if all bytes are equals
	je .loop					;	 goto .loop

	xor edx, edx

	; Compare xmm2 and xmm3 bytewise
	vpcmpgtb xmm1, xmm2, xmm3	; xmm1 = byte_mask(i => xmm2[i] > xmm3[i])
	vpmovmskb r9d, xmm1
	not r8d						; differing bits are now set
	bsf ecx, r8d				; edx = index of first differing bytes in xmm1/2
	shr r9d, cl
	test r9d, 0x1
	setnz al
	setz dl
	sub eax, edx
.exit
	ret
