.section .text
.global dax_print
.global dax_strlen
.global dax_printf

// 16 byte params only

dax_print:
	// char*, int (ptr, size)
	stp x29, x30, [sp, #-16]! // Save the frame and ret addr
	mov x29, sp //New frame

	// Load params
	ldr x1, [sp, #16]
	ldr x2, [sp, #32]

	// Print
	mov x0, #1 // stdout
	mov x8, #64
	svc #0

	// Return
	mov x0, #0

	ldp x30, x29, [sp], #16

	ret

dax_strlen:
	// char* (ptr)
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
	mov x0, #0

	ldp x30, x29, [sp], #16
	ret

dax_printf:
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x10, [sp, #16]
	str x10, [sp, #-16]!

	bl dax_strlen

	mov x11, x0
	mov x0, #0

	add sp, sp, #16

	ldr x10, [sp, #16]
	
	str x11, [sp, #-16]!
	str x10, [sp, #-16]!

	bl dax_print

	add sp, sp, #32

	ldp x29, x30, [sp]
	ret
