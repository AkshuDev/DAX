.section .text
.global dax_print
.global dax_strlen
.global dax_printf

dax_print:
	// char*, int (ptr, size)
	stp x29, x30, [sp, #-16]! // Save the frame and ret addr
	mov x29, sp //New frame

	// Load params
	ldr x1, [sp, #16]
	ldr x2, [sp, #24]

	// Print
	mov x0, #1 // stdout
	mov x8, #64
	svc #0

	// Return
	sub sp, sp, #8
	str x0, [sp]

	ldp x30, x29, [sp], #16

	ret

dax_strlen:
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x10, [sp, #16]
	mov x11, #0
.loop:
	ldrb w2, [x10, x11]
	cbz w2, .done
	add x11, x11, #1
	b .loop
.done:
	sub sp, sp, #8
	str x11, [sp]

	ldp x30, x29, [sp], #16
	ret

dax_printf:
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x10, [sp, #16]
	str x10, [sp, #-8]!

	bl dax_strlen

	ldr x11, [sp]
	add sp, sp, #8

	ldr x10, [sp, #16]
	
	str x11, [sp, #-8]!
	str x10, [sp, #-8]!

	bl dax_print

	add sp, sp, #16

	ldp x29, x30, [sp]
	ret
