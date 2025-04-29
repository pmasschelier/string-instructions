strlen_test = executable('strlen_test', 'test.c', 'strlen.c', 'strlen.asm', dependencies: [libtap], include_directories: asm_macros)
test('strlen', strlen_test, protocol: 'tap')

executable('strlen', 'bench.c', 'strlen.c', 'strlen.asm', 'bigfile.asm', dependencies: [b63, libm], include_directories: asm_macros)
