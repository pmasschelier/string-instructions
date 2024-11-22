project('memcmp', 'c', 'nasm',
  default_options: ['buildtype=debugoptimized']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('memcmp-c-generic', 'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy = executable('memcmp-c-dummy', 'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_cmpsb = executable('memcmp-asm-cmpsb', 'main.c', 'memcmp-cmpsb.asm', link_with: bigfile_lib)
asm_cmpsq = executable('memcmp-asm-cmpsq', 'main.c', 'memcmp-cmpsq.asm', link_with: bigfile_lib)
asm_avx = executable('memcmp-asm-avx', 'main.c', 'memcmp-avx.asm', link_with: bigfile_lib)
asm_avx2 = executable('memcmp-asm-avx2', 'main.c', 'memcmp-avx2.asm', link_with: bigfile_lib)

test('memcmp-c-generic', c_generic)
test('memcmp-c-dummy', c_dummy)
test('memcmp-asm-cmpsb', asm_cmpsb)
test('memcmp-asm-cmpsq', asm_cmpsq)
test('memcmp-asm-avx', asm_avx)
test('memcmp-asm-avx2', asm_avx2)
