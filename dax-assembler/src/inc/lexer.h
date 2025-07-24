#pragma once

typedef struct {
	const char* source;
	size_t pos;
	int line;
} Lexer;

// Lexer API
void lexer(Lexer* lexer, const char* source_code);
Token next_token(Lexer* lexer);
void free_token(Token token);
