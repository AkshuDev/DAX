#pragma once

typedef struct {
	char Magic[4]; // DAXF
	uint8_t version; // Format Version
	uint8_t section_count; // no. of sections
	uint16_t reserved; // For now
	uint32_t EntryPoint; // Offset to the entry point
} dax_header_t;

typedef struct {
	char name[8]; // Section name
	uint32_t offset; // Offset to section data
	uint32_t size; // Size of the data
	uint32_t flags; // Flags
} dax_section_t;

typedef struct {
	char *mnemonic;
	uint8_t opcode;
	uint8_t modrm_required;
} instr_encoding_t;
