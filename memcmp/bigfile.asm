global src:data BYTESIZE
global dst:data BYTESIZE
global bigfile_size:data 4
global func

BYTESIZE equ (1 << 23)

section .rodata
align 64
    db 0x0
src:
	times (BYTESIZE - 2) db 'A'
	db 0xA
	db 0x0
bigfile_size:
	dd $ - src

align 64
dst:
	times (BYTESIZE - 2) db 'A'
	db 0x1
	db 0xB

func:
	ret
