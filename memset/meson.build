memset_test = executable('memset_test', 'test.c', 'memset.c', 'memset.asm', dependencies: [libtap])
test('memset', memset_test, protocol: 'tap')

executable('memset', 'bench.c', 'memset.c', 'memset.asm', 'bigfile.asm', dependencies: [b63, libm])
