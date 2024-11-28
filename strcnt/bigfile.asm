global bigfile_start
global bigfile_size

section .data
align 64
bigfile_start:
	times ((1 << 20) - 2) db 'A', 'A', 'B', 'B'
	db 0xA
	db 0x0
bigfile_size:
	dd $ - bigfile_start
