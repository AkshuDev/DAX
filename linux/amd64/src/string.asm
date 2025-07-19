BITS 64

section .text
global dax_print
global dax_strlen
global dax_printf

dax_print:
    pop rsi
    pop rdx

    mov rdi, 1 ; stdout
    mov rax, 1

    syscall
    
    ret

dax_strlen:
    pop rbx
    xor rax, rax

.loop:
    cmp byte [rbx + rax], 0
    je .done

    inc rax
    jmp .loop

.done:
    ret

dax_printf:
    pop rdi

    push rdi
    call dax_strlen

    push rax
    push rdi
    call dax_print

    ret