%{
#define YYSTYPE void*
#include <stdio.h>
#include "helpers.h"
%}

/* Define tokens here */
%token T_NL T_INT
 /********** Start: add your tokens here **********/
%left     '+' '-'
%left     '*'
%nonassoc '(' ')'
 /********** End: add your tokens here **********/

%%
input:  /* empty */ 
    |   input line;

line:   T_NL 
    |   expr T_NL { print_matrix($1); };

/********** Start: add your grammar rules here **********/
expression:;
sub_expression:;
unit:;
addition:;
subtraction:;
multiplication:;
left_circle_bracket:;
right_circle_brackiet:;

/********** End: add your grammar rules here **********/

element:  T_INT { $$ = element2matrix((long)$1); };
%%

int main() { return yyparse(); }
int yyerror(const char* s) { printf("%s\n", s); return 0; }
