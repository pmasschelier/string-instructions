global compare

section .text
; int compare(rdi: const void s1[.n], rsi: const void s2[.n], rdx: size_t n);
compare:
	xor eax, eax

	test rdx, rdx				; if(n == 0)
	jz .exit					;	 return 0
	test rdx, -16				; if(rdx < 16)
	jz .end						;	 jump

	mov rcx, rdx				; rcx = n
	and rcx, -32				; rcx = n - (n % 16)
	and rdx, (32 - 1)			; rdx = n % 16

	vmovdqa ymm2, [rdi]			; xmm2 = *rdi
	vmovdqa ymm3, [rsi]			; xmm3 = rsi
.loop:
	add rdi, 0x20				; rdi++
	add rsi, 0x20				; rsi++

	; Compare xmm2 and xmm3 bytewise
	vpcmpeqb ymm0, ymm2, ymm3	; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])

    ; Extract the comparison mask into a 16-bit integer in eax
    vpmovmskb r8d, ymm0  	    ; Create a mask from the most significant bit of each byte
	cmp r8d, 0xFFFFFFFF			; Test if all bytes are equals
	jne .end					; If not break

	sub rcx, 0x20				; rcx -= 32;

	vmovdqa ymm2, [rdi]			; xmm2 = *rdi
	vmovdqa ymm3, [rsi]			; xmm3 = rsi

	test rcx, rcx				; if (rdx == 0)
	jnz .loop					;	 return

.end:
	add rdx, rcx

	vpcmpeqb ymm0, ymm2, ymm3	; xmm0 = byte_mask(i => xmm2[i] == xmm3[i])
    vpmovmskb r8d, ymm0  	    ; Create a mask from the most significant bit of each byte

	; Compare xmm2 and xmm3 bytewise
	vpcmpgtb ymm1, ymm2, ymm3	; xmm1 = byte_mask(i => xmm2[i] > xmm3[i])
	vpmovmskb r9d, ymm1
	not r8d						; differing bits are now set
	bsf ecx, r8d				; edx = index of first differing bytes in xmm1/2
	cmp rcx, rdx				; if the first differing byte is greater than n % 16
	jae .exit                   ;	 return

	shr r9d, cl					; Find the corresponding bit in r9d
	xor edx, edx
	test r9d, 0x1               ; If it is set
	setnz al                    ;	 return 1
	setz dl                     ; else
	sub eax, edx                ;	 return -1
.exit:
	ret
