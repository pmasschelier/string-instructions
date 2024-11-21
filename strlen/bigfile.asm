global bigfile_start
global bigfile_size

section .data
align 64
bigfile_start:
	times ((1 << 22) - 2) db 'A'
	db 0xA
	db 0x0
bigfile_size:
	dd $ - bigfile_start
