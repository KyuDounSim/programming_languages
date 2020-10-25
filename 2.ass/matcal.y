%{
#define YYSTYPE void*
#include <stdio.h>
#include "helpers.h"
%}

/* Define tokens here */
%token T_NL T_INT
 /********** Start: add your tokens here **********/
%left '+' '-'
%left '*'
%nonassoc '(' ')'
 /********** End: add your tokens here **********/

%%
input:  /* empty */ 
    |   input line;

line:   T_NL 
    |   expr T_NL { print_matrix($1); };

/********** Start: add your grammar rules here **********/
expr:   expr '+' expr {$$ = matrix_add($1, $3);}
    |   expr '-' expr {$$ = matrix_sub($1, $3);}
    |   sub_expr      {$$ = $1;}
    ;

sub_expr:    sub_expr '*' unit {$$ = matrix_mul($1, $3);}
        |    unit              {$$ = $1;}
        ;

unit:   '(' expr ')' {$$ = $2;}
    |   matrix    {print_matrix($1);}
    ;

/********** End: add your grammar rules here **********/

element:  T_INT { $$ = element2matrix((long)$1); };
%%

int main() { return yyparse(); }
int yyerror(const char* s) { printf("%s\n", s); return 0; }
