global memcpy_movsb
global memcpy_movsq
global memcpy_movb
global memcpy_movq
global memcpy_movsb_std
global memcpy_avx
global memcpy_avx2

section .text

; void *memcpy_movsb(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movsb:
    mov rax, rdi    ; rax = dst
	mov rcx, rdx    ; rcx = n
	rep movsb       ; for(; rcx != 0; rcx--)
                    ;    *(rdi++) = *(rsi++)
	ret             ; return rax

; void *memcpy_movsb_std(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movsb_std:
    mov rax, rdi    ; rax = dst
	std             ; Set direction flag
	mov rcx, rdx    ; rcx = n
	sub rdx, 1      ; rdx = n - 1
	add rdi, rdx    ; rdi = dst + (n - 1)
	add rsi, rdx    ; rsi = src + (n - 1)
	rep movsb       ; for(; rcx != 0; rcx--)
                    ;    *(rdi)++ = *(rsi++)
	cld             ; Clear direction flag
	ret             ; return rax

; void *memcpy_movsq(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movsq:
    mov rax, rdi                ; rax = dst
    cmp rdx, 8                  ; if(n < 8)
    jb .end                     ;    goto .end
    lea rcx, [rsi + 8]          ; rcx = src + 8
    movsq                       ; Copy first quadword
    and rsi, -8                 ; rsi = align(src + 8, 8)
    sub rcx, rsi                ; rcx = (src + 8) - align(src + 8, 8)
    sub rdi, rcx                ; rdi = (dst + 8) - ((src + 8) - align(src + 8, 8))
    lea rdx, [rdx + rcx - 8]    ; rdx = n - (8 - ((src + 8) - align(src + 8, 8)))
    mov rcx, rdx                ; rcx = n - (align(src + 8, 8) - src)
    and rcx, -8                 ; rcx = align(n - (align(src + 8, 8) - src), 8)
    shr rcx, 3                  ; rcx = align(n - (align(src + 8, 8) - src), 8) / 8
	rep movsq                   ; for(; rcx != 0; rcx--)
                                ;    *(rdi++) = *(rsi++)
    and rdx, (8 - 1)            ; rdx = n - (align(src + 8, 8) - src) % 8
.end:
    cmp rdx, 4                  ; if(rdx < 4)
    jb .word                    ;    goto .word
    movsd                       ; copy a double word
    sub rdx, 4                  ; rdx -= 4
.word
    cmp rdx, 2                  ; if(rdx < 2)
    jb .byte                    ;    goto .byte
    movsw                       ; copy a word
    sub rdx, 2                  ; rdx -= 2
.byte:
    test rdx, rdx               ; if(rdx == 0)
    jz .exit                    ;    goto .exit
    movsb                       ; copy a byte
.exit:
    ret

; void *memcpy_movb(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movb:
    mov rax, rdi                ; Save dst in rax
    test rdx, rdx               ; if(rdx == 0)
    jz .exit                    ;    goto .exit
    xor ecx, ecx                ; rcx = 0
.loop:
    movzx r8d, byte [rsi+rcx]   ; r8b = rsi[rdx]
    mov byte [rdi+rcx], r8b     ; rdi[rcx] = r8b
    add rcx, 1                  ; rcx++
    cmp rcx, rdx                ; if(rcx != n)
    jne .loop                   ;    goto .loop
.exit:
    ret

%macro copy_dword 2
    cmp %1, 4                   ; if(r8 < 4)
    jb %%word                    ;    goto .word
    mov eax, [rsi + %2]         ; eax = src[%2]
    mov [rdi + %2], eax         ; dst[%2] = eax
    add %2, 4                   ; %2 += 4
    sub %1, 4                   ; %1 -= 4
%%word:
    cmp %1, 2                   ; if(r8 < 2)
    jb %%byte                    ;    goto .byte
    movzx eax, word [rsi + %2]  ; ax = src[%2]
    mov [rdi + %2], ax          ; dst[%2] = ax
    add %2, 2                   ; %2 += 2
    sub %1, 2                   ; %1 -= 2
%%byte:
    test %1, %1                 ; if(r8 == 0)
    jz %%exit                    ;    goto .exit
    movzx eax, byte [rsi + %2]  ; al = src[%2]
    mov [rdi + %2], al          ; dst[%2] = al
%%exit:
%endmacro

; void *memcpy_movq(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movq:
    xor ecx, ecx                ; rcx = 0
    mov r9, rdx                 ; r9 = n
    cmp r9, 8                   ; if(n < 8)
    jb .end                     ;    goto .end
    mov r8, [rsi]               ; r8 = *(rsi)
    mov [rdi], r8               ; *(rsi) = r8
    lea rcx, [rdi + 7]          ; rcx = dst + 7
    and rcx, -8                 ; rcx = align((dst + 7), 8)
    sub rcx, rdi                ; rcx = align((dst + 7), 8) - dst
    sub r9, rcx                 ; r9 = dst + n - align((dst + 7), 8)
.loop:
    mov rax, [rsi + rcx]        ; r8 = src[rcx]
    mov [rdi + rcx], rax        ; dst[rcx] = r8
    add rcx, 8                  ; rcx += 8
    sub r9, 8                   ; r9 -= 8
    cmp r9, 8                   ; if(r9 >= 8)
    jae .loop                   ;    goto .loop
.end:
    copy_dword r9, rcx
    mov rax, rdi                ; return dst
    ret

%macro copy_qword 2
    cmp %1, 8
    jb %%dword
    mov rax, [rsi + %2]
    mov [rdi + %2], rax
    add %2, 8
    sub %1, 8
%%dword:
    copy_dword %1, %2
%endmacro

; void *memcpy_avx(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx:
    xor ecx, ecx                    ; rcx = 0
    cmp rdx, 16                      ; if(n < 16)
    jb .end                         ;    goto .end
    vmovdqu xmm0, [rsi]             ; Copy the first
    vmovdqu [rdi], xmm0             ; 32 bytes
    lea rcx, [rsi + 15]             ; rcx = src + 15
    and rcx, -16                    ; rcx = align((src + 15), 16)
    sub rcx, rsi                    ; rcx = align((src + 15), 16) - src
    sub rdx, rcx                     ; rdx = src + n - align((src + 15), 16)
.loop:
	vmovdqa xmm0, [rsi + rcx]       ; xmm0 = rsi[rcx]
	vmovdqu [rdi + rcx], xmm0       ; rdi[rcx] = xmm0
    add rcx, 16                     ; rcx += 16
    sub rdx, 16                      ; rdx -= 16
    cmp rdx, 16                      ; if(rdx >= 16)
	jae .loop                       ;    goto .loop
.end:
    copy_qword rdx, rcx
    mov rax, rdi
	ret

%macro copy_dqword 2
    cmp %1, 16
    jb %%qword
    movdqa xmm0, [rsi + %2]
    movdqu [rdi + %2], xmm0
    add %2, 16
    sub %1, 16
%%qword:
    copy_qword %1, %2
%endmacro

; void *memcpy_avx2(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx2:
    xor ecx, ecx                    ; rcx = 0
    mov r9, rdx                     ; r9 = n
    cmp r9, 32                      ; if(n < 16)
    jb .end                         ;    goto .end
    vmovdqu ymm0, [rsi]             ; Copy the first
    vmovdqu [rdi], ymm0             ; 32 bytes
    lea rcx, [rsi + 31]             ; rcx = src + 31
    and rcx, -32                    ; rcx = align((src + 31), 32)
    sub rcx, rsi                    ; rcx = align((src + 31), 32) - src
    sub r9, rcx                     ; r9 = src + n - align((src + 31), 32)
.loop:
	vmovdqa ymm0, [rsi + rcx]       ; xmm0 = rsi[rcx]
	vmovdqu [rdi + rcx], ymm0       ; rdi[rcx] = xmm0
    add rcx, 32                     ; rcx += 16
    sub r9, 32                      ; r9 -= 16
    cmp r9, 32                      ; if(r9 >= 16)
	jae .loop                       ;    goto .loop
.end:
    copy_dqword r9, rcx
    mov rax, rdi
	ret
