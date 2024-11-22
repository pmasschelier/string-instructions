global src
global dst
global bigfile_size

BYTESIZE equ (1 << 22)

section .data
align 64
src:
	times (BYTESIZE - 2) db 'A'
	db 0xA
	db 0x0
bigfile_size:
	dd $ - src

section .bss
align 64
dst:
	resb BYTESIZE
