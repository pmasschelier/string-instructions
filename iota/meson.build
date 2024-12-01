project('memset', 'c', 'nasm',
  default_options: ['buildtype=debugoptimized']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('iota-c-generic', 'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy = executable('iota-c-dummy', 'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_stosb = executable('iota-asm-stosb',  'main.c', 'iota-byte.asm', link_with: bigfile_lib)
asm_movb = executable('iota-asm-movb',  'main.c', 'iota-byte.asm', link_with: bigfile_lib, nasm_args: ['-DMOV_VERSION'])
asm_stosq = executable('iota-asm-stosq',  'main.c', 'iota-quad.asm', link_with: bigfile_lib)
asm_movq = executable('iota-asm-movq',  'main.c', 'iota-quad.asm', link_with: bigfile_lib, nasm_args: ['-DMOV_VERSION'])
asm_avx = executable('iota-asm-avx', 'main.c', 'iota-avx.asm', link_with: bigfile_lib)
asm_avx2 = executable('iota-asm-avx2', 'main.c', 'iota-avx2.asm', link_with: bigfile_lib)

test('iota-c-generic', c_generic)
test('iota-c-dummy', c_dummy)
test('iota-asm-stosb', asm_stosb)
test('iota-asm-movb', asm_movb)
test('iota-asm-stosq', asm_stosq)
test('iota-asm-movq', asm_movq)
test('iota-asm-avx', asm_avx)
test('iota-asm-avx2', asm_avx2)
