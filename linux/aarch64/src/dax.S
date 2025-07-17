.include "constants.S"

.section .rodata
usage: .asciz "Usage: dax <input> <output> <-[OPTIONS]>\n"

.section .data
buffer: .skip MAX_FILE_BUF

fdIn: .skip MAX_PATH_BUF
fdOut: .skip MAX_PATH_BUF

.section .text
.global _start
.type _start, %function

exit:
	ldr x0, [sp]
	add sp, sp, #8
	mov x8, #93
	svc #0

dax_usage_error:
	sub sp, sp, #8
	ldr x0, =usage
	str x0, [sp]
	bl dax_printf
	// Exit code is on stack given by dax_printf
	b exit

_start:
	mov x19, x0
	mov x20, x1
	
	cmp x19, #3 // argc = 3 (cmp)
	b.lt dax_usage_error

	ldr x21, [x20, #16]
	ldr x20, [x20, #8]
	// We store the file in/out now
	mov x5, #0 // counter
.loop_fd_in:
	ldrb w6, [x20, x5]
	ldr x11, =fdIn
	strb w6, [x11, x5]
	add x5, x5, #1
	cbz w6, .done_fd_in
	b .loop_fd_in
.done_fd_in:
	mov x5, #0
.loop_fd_out:
	ldrb w6, [x21, x5]
	ldr x11, =fdOut
	strb w6, [x11, x5]
	add x5, x5, #1
	cbz w6, .done_fd_out
	b .loop_fd_out
.done_fd_out:
	mov x5, #0
	
	// Print parsed args
	ldr x10, =fdIn
	ldr x13, =fdOut

	str x10, [sp, #-8]!
	bl dax_printf
	
	str x13, [sp, #-8]!
	bl dax_printf

	mov x10, #0
	mov x13, #0

	add sp, sp, #8 // Just for safety

	str x0, [sp, #-8]!
	
	b exit
