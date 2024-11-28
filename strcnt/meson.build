project('strcnt', 'c', 'nasm',
  default_options: ['buildtype=debugoptimized']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('strcnt-c-generic',  'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy   = executable('strcnt-c-dummy',    'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_lodsb = executable('strcnt-asm-lodsb',  'main.c', 'strcnt-byte.asm', link_with: bigfile_lib)
asm_movb = executable('strcnt-asm-movb',  'main.c', 'strcnt-byte.asm', link_with: bigfile_lib, c_args: ['-DMOV_VERSION'])
asm_lodsq = executable('strcnt-asm-lodsq',  'main.c', 'strcnt-quad.asm', link_with: bigfile_lib)
asm_movq = executable('strcnt-asm-movq',  'main.c', 'strcnt-quad.asm', link_with: bigfile_lib, c_args: ['-DMOV_VERSION'])
# asm_avx = executable('strlen-asm-avx',    'main.c', 'strlen-avx.asm',   link_with: bigfile_lib)
# asm_avx2 = executable('strlen-asm-avx2',   'main.c', 'strlen-avx2.asm',  link_with: bigfile_lib)

test('strcnt-c-generic', c_generic)
test('strcnt-c-dummy', c_dummy)
test('strcnt-asm-lodsb', asm_lodsb)
test('strcnt-asm-movb', asm_movb)
test('strcnt-asm-lodsq', asm_lodsq)
test('strcnt-asm-movq', asm_movq)
# test('strlen-asm-avx', asm_avx)
# test('strlen-asm-avx2', asm_avx2)

