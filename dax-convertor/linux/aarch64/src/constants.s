// constants.s

// Macros
.equ NULL, 0
.equ NULL_T, 0

// Open flags
.equ O_RDONLY, 0
.equ O_WRONLY, 1
.equ O_CREAT,  64
.equ O_TRUNC,  512

// mmap flags
.equ PROT_READ, 0
.equ PROT_WRITE, 0
.equ PROT_READ_WRITE, 3
.equ MAP_PRIVATE, 0
.equ MAP_ANONYMOUS, 0
.equ MAP_PRIVATE_ANONYMOUS, 0x22

// Syscall numbers (Linux AArch64)
.equ SYS_openat, 56
.equ SYS_read,   63
.equ SYS_write,  64
.equ SYS_close,  57
.equ SYS_exit,   93
.equ SYS_mmap, 222
.equ SYS_munmap, 215

// File descriptors
.equ AT_FDCWD, -100

// Status codes
.equ ARG_FAIL,   1
.equ OPEN_FAIL,  2
.equ READ_FAIL,  3
.equ WRITE_FAIL, 4

.equ MAX_FILE_BUF, 65536
.equ MAX_PATH_BUF, 256
