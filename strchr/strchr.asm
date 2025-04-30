global strchr_lodsb
global strchr_movb
global strchr_lodsq
global strchr_movq
global strchr_avx
global strchr_avx2
global strchr_sse2

%include "find_zero.asm"

%macro load_byte_movzx 0 
	movzx eax, byte [rsi]
	add rsi, 1
%endmacro
%macro load_byte_lodsb 0 
	lodsb
%endmacro

%macro strchr_byte 1
    xchg rdi, rsi
%%loop:
    %1
    cmp dil, al
    je %%end
    test al, al
    jnz %%loop
    xor rax, rax
    ret
%%end:
    lea rax, [rsi - 1]
    ret
%endmacro

%macro load_quad_mov 0 
	mov rax, [rsi]
	add rsi, 8
%endmacro
%macro load_quad_lodsq 0 
	lodsq
%endmacro

%macro strchr_quad 1
	movzx eax, sil			; eax = sil
	mul qword [%%one_mask]	; rax *= 0x0101010101010101
	mov rsi, rdi			; rsi = s
	mov rdi, rax			; rdi = rax
%%loop:
    %1
    mov rcx, rax
    find_zero r8, rcx
    xor rax, rdi
    find_zero r9, rax
    bsf rdx, r9
    mov ecx, edx
    shr ecx, 3
    test r8, r8
    jnz %%end
    test r9, r9
    jz %%loop
    lea rax, [rsi+rcx-8]
    ret
%%end:
    test rcx, rcx
    jz %%notfound
    bsf rax, r8
    cmp eax, edx
    jl %%notfound
    lea rax, [rsi+rcx-8]
    ret
%%notfound:
    xor eax, eax
    ret

%%one_mask: dq 0x0101010101010101
%endmacro

section .text

; char* strchr_lodsb(rdi: const char* s, rsi: int c)
strchr_lodsb:
    strchr_byte load_byte_lodsb

; char* strchr_movb(rdi: const char* s, rsi: int c)
strchr_movb:
    strchr_byte load_byte_movzx

; char* strchr_lodsq(rdi: const char* s, rsi: int c)
strchr_lodsq:
    strchr_quad load_quad_lodsq

; char* strchr_movq(rdi: const char* s, rsi: int c)
strchr_movq:
    strchr_quad load_quad_mov

; size_t strchr_avx(rdi: const char *s, rsi: int c)
strchr_avx:
	vpxor xmm0, xmm0	            ; xmm0 = 0

	; Broadcast the sil byte to all bytes of xmm1
	movzx ecx, sil				; Copy sil in eax with zero-extend
	vmovd xmm1, ecx				; Copy the low dword (eax) into xmm1
	vpshufb xmm1, xmm1, xmm0	; Broadcast the first byte of xmm1 to all xmm1

	vmovdqu xmm2, [rdi]         ; xmm2 = *(rdi)

	vpcmpeqb xmm3, xmm1, xmm2	; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	vpmovmskb r9d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

	vpcmpeqb xmm3, xmm0, xmm2	; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	vpmovmskb r8d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jnz .notfound			    ; 	goto .notfound

	and rdi, -16		        ; align rdi on 16 bytes
.loop:
	add rdi, 0x10		        ; rax += 16
	vmovdqa xmm2, [rdi]	        ; xmm2 = *(rdi)

	vpcmpeqb xmm3, xmm1, xmm2	; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	vpmovmskb r9d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

	vpcmpeqb xmm3, xmm0, xmm2	; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	vpmovmskb r8d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jz .loop			        ; 	goto .loop
.notfound:
    xor eax, eax                ; return NULL
	ret
.found:
	bsf r9d, r9d		        ; r8d = index of the first set bit in r8d
    test r8d, r8d               ; if(r8d == 0)
    jz .noend                   ;    goto .noend
	bsf r8d, r8d		        ; r8d = index of the first set bit in r8d
    cmp r8d, r9d                ; if(r8d < r9d)
    jb .notfound                ;    goto .notfound
.noend:
    mov rax, rdi                ; rax = rdi
	add rax, r9 		        ; rax += rdx
    ret

