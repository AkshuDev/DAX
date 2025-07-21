ENTRY(_start)

SECTIONS {
	. = 0x400000;

	.text : {
		*(.text)
	}

	.rodata : {
		*(.rodata)
	}

	.data : {
		*(.data)
	}

	.bss : {
		*(.bss)
		*(COMMON)
	}

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
