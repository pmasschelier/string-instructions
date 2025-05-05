%macro find_zero 2
	mov %1, %2
	not %2
	sub %1, [_find_zero_one_vec]
	and %1, %2
	and %1, [_find_zero_sign_mask]
%endmacro

section .rodata
_find_zero_one_vec: dq 0x0101010101010101
_find_zero_sign_mask: dq 0x8080808080808080

