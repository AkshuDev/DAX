// AkshuDev!
.include "constants.s"

.section .text
.global dax_openf
.global dax_closef
.global dax_writef
.global dax_readf

dax_openf: // int, char*, int, mode_t (dirfd, path, flags, mode)
	stp x29, x30, [sp, #-16]!
	mov x29, sp // Save stack frame

	ldr x0, [sp, #16] // dirfd
	ldr x1, [sp, #24] // path
	ldr x2, [sp, #32] // flags
	ldr x3, [sp, #48] // mode

	mov x8, SYS_openat // openat
	svc #0

	ldp x29, x30, [sp], #16

	ret

dax_closef: // int (fd)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x0, [sp, #16]

	mov x8, SYS_close
	svc #0

	ldp x29, x30, [sp], #16
	ret

dax_writef: // int, void*, size_t (fd, buffer, count)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x0, [sp, #16] // fd
	ldr x1, [sp, #24] // buffer
	ldr x2, [sp, #32] // count

	mov x8, SYS_write
	svc #0

	ldp x29, x30, [sp], #16
	ret

dax_readf: // int, void*, size_t (fd, buffer, count)
	stp x29, x30, [sp, #-16]!
	mov x29, sp

	ldr x0, [sp, #16] // fd
	ldr x1, [sp, #24] // buffer
	ldr x2, [sp, #32] // count

	mov x8, SYS_read
	svc #0

	ldp x29, x30, [sp], #16
	ret
