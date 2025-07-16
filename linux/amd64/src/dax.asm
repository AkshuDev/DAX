; dax.asm -> AkshuDev
; NASM style
BITS 64

%include "inc/dax.inc"

section .data
    ; Header
    hdr_magic db "DAX"
    hdr_version dw 1

    ; Input and Output
    input_fd dq 0
    output_fd dq 0

    statbuf times 114 db 0
    buf times 65536 db 0 ; MAX 64KB files

    ; Errors/Usage
    usage_msg db "Usage: dax <input_file> <output_file> <-[OPTIONS]>", ENDL, NULL_T

section .bss

section .text
global _start

; CODE SECTION
