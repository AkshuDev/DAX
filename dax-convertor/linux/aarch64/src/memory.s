.include "constants.s"

.section .text
.global dax_malloc
.global dax_calloc
.global dax_realloc
.global dax_free

dax_malloc: // size_t (size)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x7, [sp, #16]

	// Align size to 4096 (page size)
	mov x1, #4095
	add x7, x7, x1
	bic x7, x7, x1 // x7 = aligned size

	mov x0, x7

	// setup mmap syscall
	mov x1, x0 // length
	mov x0, NULL // addr = NULL
	mov x2, PROT_READ_WRITE
	mov x3, MAP_PRIVATE_ANONYMOUS
	mov x4, #-1 // fd = -1
	mov x5, #0 // offset = 0
	
	mov x8, SYS_mmap

	stp x7, x0, [sp, #-16]!
	mov x10, x0
	bl dax_m_addentry
	add sp, sp, #16

	mov x0, x10
	mov x10, #0 // clean

	ldp x29, x30, [sp], #16
	ret

dax_calloc: // size_t (size) NOTE: calloc works like malloc here
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x0, [sp, #16]
	mov x1, #0

	stp x1, x2, [sp, #-16]!
	bl dax_malloc
	add sp, sp, #16

	ldp x29, x30, [sp], #16
	ret

dax_realloc: // void*, size_t (pointer, new_size)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x7, [sp, #16] // pointer
	ldr x1, [sp, #24] // new_size

	sub sp, sp, #16
	str x7, [sp]

	bl dax_m_getentrysize
	add sp, sp, #16

	mov x9, x0 // old_size

	sub sp, sp, #16
	str x1, [sp]

	bl dax_malloc
	add sp, sp, #16

	// Copy memory
	mov x4, x0 // dest
	mov x5, x7 // src
	mov x6, x9 // count

.copy_loop:
	ldrb w7, [x5], #1
	strb w7, [x4], #1
	subs x6, x6, #1
	b.ne .copy_loop

	stp x10, x7, [sp, #-16]!
	bl dax_free
	add sp, sp, #16

	ldp x29, x30, [sp], #16
	ret

dax_free: // void* (ptr)
	stp x29, x30, [sp, #-16]!
	mov x29, sp 

	ldr x7, [sp, #16]
	
	sub sp, sp, #16
	str x7, [sp]

	bl dax_m_getentrysize // return in x0
	add sp, sp, #16

	mov x1, x0
	mov x0, x7

	mov x8, SYS_munmap
	svc #0

	sub sp, sp, #16
	str x7, [sp]

	bl dax_m_removeentry
	add sp, sp, #16

	ldp x29, x30, [sp], #16
	ret
