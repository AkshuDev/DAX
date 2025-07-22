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
DaXing_file db "daXing file ", NULL_T
DaXing_to db " to ", NULL_T

read_error db "ERROR: Unable to read <input> file!", ENDL, NULL_T

endline db "", ENDL, NULL_T

daX_hdr:
    db "DAX" ; char Magic [3]
    db 

section .bss
fnIn resb MAX_FILE_BUF
fnOut resb MAX_FILE_BUF

fdIn resb MAX_FILE_BUF
fdOut resb MAX_FILE_BUF

buffer resb MAX_FILE_CONTENTS_BUF

section .text
global _start

_start: ; rbx, r12, r13, r14, r15 (calle saved)
    ; Parse Args (do not pop off the stack to disturb the alignment)
    call dax_parse_args

    lea rdi, [rel starting_dax]
    call dax_printf

    ; print -> daXing file [fnIn] to [fnOut]\n\0
    lea rdi, [rel DaXing_file]
    call dax_printf

    lea rdi, [rel fnIn]
    call dax_printf

    lea rdi, [rel DaXing_to]
    call dax_printf

    lea rdi, [rel fnOut]
    call dax_printf

    lea rdi, [rel endline]
    call dax_printf

    ; Now we begin here!
    mov rax, 2
    lea rdi, [rel fnIn]
    mov rsi, O_RDONLY
    mov rdx, MODE_644
    syscall

    mov [rel fdIn], rax ; Save file descriptor

    ; now read
    mov rax, 0
    mov rdi, [rel fdIn]
    lea rsi, [rel buffer]
    mov rdx, MAX_FILE_CONTENTS_BUF
    syscall

    cmp rax, 0 ; if the read contents were zero
    jl dax_read_error

    ; now close
    mov rax, 3
    mov rdi, [rel fdIn]
    syscall

    

    ; Exit
    mov rdi, 0
    jmp exit

dax_parse_args:
    mov rsi, [rsp] ; argc

    cmp rsi, 3
    jl dax_usage_error

    mov rsi, [rsp + 8] ; useless tho (argv[0])
    mov rsi, [rsp + 16] ; src (argv[1], file input)
    lea rdi, [rel fnIn] ; dest
    call dax_strcpy

    mov rsi, [rsp + 24] ; src (argv[2], file output)
    lea rdi, [rel fnOut] ; dest
    call dax_strcpy

    ret

dax_read_error:
    ; Close the file first
    mov rax, 3
    mov rdi, [rel fdIn]
    syscall ; Close

    lea rdi, [rel read_error]
    call dax_printf ; Print Error

    mov rdi, UNABLE_TO_READ_FILE_ERROR
    jmp exit

dax_usage_error:
    lea rdi, [rel usage_error]
    call dax_printf

    mov rax, USAGE_ERROR

    jmp exit

exit:
    mov rax, 60

    syscall