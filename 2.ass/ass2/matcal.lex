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
left_square_bracket         [[]
right_square_bracket        []]
left_circle_bracket         [(]
right_circle_bracket        [)]
semicolon                   [;]
comma                       [,]
addition                    [+]
subtraction                 [-]
multiplication              [*]
/********** End: add your definitions here **********/

%%
 /********** Start: add your rules here. **********/

{left_square_bracket}     {return LSB;}
{right_square_bracket}    {return RSB;}
{left_circle_bracket}     {return LCB;}
{right_circle_bracket}    {return RCB;}
{semicolon}               {return SEMICOLON;}
{comma}                   {return COMMA;}
{addition}                {return ADD;}
{subtraction}             {return SUB;}
{multiplication}          {return MUL;}
 /********** End: add your rules here **********/

{integer}       { yylval = (void*)atol(yytext); return T_INT; }
{newline}       { return T_NL; }
{whitespace}    /* ignore white spaces */
%%
