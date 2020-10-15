/* bison grammar file for reverse-polish notation calculator */

%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>

int yyerror(const char *s);
int yylex(void);

%}

%token NUM


%% /* Grammer rules and actions follow */

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


%%


/* Additional C code */
int main() { return yyparse(); }

int yyerror(const char* s)
{
	printf("%s\n", s);
	return 0;
}
