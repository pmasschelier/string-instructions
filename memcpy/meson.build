project('memcpy', 'c', 'nasm',
  default_options: ['buildtype=release']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('memcpy-c-generic', 'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy = executable('memcpy-c-dummy', 'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_movsb = executable('memcpy-asm-movsb', 'main.c', 'memcpy-movsb.asm', link_with: bigfile_lib)
asm_movsb_std = executable('memcpy-asm-movsb-std', 'main.c', 'memcpy-movsb-std.asm', link_with: bigfile_lib)
asm_movsq = executable('memcpy-asm-movsq', 'main.c', 'memcpy-movsq.asm', link_with: bigfile_lib)
asm_avx = executable('memcpy-asm-avx', 'main.c', 'memcpy-avx.asm', link_with: bigfile_lib)
asm_avx2 = executable('memcpy-asm-avx2', 'main.c', 'memcpy-avx2.asm', link_with: bigfile_lib)

test('memcpy-c-generic', c_generic)
test('memcpy-c-dummy', c_dummy)
test('memcpy-asm-movsb', asm_movsb)
test('memcpy-asm-movsb-std', asm_movsb_std)
test('memcpy-asm-movsq', asm_movsq)
test('memcpy-asm-avx', asm_avx)
test('memcpy-asm-avx2', asm_avx2)
