/* lex file for infix notation calculator */
%option noyywrap

%{
#define YYSTYPE double     /* type for bison's var: yylval */
#include <stdlib.h>        /* for atof(const char*) */
#include "infix-calc.tab.h"
%}
    

digits [0-9]
rn     (0|[1-9]+{digits}*)\.?{digits}*
op     [+*^/\-]
ws     [ \t]+  


%%

{rn}   yylval = atof(yytext); return NUM;
{op}   |
\n     return *yytext;
{ws}   /* eats up white spaces */

%%
