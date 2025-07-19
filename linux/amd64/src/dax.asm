BITS 64

%include "inc/dax.inc"

section .data
usage_error db "Usage: dax <input> <output> <-[OPTIONS]>", ENDL, NULL_T

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

    pop r12
    pop r13

dax_usage_error:
    lea rbx, [rel usage_error]
    push rbx
    call dax_printf

    mov rbx, USAGE_ERROR
    push rbx

    jmp exit

exit:
    pop rdi
    mov rax, 60

    syscall