; dax.asm -> AkshuDev
; NASM style
BITS 64

%include "inc/dax.inc"

extern GetCommandLineA
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess
extern CreateFileA
extern ReadFile
extern WriteFile
extern CloseHandle
extern GetFileSize

section .data
    ; Header
    hdr_magic db "DAX"
    hdr_version dw 1
    entry_point dd 0 ; Entry point (4 bytes, currently 0)
    code_size dd 0 ; Code size (4 bytes, will be set later)

    ; Input and Output
    input_fd dq 0
    output_fd dq 0

    ; Bytes
    bytes_read dq 0
    bytes_written dq 0

    ; Handles
    input_handle dq 0
    output_handle dq 0

    ; File
    file_size dq 0

    ; Buffers
    bufsize equ 65536 ; 64KB
    buffer times bufsize db 0

    ; Errors/Usage
    usage_msg db "Usage: dax <input_file> <output_file> <-[OPTIONS]>", ENDL, NULL_T
    usage_len equ $-usage_msg

section .bss

section .text
global main

; CODE SECTION
main:
    ; Shadow space
    sub rsp, 28h

    ; GetCommandLineA to get and parse args
    call GetCommandLineA
    mov rsi, rax

skip_exe:
    cmp byte [rsi], ' '
    je found_space
    cmp byte [rsi], 0
    je show_usage
    inc rsi
    jmp skip_exe

found_space:
    ; skip spaces
    inc rsi
    cmp byte [rsi], ' '
    je found_space

    mov rdi, rsi ; input file

find_output:
    cmp byte [rsi], ' '
    je end_input
    cmp byte [rsi], 0
    je show_usage
    inc rsi
    jmp find_output

end_input:
    mov byte [rsi], 0
    inc rsi
    cmp byte [rsi], 0
    je show_usage

    ; rdi = input filename, rsi = output filename

    jmp start

exit:
    call ExitProcess

write_header:
    ; === Write Header to buffer ===
    mov rax, [rel file_size]
    mov [rel code_size], eax

    ; 'DAX'
    mov byte [rel buffer], 'D'
    mov byte [rel buffer + 1], 'A'
    mov byte [rel buffer + 2], 'X'

    ; Version (2 bytes)
    mov ax, [rel hdr_version]
    mov word [rel buffer + 3], ax
    xor ax, ax

    ; Entry point (4 bytes)
    mov dword [rel buffer + 5], 0 ; Entry point is 0 for now

    ; Code size (4 bytes)
    mov dword [rel buffer + 9], eax

    ret

write_output:
    ; === Create output file ===
    mov rcx, rsi
    mov rdx, GENERIC_WRITE
    mov r8, 0
    mov r9, NULL
    sub rsp, 40h
    mov qword [rsp+32h], NULL
    mov qword [rsp+24h], CREATE_ALWAYS
    mov qword [rsp+16h], NULL
    mov qword [rsp+08h], NULL
    call CreateFileA
    add rsp, 40h
    mov [rel output_handle], rax

    ; === Write buffer to output file ===
    mov rcx, [rel output_handle]
    lea rdx, [rel buffer] ; buffer with parsed code
    mov r8, [rel file_size]
    add r8, 13 ; add header size
    lea r9, [rel bytes_written]
    sub rsp, 40h
    mov qword [rsp+32h], NULL
    call WriteFile
    add rsp, 40h

    ret

close_output:
    ; === Close Output File ===
    mov rcx, [rel output_handle]
    call CloseHandle

    ret

start:
    ; === Open input file ===
    mov rcx, rdi
    mov rdx, GENERIC_READ
    mov r8, FILE_SHARE_READ
    mov r9, NULL
    sub rsp, 40h
    mov qword [rsp+32h], NULL
    mov qword [rsp+24h], OPEN_EXISTING
    mov qword [rsp+16h], NULL
    mov qword [rsp+08h], NULL
    call CreateFileA
    add rsp, 40h

    cmp rax, -1
    je show_usage
    mov [rel input_handle], rax

    ; === Get File Size ===
    mov rcx, rax
    mov rdx, NULL
    call GetFileSize
    mov [rel file_size], rax

    ; === Read input file to buffer (at offset 13 for header ) ===
    mov rcx, [rel input_handle]
    lea rdx, [rel buffer + 13] ; skip header
    mov r8, [rel file_size]
    lea r9, [rel bytes_read]
    sub rsp, 40h
    mov qword [rsp+32h], NULL
    call ReadFile
    add rsp, 40h

    ; === Close Input ===
    mov rcx, [rel input_handle]
    call CloseHandle

    call write_header
    call write_output
    call close_output

    xor ecx, ecx ; exit code 0
    call exit

show_usage:
    ; print_usage
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle

    mov rcx, rax
    lea rdx, [rel usage_msg]
    mov r8, usage_len
    lea r9, [rel bytes_written]
    sub rsp, 40h
    mov qword [rsp+32h], NULL
    call WriteConsoleA
    add rsp, 40h

    mov ecx, INVALID_USAGE
    call exit
