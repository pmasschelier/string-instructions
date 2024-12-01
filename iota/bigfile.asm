global src
global dst
global bigfile_size

BYTESIZE equ (1 << 22)

section .data
bigfile_size:
	dd BYTESIZE

section .bss
align 64
dst:
	resb BYTESIZE
