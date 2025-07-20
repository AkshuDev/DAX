.include "constants.s"

.section .bss
.align 4
mem_map:
	.skip 2048 // 128 entries with 16 bytes each

.section .text
.global dax_m_addentry
.global dax_m_getentrysize
.global dax_m_removeentry

dax_m_addentry: // void*, size_t (ptr, size)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x0, [sp, #16] // ptr
	ldr x1, [sp, #24] // size

	mov x2, #0 // index
	adr x3, mem_map
.find_slot:
//	ldr x4, [x3, x2, lsl #4] // load addr field
	cbz x4, .insert_here
	add x2, x2, #1
	cmp x2, #128
	b.lt .find_slot
	b .end // no slots left
.insert_here:
//	str x0, [x3, x2, lsl #4] // addr
//	str x1, [x3, x2, lsl #4] // size (addr + 8)

dax_m_getentrysize: // void* (ptr)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x1, [sp, #16] // ptr
	mov x2, #0
	adr x3, mem_map
.search_loop:
//	ldr x4, [x3, x2, lsl #4]
	cmp x4, x1
	b.eq .found
	add x2, x2, #1
	cmp x2, #128
	b.lt .search_loop
.not_found:
	mov x0, #0
	b .end
.found:
//	ldr x0, [x3, x2, lsl #4] // size = addr + 8

dax_m_removeentry: // void* (ptr)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x1, [sp, #16]
	mov x2, #0
	adr x3, mem_map
.search_remove:
//	ldr x4, [x3, x2, lsl #4]
	cmp x4, x1
	b.eq .do_remove
	add x2, x2, #1
	cmp x2, #128
	b.lt .search_remove
	b .end
.do_remove:
	mov x5, #0
//	str x5, [x3, x2, lsl #4] // Clear addr
//	str x5, [x3, x2, lsl #4] // clear size

.end:
	ldp x29, x30, [sp], #16
	ret
