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

left_bracket            [[]
right_bracket           []]
left_circle_bracket     [(]
right_circle_bracket    [)]
comma                   [,]
semicolon               [;]
digit                   [0-9]
addition                [+]
subtraction             [-]
multiplication          [*]
element                 {integer}
row                     {row}{comma}{element} | {element}
rows                    {rows}{semicolon}{row} | {row}
matrix                  {left_bracket}{rows}{right_bracket}
/********** End: add your definitions here **********/

%%
 /********** Start: add your rules here. **********/

{left_bracket}          return LB;
{right_bracket}         return RB;
{left_circle_bracket}   return LCB;
{right_circle_bracket}  return RCB;
{comma}                 return COMMA;
{semicolon}             return SEMICOL;
{addition}              return ADD;
{subtraction}           return SUB; 
{multiplication}        return MUL;
{row}                   return ROW;
{rows}                  return ROWS;
{matrix}                return MATRIX;

 /********** End: add your rules here **********/

{integer}       { yylval = (void*)atol(yytext); return T_INT; }
{newline}       { return T_NL; }
{whitespace}    /* ignore white spaces */
%%
