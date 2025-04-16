memcmp_test = executable('memcmp_test', 'test.c', 'memcmp.asm', dependencies: [libtap])
test('memcmp', memcmp_test, protocol: 'tap')

executable('memcmp', 'bench.c', 'memcmp.asm', 'bigfile.asm', dependencies: [b63, libm])
