strchr_test = executable('iota_test', 'test.c', 'iota.c', 'iota.asm', dependencies: [libtap], include_directories: asm_macros)
test('iota', strchr_test, protocol: 'tap')

executable('iota', 'bench.c', 'iota.c', 'iota.asm', 'bigfile.asm', dependencies: [b63, libm], include_directories: asm_macros)