; size_t strchr_avx2(rdi: const char *s, rsi: int c)
strchr_avx2:
	vpxor ymm0, ymm0	            ; ymm0 = 0

	; Broadcast the sil byte to all bytes of ymm1
	movzx ecx, sil				; Copy sil in eax with zero-extend
	vmovd xmm1, ecx				; Copy the low dword (eax) into ymm1
	vpbroadcastb ymm1, xmm1	    ; Broadcast the first byte of ymm1 to all ymm1

	vmovdqu ymm2, [rdi]         ; ymm2 = *(rdi)

	vpcmpeqb ymm3, ymm1, ymm2	; ymm2 = byte_mask(i => ymm2[i] == ymm0[i])
	vpmovmskb r9d, ymm3	        ; r8d = bitmask(i => sign(ymm2[i]))

	vpcmpeqb ymm3, ymm0, ymm2	; ymm2 = byte_mask(i => ymm2[i] == ymm0[i])
	vpmovmskb r8d, ymm3	        ; r8d = bitmask(i => sign(ymm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jnz .notfound			    ; 	goto .notfound

	and rdi, -32		        ; align rdi on 16 bytes
.loop:
	add rdi, 0x20		        ; rax += 16
	vmovdqa ymm2, [rdi]	        ; ymm2 = *(rdi)

	vpcmpeqb ymm3, ymm1, ymm2	; ymm2 = byte_mask(i => ymm2[i] == ymm0[i])
	vpmovmskb r9d, ymm3	        ; r8d = bitmask(i => sign(ymm2[i]))

	vpcmpeqb ymm3, ymm0, ymm2	; ymm2 = byte_mask(i => ymm2[i] == ymm0[i])
	vpmovmskb r8d, ymm3	        ; r8d = bitmask(i => sign(ymm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jz .loop			        ; 	goto .loop
.notfound:
    xor eax, eax                ; return NULL
	ret
.found:
	bsf r9d, r9d		        ; r8d = index of the first set bit in r8d
    test r8d, r8d               ; if(r8d == 0)
    jz .noend                   ;    goto .noend
	bsf r8d, r8d		        ; r8d = index of the first set bit in r8d
    cmp r8d, r9d                ; if(r8d < r9d)
    jb .notfound                ;    goto .notfound
.noend:
    mov rax, rdi                ; rax = rdi
	add rax, r9 		        ; rax += rdx
    vzeroupper
    ret

; size_t strchr_sse2(rdi: const char *s)
strchr_sse2:
	pxor xmm0, xmm0	            ; xmm0 = 0

	; Broadcast the sil byte to all bytes of xmm1
	movzx ecx, sil				; Copy sil in eax with zero-extend
	movd xmm1, ecx				; Copy the low dword (eax) into xmm1
	pshufb xmm1, xmm0	    ; Broadcast the first byte of xmm1 to all xmm1

	movdqu xmm2, [rdi]         ; xmm2 = *(rdi)
 
    movdqa xmm3, xmm2
	pcmpeqb xmm3, xmm1	        ; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	pmovmskb r9d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    movdqa xmm3, xmm2
	pcmpeqb xmm3, xmm0	        ; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	pmovmskb r8d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jnz .notfound			    ; 	goto .notfound

	and rdi, -16		        ; align rdi on 16 bytes
.loop:
	add rdi, 0x10		        ; rax += 16
	movdqa xmm2, [rdi]	        ; xmm2 = *(rdi)

    movdqa xmm3, xmm2
	pcmpeqb xmm3, xmm1      	; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	pmovmskb r9d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    movdqa xmm3, xmm2
	pcmpeqb xmm3, xmm0	        ; xmm2 = byte_mask(i => xmm2[i] == xmm0[i])
	pmovmskb r8d, xmm3	        ; r8d = bitmask(i => sign(xmm2[i]))

    test r9d, r9d               ; if(r9d != 0)
    jnz .found                  ;    goto .found
	test r8d, r8d		        ; if(r8d == 0)
	jz .loop			        ; 	goto .loop
.notfound:
    xor eax, eax                ; return NULL
	ret
.found:
	bsf r9d, r9d		        ; r8d = index of the first set bit in r8d
    test r8d, r8d               ; if(r8d == 0)
    jz .noend                   ;    goto .noend
	bsf r8d, r8d		        ; r8d = index of the first set bit in r8d
    cmp r8d, r9d                ; if(r8d < r9d)
    jb .notfound                ;    goto .notfound
.noend:
    mov rax, rdi                ; rax = rdi
	add rax, r9 		        ; rax += rdx
    ret
