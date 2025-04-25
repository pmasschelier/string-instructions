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

memcpy_movsq:
    mov rax, rdi    ; rax = dst
    cmp rdx, 8      ; if(n < 8)
    jb .end         ;    goto .end
    mov rcx, rdi    ; Save rdi in rcx
    movsq           ; Copy first quadword
    and rdi, -8     ; Align rdi
    and rsi, -8     ; Align rsi
    sub rcx, rdi    ; Compute signed distance from first quadword boundary to dst
    add rdx, rcx    ; Substract distance from n

    mov rcx, rdx    ; rcx = n
    and rdx, 7      ; rdx = n % 8
	shr rcx, 3      ; rcx = n / 8
	rep movsq       ; for(; rcx != 0; rcx--)
                    ;    *(rdi++) = *(rsi++)
.end:
    mov r8, rax     ; r8 = dst
    sub r8, rdi     ; r8 = dst - rdi
    add r8, rdx     ; r8 = dst - rdi + n
    cmp r8, 4       ; if(r8 < 4)
    jb .word        ;    goto .word
    movsd           ; copy a double word
    sub r8, 4       ; r8 -= 4
.word
    cmp r8, 2       ; if(r8 < 2)
    jb .byte        ;    goto .byte
    movsw           ; copy a word
    sub r8, 2       ; r8 -= 2
.byte:
    test r8, r8     ; if(r8 == 0)
    jz .exit        ;    goto .exit
    movsb           ; copy a byte
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
    and rcx, -8                 ; rcx = (dst + 7) % 8
    sub rcx, rdi                ; rcx = ((dst + 7) % 8) - dst
    sub r9, rcx                 ; r9 = dst + n - ((dst + 7) % 8)
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
    mov r9, rdx                     ; r9 = n
    cmp r9, 16                      ; if(n < 16)
    jb .end                         ;    goto .end
    mov rcx, rdi                    ; Save rdi in rcx
    vmovdqu xmm0, [rsi]             ; Copy the first
    vmovdqu [rdi], xmm0             ; 32 bytes
    lea rcx, [rdi + 15]             ; rcx = dst + 7
    and rcx, -16                    ; rcx = (dst + 7) % 8
    sub rcx, rdi                    ; rcx = ((dst + 7) % 8) - dst
    sub r9, rcx                     ; r9 = dst + n - ((dst + 7) % 8)
.loop:
	vmovdqa xmm0, [rsi + rcx]       ; xmm0 = rsi[rcx]
	vmovdqa [rdi + rcx], xmm0       ; rdi[rcx] = xmm0
    add rcx, 16                     ; rcx += 16
    sub r9, 16                      ; r9 -= 16
    cmp r9, 16                      ; if(r9 >= 16)
	jae .loop                       ;    goto .loop
.end:
    copy_qword r9, rcx
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
    mov rcx, rdi                    ; Save rdi in rcx
    vmovdqu ymm0, [rsi]             ; Copy the first
    vmovdqu [rdi], ymm0             ; 32 bytes
    lea rcx, [rdi + 31]             ; rcx = dst + 7
    and rcx, -32                    ; rcx = (dst + 7) % 8
    sub rcx, rdi                    ; rcx = ((dst + 7) % 8) - dst
    sub r9, rcx                     ; r9 = dst + n - ((dst + 7) % 8)
.loop:
	vmovdqa xmm0, [rsi + rcx]       ; xmm0 = rsi[rcx]
	vmovdqa [rdi + rcx], xmm0       ; rdi[rcx] = xmm0
    add rcx, 32                     ; rcx += 16
    sub r9, 32                      ; r9 -= 16
    cmp r9, 32                      ; if(r9 >= 16)
	jae .loop                       ;    goto .loop
.end:
    copy_dqword r9, rcx
    mov rax, rdi
	ret
