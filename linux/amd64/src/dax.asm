BITS 64

%include "inc/dax.inc"

; string.asm
extern dax_printf
extern dax_print
extern dax_sizeof
extern dax_strcpy

section .data
usage_error db "Usage: dax <input> <output> <-[OPTIONS]>", ENDL, NULL_T
starting_dax db "Starting dax...", ENDL, NULL_T
DaXing_file db "daXing file "
DaXing_to db " to "
endline db "", ENDL, NULL_T

section .bss
fdIn resb MAX_FILE_BUF
fdOut resb MAX_FILE_BUF

buffer resb MAX_FILE_CONTENTS_BUF

section .text
global _start

_start: ; rbx, r12, r13, r14, r15 (calle saved)
    ; Parse Args
    pop rbx ; argc

    cmp rbx, 3
    jl dax_usage_error

    pop rsi
    pop rsi ; src
    lea rdi, [rel fdIn] ; dest
    call dax_strcpy

    pop rsi ; src
    lea rdi, [rel fdOut] ; dest
    call dax_strcpy

    lea rdi, [rel starting_dax]
    call dax_printf

    ; print -> daXing file [fdIn] to [fdOut]\n\0
    lea rdi, [rel DaXing_file]
    call dax_printf

    lea rdi, [rel fdIn]
    call dax_printf

    lea rdi, [rel DaXing_to]
    call dax_printf

    lea rdi, [rel fdOut]
    call dax_printf

    lea rdi, [rel endline]
    call dax_printf

    mov rdi, 0
    jmp exit

dax_usage_error:
    lea rdi, [rel usage_error]
    call dax_printf

    mov rax, USAGE_ERROR

    jmp exit

exit:
    mov rax, 60

    syscall