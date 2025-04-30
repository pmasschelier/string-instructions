project('string', 'c', 'nasm')

b63 = dependency('b63')
libtap = dependency('libtap')

cc = meson.get_compiler('c')
libm = cc.find_library('m', required : true)

asm_macros = include_directories('.')

subdir('memcpy')
subdir('memcmp')
subdir('strlen')
subdir('memset')
subdir('strchr')
subdir('iota')
