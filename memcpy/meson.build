memcpy_test = executable('memcpy_test', 'test.c', 'memcpy.c', 'memcpy.asm', dependencies: [libtap])
test('memcpy', memcpy_test, protocol: 'tap')

executable('memcpy', 'bench.c', 'memcpy.c', 'memcpy.asm', 'bigfile.asm', dependencies: [b63, libm])
