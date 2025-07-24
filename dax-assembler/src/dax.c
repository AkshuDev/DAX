#include "inc/dax-libs.h"
#include "inc/utils.h"
#include "inc/lexer.h"

int assemble(dax_config_internal_t* config) {
	dax_header_t hdr = {
		.Magic = "DAXF",
		.version = 1,
		.section_count = 0,
		.reserved = NULL,
		.EntryPoint = 0
	}

	FILE* fdIn = fopen(config->input_file, "r");
	if (!fdIn) {
		fprintf(stderr, "Unable to read file - [%s]\n", config->input_file);
		return UNABLE_TO_READ_ERRC;
	}

	// Read file into mem
	fseek(fdIn, 0, SEEK_END);
	long fsize = ftell(fdIn); // Get file size

	rewind(fdIn);

	char* src = malloc(fsize + 1);
	fread(src, 1, fsize, fdIn);
	source[fsize] = '\0';
	fclose(fdIn);

	// Lexer / Parser
	printf("Parsing code ...\n");
	
	Lexer lexer_;
	lexer(&lexer_, src);

	Token tok;
	do {
		tok = next_token(&lexer_);
		free_token(tok);
	} while (tok.type != TOKEN_EOF);

	return 0;
}

int main(int argc, char** argv) {
	if (argc < 3) {
		fprintf(stderr, USAGE_STR);
		return USAGE_ERRC;
	}

	dax_config_internal_t daxasm_config = {
		.input_file = argv[1],
		.output_file = argv[2],
		.syntax = SYNTAX_NASM,
		.entry_label = "_start",
		.dump_hex = false,
		.emit_header = true
	};
	
	if (argc > 3) {
		for (int i = 3;i < argc; i++){
			if (!strcmp(argv[i], "-e") && i + 1 < argc) {
				daxasm_config.entry_label = argv[i++];
			}
			else if (!strcmp(argv[i], "-s") && i + 1 < argc) {
				const char* style = argv[i++];

				if (!strcmp(style, "nasm")) daxasm_config.syntax = SYNTAX_NASM;
				else if (!strcmp(style, "gas")) daxasm_config.syntax = SYNTAX_GAS;
				else {
					fprintf(stderr, "Unknown Syntax - [%s]\n", style);
					return UNKNOWN_ARG_ERRC;
				}
			}
			else if (!strcmp(argv[i], "--dump-hex")){
				daxasm_config.dump_hex = true;
			}
			else if (!strcmp(argv[i], "--no-header")) {
				daxasm_config.emit_header = false;
			}
			else {
				fprintf(stderr, "Unknown Option - [%s]\n", argv[i]);
				return UNKNOWN_ARG_ERRC;
			}
		}
	}

	// --- Debug Output ---
	printf("Input File: %s\n", daxasm_config.input_file);
	printf("Output File: %s\n", daxasm_config.output_file);
	printf("Syntax: %s\n", daxasm_config.syntax == SYNTAX_NASM ? "NASM" : "GAS");
	printf("Entry Label: %s\n", daxasm_config.entry_label);
	printf("Dump HEX: %s\n", daxasm_config.dump_hex ? "Yes" : "No");
	printf("No Headers: %s\n", daxasm_config.emit_header ? "No" : "Yes");

	printf("\nStarting to Assemble...\n");

	assemble(&daxasm_config);

	return 0;
}
