#pragma once

#define USAGE_STR "Syntax:\n\tdax-asm <input> <output> <-[OPTIONS]>\n\nOptions:\n\t-s nasm|gas\tSelect syntax (default: nasm)\n\t-e <entry>\tEntry Label (default: _start|(label defined in .text section)\n\t--dump-hex\tPrint the hex dump of the output\n\t--no-header\tOutput flat binary without headers (NOTE: Cannot be used with dax-convertor/dax | dax-parser)\n"

// Internal structs
typedef enum {
	SYNTAX_NASM,
	SYNTAX_GAS
} dax_syntax_internal_t;

typedef struct {
	const char* input_file;
	const char* output_file;
	dax_syntax_internal_t syntax;
	char* entry_label;
	bool dump_hex;
	bool emit_header;
} dax_config_internal_t;

// Tokens
typedef enum {
	TOKEN_EOF,
	TOKEN_NEWLINE,
	TOKEN_IDENTIFIER,
	TOKEN_DIRECTIVE,
	TOKEN_REGISTER,
	TOKEN_COMMA,
	TOKEN_DOLLAR,
	TOKEN_HASH,
	TOKEN_NUMBER,
	TOKEN_STRING,
	TOKEN_INSTRUCTION,
	TOKEN_LPAREN,
	TOKEN_RPAREN,
	TOKEN_LBRACKET,
	TOKEN_RBRACKET,
	TOKEN_PLUS,
	TOKEN_MINUS,
	TOKEN_ASTERISK,
	TOKEN_SLASH
	TOKEN_PERCENT,
	TOKEN_COMMENT,
	TOKEN_LABEL,
	TOKEN_SECTION,
	TOKEN_UNKNOWN
} TokenType;

typedef struct {
	TokenType type;
	char* lexeme;
	int line;
} Token;

// Errors
#define USAGE_ERRC 1
#define UNABLE_TO_WRITE_ERRC 2
#define UNABLE_TO_READ_ERRC 3
#define UNKNOWN_ERRC 4
#define UNKNOWN_ARG_ERRC 5
