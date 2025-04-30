strchr_test = executable('strchr_test', 'test.c', 'strchr.c', 'strchr.asm', dependencies: [libtap], include_directories: asm_macros)
test('strchr', strchr_test, protocol: 'tap')

executable('strchr', 'bench.c', 'strchr.c', 'strchr.asm', 'bigfile.asm', dependencies: [b63, libm], include_directories: asm_macros)
