/* reverse polish notation calculator */

%{
#define YYSTYPE double
#include <math.h>
  using namespace std;
#include <iostream>
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
    | exp '\n' { cout << $1 << endl; }
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
	cout << s << endl;
	return 0;
}
