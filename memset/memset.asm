global memset_stosb
global memset_stosq
global memset_movb
global memset_movq
global memset_avx
global memset_avx2

section .text
; void *memset_stosb(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_stosb:
	mov rcx, rdx	; rcx = n
	movzx eax, sil	; eax = c
	mov rsi, rdi	; rdx = s
	rep stosb		; for(; rcx != 0; rcx--)
					;	 *(rdi++) = al
	mov rax, rsi	; return s
	ret

%macro set_quad 0
	and esi, 0xFF			; Mask the first byte of esi
	mov rax, [memset_one_mask]	; Load the multiplication mask
    xchg rcx, rdx           ; rcx = n
	mul rsi 				; Replicate al in all rax register (rdx is erased)
    xchg rdx, rcx           ; rdx = n
%endmacro

memset_one_mask: dq 0x0101010101010101

; void *memset_stosq(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_stosq:
    set_quad
    mov rsi, rdi            ; rsi = s
    cmp rdx, 8              ; if(n < 8)
    jb .end                 ;    goto .end
    mov rcx, rdi            ; rcx = s
    add rdx, rdi            ; rdx = dst + n
    stosq                   ; *(rdi++) = rax
    and rdi, -8             ; rdi = align(dst + 8, 8)
    sub rdx, rdi            ; rdx = dst + n - align(dst + 8, 8)
    mov rcx, rdx            ; rcx = dst + n - align(dst + 8, 8)
    and rdx, (8 - 1)        ; rdx = (dst + n - align(dst + 8, 8)) % 8
    shr rcx, 3              ; rcx = (dst + n - align(dst + 8, 8)) / 8
	rep stosq				; for(; rcx != 0; rcx -= 1)
							;	 *(rdi++) = rax
.end:
    cmp rdx, 4              ; if(rdx < 4)
    jb .word                ;    goto .word
    stosd                   ; Store double word
    sub rdx, 4              ; rdx -= 4
.word:
    cmp rdx, 2              ; if(rdx < 2)
    jb .byte                ;    goto .byte
    stosw                   ; Store word
    sub rdx, 2              ; rdx -= 2
.byte:
    test rdx, rdx           ; if(rdx == 0)
    jz .exit                ;    goto .exit
    stosb                   ; Store byte
.exit:
    mov rax, rsi            ; Return s
	ret

; void *memset_movb(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_movb:
    test rdx, rdx           ; if(rdx == 0)
    jz .exit                ;    goto .exit
    xor ecx, ecx            ; rcx = 0
.loop:
    mov [rdi + rcx], sil    ; s[rcx] = sil
    add rcx, 1              ; rcx++
    sub rdx, 1              ; rdx--
    jnz .loop               ; if(rdx != 0) goto .loop
.exit:
    mov rax, rdi            ; return s
    ret

%macro set_dword 2
    cmp %1, 4
    jb %%word
    mov [rdi + %2], eax
    add %2, 4
    sub %1, 4
%%word:
    cmp %1, 2
    jb %%byte
    mov [rdi + %2], ax
    add %2, 2
    sub %1, 2
%%byte:
    test %1, %1
    jz %%exit
    mov [rdi + %2], al
%%exit:
%endmacro

; void *memset_movq(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_movq:
    cmp rdx, 8
    jb .end
    set_quad
    xor ecx, ecx
.loop:
    mov [rdi + rcx], rax
    add rcx, 8
    sub rdx, 8
    cmp rdx, 8
    jae .loop
.end:
    set_dword rdx, rcx
    mov rax, rdi
    ret

%macro set_qword 2
    vmovq rax, xmm0
    cmp %1, 8
    jb %%dword
    mov [rdi + %2], rax
    add %2, 8
    sub %1, 8
%%dword:
    set_dword %1, %2
%endmacro

; void *memset_avx(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_avx:
	movzx esi, sil					; Copy sil in eax with zero-extend
	vmovd xmm0, esi					; Copy the low dword (eax) into xmm0
	vpxor xmm1, xmm1				; Load a shuffle mask filled with zero indexes
	vpshufb xmm0, xmm0, xmm1		; Broadcast the first byte of xmm0 to all xmm0 bytes 
    cmp rdx, 16
    jb .end
    vmovdqu [rdi], xmm0
    lea rcx, [rdi + 15]             ; rcx = src + 15
    and rcx, -16                    ; rcx = align((src + 15), 16)
    sub rcx, rdi                    ; rcx = align((src + 15), 16) - src
    sub rdx, rcx                     ; rdx = src + n - align((src + 15), 16)
    cmp rdx, 16
    jb .end
.loop:
	vmovdqa [rdi + rcx], xmm0		; Copy the 16 bytes of xmm0 to s
    add rcx, 16                     ; rcx += 16
    sub rdx, 16                     ; rdx -= 16
    cmp rdx, 16                     ; if(rdx >= 16)
	jae .loop						;	 goto .loop
.end:
    set_qword rdx, rcx
.exit
	mov rax, rdi					; rax = s
	ret

%macro set_dqword 2
    cmp %1, 16
    jb %%qword
    vmovdqu [rdi + %2], xmm0
    add %2, 16
    sub %1, 16
%%qword:
    set_qword %1, %2
%endmacro

; void *memset_avx2(rdi: void s[.n], rsi: int c, rdx: size_t n);
memset_avx2:
    xor ecx, ecx
	movzx esi, sil					; Copy sil in eax with zero-extend
	vmovd xmm1, esi					; Copy the low dword (eax) into xmm0
	vpbroadcastb ymm0, xmm1			; Broadcast the first byte of xmm1 to all ymm0
    cmp rdx, 32
    jb .end
    vmovdqu [rdi], ymm0
    lea rcx, [rdi + 31]             ; rcx = src + 31
    and rcx, -32                    ; rcx = align((src + 31), 32)
    sub rcx, rdi                    ; rcx = align((src + 31), 32) - src
    sub rdx, rcx                     ; rdx = src + n - align((src + 31), 32)
    cmp rdx, 32                     ; if(rdx < 32)
    jb .end                         ;    goto .end
.loop:
	vmovdqa [rdi + rcx], ymm0		; Copy the 32 bytes of ymm0 to s
    add rcx, 32                     ; rcx += 32
    sub rdx, 32                     ; rdx -= 32
    cmp rdx, 32                     ; if(rdx >= 32)
	jae .loop						;	 goto .loop
.end:
    set_dqword rdx, rcx
	mov rax, rdi					; rax = s
	vzeroupper
	ret
