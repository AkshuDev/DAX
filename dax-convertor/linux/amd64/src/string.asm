BITS 64

section .text
global dax_print
global dax_strlen
global dax_printf
global dax_strcpy

dax_print: ; ptr (char*), size (int)
    mov rdx, rsi
    mov rsi, rdi

    mov rdi, 1 ; stdout
    mov rax, 1

    syscall
    
    ret

dax_strlen: ; ptr (char*)
    xor rax, rax

.dax_strlen_loop:
    cmp byte [rdi + rax], 0
    je .dax_strlen_done

    inc rax
    jmp .dax_strlen_loop

.dax_strlen_done:
    ret

dax_printf: ; ptr (char*)
    push rdi

    call dax_strlen

    pop rdi
    mov rsi, rax
    xor rax, rax

    call dax_print

    ret

dax_strcpy: ; dest (void*), src (char*)
    mov rax, rdi ; dest as return value
.dax_strcpy_copy:
    mov bl, byte [rsi] ; load byte from src
    mov [rdi], bl ; store to dest

    inc rsi
    inc rdi
    
    cmp bl, 0 ; Check for NULL
    jne .dax_strcpy_copy

    ret

