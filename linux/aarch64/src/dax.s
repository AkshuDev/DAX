.include "constants.s"

.section .rodata
usage: .asciz "Usage: dax <input> <output> <-[OPTIONS]>\n"

.section .data
buffer: .skip MAX_FILE_BUF

fdIn: .skip MAX_PATH_BUF
fdOut: .skip MAX_PATH_BUF

.section .text
.global _start
.type _start, %function

_start:
	// Parse the stack for the argc and argv
	mov x29, sp // Save stack frame pointer

	// Load argc
	ldr x10, [sp]
	add x11, sp, #8
	
	cmp x10, #3 // argc = 3 (cmp)
	b.lt dax_usage_error

	ldr x12, [x11, #16]
	ldr x13, [x11, #8]
	// We store the file in/out now
	mov x5, #0 // counter
.loop_fd_in:
	ldrb w6, [x13, x5]
	ldr x14, =fdIn
	strb w6, [x14, x5]
	add x5, x5, #1
	cbz w6, .done_fd_in
	b .loop_fd_in
.done_fd_in:
	mov x5, #0
.loop_fd_out:
	ldrb w6, [x12, x5]
	ldr x14, =fdOut
	strb w6, [x14, x5]
	add x5, x5, #1
	cbz w6, .done_fd_out
	b .loop_fd_out
.done_fd_out:
	mov x5, #0
	mov x0, #0
	mov x11, #0
	mov x12, #0
	mov x13, #0
	mov x14, #0

	// Reg Cleaned for further usage!
	
	// Print parsed args
	adrp x10, fdIn
	add x10, x10, :lo12:fdIn
	adrp x13, fdOut
	add x13, x13, :lo12:fdOut

	mov x0, #0

	str x10, [sp, #-16]! // stack is aligned right now
	
	bl dax_printf

	add sp, sp, #16 // Clean

	str x13, [sp, #-16]!

	bl dax_printf

	bl clean

	add sp, sp, #16 // Clean up

	stp x0, x0, [sp, #-16]!
	
	b exit

exit: // 8 byte value
	ldr x0, [sp]
	add sp, sp, #16
	mov x8, #93
	svc #0

dax_usage_error:
	ldr x1, =usage // char*

	str x1, [sp, #-16]!

	bl dax_printf
	
	add sp, sp, #16

	stp x0, x0, [sp, #-16]!
	b exit

clean:
	mov x1, #0 // x0 is for returns
	mov x2, #0
	mov x3, #0
	mov x4, #0
	mov x5, #0
	mov x6, #0
	mov x7, #0
	mov x8, #0
	mov x9, #0
	mov x10, #0
	mov x11, #0
	mov x12, #0
	mov x13, #0
	mov x14, #0
	mov x15, #0
	mov x16, #0
	mov x17, #0
	mov x18, #0
	mov x19, #0
	mov x20, #0
	mov x21, #0
	mov x22, #0
	mov x23, #0
	mov x24, #0
	mov x24, #0
	mov x25, #0
	mov x26, #0
	mov x27, #0
	mov x28, #0

	ret
