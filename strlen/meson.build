project('strlen', 'c', 'nasm',
  default_options: ['buildtype=debugoptimized']
)

bigfile_lib = static_library('bigfile', 'bigfile.asm')

c_generic = executable('strlen-c-generic',  'main.c', link_with: bigfile_lib, c_args: ['-DSTD_VERSION'])
c_dummy   = executable('strlen-c-dummy',    'main.c', link_with: bigfile_lib, c_args: ['-DDUMMY_VERSION'])
asm_scasb = executable('strlen-asm-scasb',  'main.c', 'strlen-scasb.asm', link_with: bigfile_lib)
asm_vec64 = executable('strlen-asm-vec64',  'main.c', 'strlen-vec64.asm', link_with: bigfile_lib)
asm_sse2 = executable('strlen-asm-sse2',   'main.c', 'strlen-sse2.asm',  link_with: bigfile_lib)
asm_avx = executable('strlen-asm-avx',    'main.c', 'strlen-avx.asm',   link_with: bigfile_lib)
asm_avx2 = executable('strlen-asm-avx2',   'main.c', 'strlen-avx2.asm',  link_with: bigfile_lib)

test('strlen-c-generic', c_generic)
test('strlen-c-dummy', c_dummy)
test('strlen-asm-scasb', asm_scasb)
test('strlen-asm-vec64', asm_vec64)
test('strlen-asm-sse2', asm_sse2)
test('strlen-asm-avx', asm_avx)
test('strlen-asm-avx2', asm_avx2)

