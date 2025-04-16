global bigfile
global bigfile_size

BYTESIZE equ (1 << 22)

section .data
align 64
bigfile:
	times (BYTESIZE - 2) db 'A'
	db 0xA
	db 0x0
bigfile_size:
	dd $ - bigfile

