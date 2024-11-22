project('memset', 'c', 'nasm',
  default_options: ['buildtype=debugoptimized']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('memset-c-generic', 'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy = executable('memset-c-dummy', 'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_stosb = executable('memset-asm-stosb', 'main.c', 'memset-stosb.asm', link_with: bigfile_lib)
asm_stosq = executable('memset-asm-stosq', 'main.c', 'memset-stosq.asm', link_with: bigfile_lib)
asm_avx = executable('memset-asm-avx', 'main.c', 'memset-avx.asm', link_with: bigfile_lib)
asm_avx2 = executable('memset-asm-avx2', 'main.c', 'memset-avx2.asm', link_with: bigfile_lib)

test('memset-c-generic', c_generic)
test('memset-c-dummy', c_dummy)
test('memset-asm-stosb', asm_stosb)
test('memset-asm-stosq', asm_stosq)
test('memset-asm-avx', asm_avx)
test('memset-asm-avx2', asm_avx2)
