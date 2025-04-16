global memcpy_movsb
global memcpy_movsq
global memcpy_movsb_std
global memcpy_avx
global memcpy_avx2

%macro memcpy_leftover 2
%ifnnum %1
    %error "The first argument of memcpy_leftover should be an integer"
%endif
%if %1 > 5
    %error "The first argument of memcpy_leftover should be less than 5"
%endif
%if %1 > 5
    cmp %2, 32
    jae %%cpy_avx2
%endif
%if %1 > 4
    cmp %2, 16
    jae %%cpy_avx
%endif
%if %1 > 3
    cmp %2, 8
    jae %%cpy_movq
%endif
%if %1 > 2
    cmp %2, 4
    jae %%cpy_movd
%endif
%if %1 > 1
    cmp %2, 2
    jae %%cpy_movw
%endif
%if %1 > 0
    test %2, %2 
    jae %%cpy_movb
%endif
    ret

%%cpy_avx2:
	vmovdqa ymm0, [rsi]
	vmovdqu ymm1, [rsi + %2 - 0x20]
	vmovdqa [rdi], ymm0
    vmovdqu [rdi + %2 - 0x20], ymm1
    ret
%%cpy_avx:
	vmovdqa xmm0, [rsi]
	vmovdqu xmm1, [rsi + %2 - 0x10]
	vmovdqa [rdi], xmm0
	vmovdqu [rdi + %2 - 0x10], xmm1
    ret
%%cpy_movq:
    mov rcx, [rsi + %2 - 0x8]
    mov rsi, [rsi]
    mov [rdi + %2 - 0x8], rsi
    mov [rdi], rcx
    ret
%%cpy_movd:
    mov ecx, [rsi + %2 - 0x4]
    mov esi, [rsi]
    mov [rdi + %2 - 0x4], ecx
    mov [rdi], esi
    ret
%%cpy_movw:
    mov cx, [rsi + %2 - 0x2]
    mov si, [rsi]
    mov [rdi + %2 - 0x2], cx
    mov [rdi], si
    ret
%%cpy_movb:
    mov sil, [rsi + %2 - 0x2]
    mov cl, [rsi]
    mov [rdi + %2 - 0x2], sil
    mov [rdi], cl
    ret
%endmacro

section .text

; void *memcpy_movsb(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movsb:
    mov rax, rdi    ; rax = dst
	mov rcx, rdx    ; rcx = n
	rep movsb       ; for(; rcx != 0; rcx--)
                    ;    *(rdi++) = *(rsi++)
	ret             ; return rax

; void *memcpy_movsq(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_movsq:
    mov rax, rdi    ; rax = dst
    mov rcx, rdx    ; rcx = n
    and rdx, 7      ; rdx = n % 8
	shr rcx, 3      ; rcx = n / 8
	rep movsq       ; for(; rcx != 0; rcx--)
                    ;    *(rdi++) = *(rsi++)
    memcpy_leftover 3, rdx

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

; void *memcpy_avx(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx:
    mov rcx, rdx    ; rcx = n
    and rdx, 0xF    ; rdx = n % 16
    shr rcx, 4      ; rcx = n / 16
    jz .endloop     ; if(rcx == 0) goto .endloop
.loop:                  ; repeat
	vmovdqa xmm0, [rsi] ; xmm0 = *(rsi)
	vmovdqa [rdi], xmm0 ; *(rdi) = xmm0
	add rsi, 0x10       ; rsi += 16
	add rdi, 0x10       ; rdi += 16
	sub rcx, 1          ; rcx--
	jnz .loop           ; until(rcx == 0)
.endloop:
    memcpy_leftover 4, rdx
	ret

; void *memcpy_avx2(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx2:
    mov rcx, rdx    ; rcx = n
    and rdx, 0x1F   ; rdx = n %  32
    shr rcx, 5      ; rcx = n / 32
    jz .endloop     ; if(rcx == 0) goto .endloop
.loop:                  ; repeat
	vmovdqa ymm0, [rsi] ; ymm0 = *(rsi)
	vmovdqa [rdi], ymm0 ; *(rdi) = ymm0
	add rsi, 32         ; rsi += 32
	add rdi, 32         ; rdi += 32
	sub rcx, 1          ; rcx--
	jnz .loop           ; until(rcx == 0)
.endloop:
    memcpy_leftover 5, rdx
	ret
