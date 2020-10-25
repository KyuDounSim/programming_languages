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
digit         [0-9]
element       {integer}
left_square_bracket         [[]
right_square_bracket        []]
semicolon         [;]
comma             [,]
row         {row}{comma}{element} | {element}
rows         {rows}{semicolon}{row} | {row}
matrix         {left_square_bracket}{rows}{row} | {row}
/********** End: add your definitions here **********/

%%
 /********** Start: add your rules here. **********/
 {matrix}       {print_matrix(yytext); return T_INT;}
 /********** End: add your rules here **********/

{integer}       { yylval = (void*)atol(yytext); return T_INT; }
{newline}       { return T_NL; }
{whitespace}    /* ignore white spaces */
%%
