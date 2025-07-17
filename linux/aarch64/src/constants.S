// constants.s

// Open flags
.equ O_RDONLY, 0
.equ O_WRONLY, 1
.equ O_CREAT,  64
.equ O_TRUNC,  512

// Syscall numbers (Linux AArch64)
.equ SYS_openat, 56
.equ SYS_read,   63
.equ SYS_write,  64
.equ SYS_close,  57
.equ SYS_exit,   93

// File descriptors
.equ AT_FDCWD, -100

// Status codes
.equ ARG_FAIL,   1
.equ OPEN_FAIL,  2
.equ READ_FAIL,  3
.equ WRITE_FAIL, 4

.equ MAX_FILE_BUF, 65536
.equ MAX_PATH_BUF, 256
