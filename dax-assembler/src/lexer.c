#include "inc/dax-libs.h"

#include <ctype.h>

void lexer(Lexer* lexer, const char* source_code) {
	lexer->source = source_code;
	lexer->pos = 0;
	lexer-> line = 1;
}

static char peek(Lexer* lexer) {
	return lexer->source[lexer->pos];
}

static char advance(Lexer* lexer) {
	return lexer->source[lexer->pos++];
}

static int is_at_end(Lexer* lexer) {
	return lexer->source[lexer->pos] == '\0';
}

static Token make_token(Lexer* lexer, TokenType type, const char* start, size_t length) {
	Token token;
	token.type = type;
	token.lexeme = strndup(start, length);
	token.line = lexer->line;
	return token;
}

void free_token(Token token) {
	if (token.lexeme) free(token.lexeme);
}

Token next_token(Lexer* lexer) {
	while (!is_at_end(lexer)) {
		char c = peek(lexer);

		if (c == '\n') {
			advance(lexer);
			lexer->line++;
			return make_token(lexer, TOKEN_NEWLINE, "\n", 1);
		}

		if (isspace(c)) {
			advance(lexer);
			continue;
		}

		if (isalpha(c) || c == '.' || c == '_') {
			size_t start = lexer->pos;
			while (isalnum(peek(lexer)) || peek(lexer) == '.' || peek(lexer) == '_') advance(lexer);

			size_t len = lexer->pos - start;
			const char* word = lexer->source + start;

			if (word[0] == '.') return make_token(lexer, TOKEN_DIRECTIVE, word, len);
			else return make_token(lexer, TOKEN_IDENTIFIER, word, len);
		}

		if (isdigit(c)) {
			size_t start = lexer->pos;
			while (isdigit(peek(lexer))) advance(lexer);
			return make_token(lexer, TOKEN_NUMBER, lexer->source + start, lexer->pos - start);
		}

		switch (c) {
			case ',': advance(lexer); return make_token(lexer, TOKEN_COMMA, ",", 1);
			case ':': advance(lexer); return make_token(lexer, TOKEN_COLON, ":", 1);
			case '$': advance(lexer); return make_token(lexer, TOKEN_DOLLAR, "$", 1);
			case '#': advance(lexer); return make_token(lexer, TOKEN_HASH, "#", 1);
			case '(': advance(lexer); return make_token(lexer, TOKEN_LPAREN, "(", 1);
			case ')': advance(lexer); return make_token(lexer, TOKEN_RPAREN, ")", 1);
			case '[': advance(lexer); return make_token(lexer, TOKEN_LBRACKET, "[", 1);
			case ']': advance(lexer); return make_token(lexer, TOKEN_RBRACKET, "]", 1);
			case '+': advance(lexer); return make_token(lexer, TOKEN_PLUS, "+", 1);
			case '-': advance(lexer); return make_token(lexer, TOKEN_MINUS, "-", 1);
			case '*': advance(lexer); return make_token(lexer, TOKEN_ASTERISK, "*", 1);
			case '/': advance(lexer); return make_token(lexer, TOKEN_SLASH, "/", 1);
			case '%': advance(lexer); return make_token(lexer, TOKEN_PERCENT, "%", 1);
			case '"': {
				advance(lexer);
				size_t start = lexer->pos;
				while (peek(lexer) != "" && !is_at_end(lexer)) advance(lexer);
				size_t len = lexer->pos - start;
				advance(lexer);
				return make_token(lexer, TOKEN_STRING, lexer->source + start, len);
			}
			default:
				advance(lexer);
				return make_token(lexer, TOKEN_UNKNOWN, &c, 1);
		}
	}

	return make_token(lexer, TOKEN_EOF, "", 0);
}
