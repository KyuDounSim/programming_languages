%option noyywrap
%{
#define YYSTYPE void*
#include "matcal.tab.h"
%}

/* Flex definitions */
whitespace      [ \t]+
newline         [\n]
integer         [0-9]+

/********** Start: add your definitions here **********/

matrix          [left_bracket] rows [
left_bracket    [\[]
right_bracket   [\]]


/********** End: add your definitions here **********/

%%
 /********** Start: add your rules here. **********/
 

 /********** End: add your rules here **********/

{integer}       { yylval = (void*)atol(yytext); return T_INT; }
{newline}       { return T_NL; }
{whitespace}    /* ignore white spaces */
%%
