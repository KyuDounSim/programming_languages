/* bison grammar file for infix notation calculator */
%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>


int yyerror(const char *s);
int yylex(void);


%}

%token NUM
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'

%% /* Grammer rules and actions follow */

input: /* empty */
     | input line
     ;

line: '\n'
    | exp '\n' { printf("\t%.10g\n", $1); }
    ;

exp: NUM { $$ = $1; }
   | exp '+' exp { $$ = $1 + $3; }
   | exp '-' exp { $$ = $1 - $3; }
   | exp '*' exp { $$ = $1 * $3; }
   | exp '/' exp { $$ = $1 / $3; }
   | '-' exp %prec NEG { $$ = -$2; }
   | exp '^' exp { $$ = pow($1, $3); }
   | '(' exp ')' { $$ = $2; }
   ;

%%

/* Additional C code */

int main() { return yyparse(); }

int yyerror(const char* s)
{
	printf("%s\n", s);
	return 0;
}
