ENTRY(_start)

PHDRS
{
    text PT_LOAD FLAGS(5); /* R+X */
    data PT_LOAD FLAGS(6); /* R+W */
}

SECTIONS {
	. = 0x401000;

	.text : ALIGN(0x1000) {
		*(.text)
	} :text

	.rodata : ALIGN(0x1000) {
		*(.rodata)
	} :text

	.data : ALIGN(0x1000) {
		*(.data)
	} :data

	.bss : ALIGN(0x1000) {
		*(.bss)
		*(COMMON)
	} :data

	/DISCARD/ : {
		*(.comment)
		*(.note*)
		*(.eh_frame)
		*(.got*)
		*(.got.plt)
		*(.dynamic)
		*(.interp)
		*(.dyn*)
	}
}
