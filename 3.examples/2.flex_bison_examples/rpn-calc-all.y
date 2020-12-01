/* reverse polish notation calculator */

%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>

int yyerror(const char *s);
int yylex(void);
%}

%token NUM

%% /* grammer rules and actions follow */

  input: /* empty */
     | input line
;

line: '\n'
    | exp '\n' { printf("\t%.10g\n", $1); }
;

exp: NUM { $$ = $1; }
   | exp exp '+' { $$ = $1 + $2; }
   | exp exp '-' { $$ = $1 - $2; }
   | exp exp '*' { $$ = $1 * $2; }
   | exp exp '/' { $$ = $1 / $2; }
   | exp exp '^' { $$ = pow($1, $2); }
   | exp 'n' { $$ = -$1; }
;

%% /* additional C code */

#include <ctype.h>

int yylex(void) {
	int c;

	/* skip white spaces */
	while ((c = getchar()) == ' ' || c == '\t');

	/* process numbers */
	if (c == '.' || isdigit(c)) {
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUM;
	}

	if (c == EOF) return 0;
	return c;
}

int main() {
	return yyparse();
}

int yyerror(const char* s) {
	printf("%s\n\n\n\n", s);
	return 0;
}
