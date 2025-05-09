memcmp_test = executable('memcmp_test', 'test.c', 'memcmp.c', 'memcmp.asm', 'bigfile.asm', dependencies: [libtap])
test('memcmp', memcmp_test, protocol: 'tap')

executable('memcmp', 'bench.c', 'memcmp.c', 'memcmp.asm', 'bigfile.asm', dependencies: [b63, libm])
