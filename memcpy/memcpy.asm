global memcpy_movsb
global memcpy_movsq
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
    mov rcx, rdi    ; Save rdi in rcx
    movsq           ; Copy first quadword
    and rdi, -8     ; Align rdi
    and rsi, -8     ; Align rsi
    sub rcx, rdi    ; Compute signed distance from first quadword boundary to dst
    add rdx, rcx    ; Substract distance from n

    mov rax, rdi    ; rax = dst
    mov rcx, rdx    ; rcx = n
    and rdx, 7      ; rdx = n % 8
	shr rcx, 3      ; rcx = n / 8
	rep movsq       ; for(; rcx != 0; rcx--)
                    ;    *(rdi++) = *(rsi++)
	; Copy the remaining bytes
	mov rcx, [rsi + rdx - 8]
	mov [rdi + rdx - 8], rcx

; void *memcpy_avx(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx:
    mov rcx, rdi        ; Save rdi in rcx
    vmovdqu xmm0, [rsi] ; Copy the first
    vmovdqu [rdi], xmm0 ; 32 bytes
    and rdi, -16        ; Align rdi
    and rsi, -16        ; Align rsi
    sub rcx, rdi        ; Compute signed distance from first 32 bytes boundary to dst
    add rdx, rcx        ; Substract distance from n

    mov rcx, rdx		; rcx = n
    and rdx, 0xF		; rdx = n % 16
    shr rcx, 4			; rcx = n / 16
    jz .endloop			; if(rcx == 0) goto .endloop
.loop:					; repeat
	vmovdqa xmm0, [rsi] ; xmm0 = *(rsi)
	vmovdqa [rdi], xmm0 ; *(rdi) = xmm0
	add rsi, 0x10		; rsi += 16
	add rdi, 0x10		; rdi += 16
	sub rcx, 1			; rcx--
	jnz .loop			; until(rcx == 0)
.endloop:
	; Copy the remaining bytes
	vmovdqu xmm0, [rsi + rdx - 0x10]
	vmovdqu [rdi + rdx - 0x10], xmm0
	ret

; void *memcpy_avx2(rdi: const void dst[.n], rsi: void src[.n], rdx: size_t n)
memcpy_avx2:
    mov rcx, rdi        ; Save rdi in rcx
    vmovdqu ymm0, [rsi] ; Copy the first
    vmovdqu [rdi], ymm0 ; 32 bytes
    and rdi, -32        ; Align rdi
    and rsi, -32        ; Align rsi
    sub rcx, rdi        ; Compute signed distance from first 32 bytes boundary to dst
    add rdx, rcx        ; Substract distance from n

    mov rcx, rdx		; rcx = n
    and rdx, 0x1F		; rdx = n %  32
    shr rcx, 5			; rcx = n / 32
    jz .endloop			; if(rcx == 0) goto .endloop
.loop:					; repeat
	vmovdqa ymm0, [rsi] ; ymm0 = *(rsi)
	vmovdqa [rdi], ymm0 ; *(rdi) = ymm0
	add rsi, 32			; rsi += 32
	add rdi, 32			; rdi += 32
	sub rcx, 1			; rcx--
	jnz .loop			; until(rcx == 0)
.endloop:
	; Copy the remaining bytes
	vmovdqu ymm0, [rsi + rdx - 0x20]
	vmovdqu [rdi + rdx - 0x20], ymm0
	vzeroupper
	ret
