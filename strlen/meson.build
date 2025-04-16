strlen_test = executable('strlen_test', 'test.c', 'strlen.asm', dependencies: [libtap])
test('strlen', strlen_test, protocol: 'tap')

executable('strlen', 'bench.c', 'strlen.asm', 'bigfile.asm', dependencies: [b63, libm])
