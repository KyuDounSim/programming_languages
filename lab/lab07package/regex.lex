%option noyywrap
%{
#define YYSTYPE int
#include "regex.tab.h"
#define printToken(desc, str) printf("%8s:%32s\n", desc, str)
%}
char                    [a-z]
star                    [*]
plus                    [+]
question                [?]
left_parenthesis        [(]
right_parenthesis       [)]
nl                      [\n]
ws                      [ \t]+

%%

{char}              {return CHAR;}
{star}              {return STAR;}
{plus}              {return PLUS;}
{question}          {return QUESTION_M;}
{left_parenthesis}  {return LP;}
{right_parenthesis} {return RP;}
{nl}                {return NL;}
{ws}

%%

/* int main(int argc, char **argv){
yylex();
return 0;
} */

/* {char}              { printToken("CHAR", yytext);}
{star}              { printToken("STAR", yytext);}
{plus}              { printToken("PLUS", yytext);}
{question}          { printToken("QUESTION_M", yytext);}
{left_parenthesis}  { printToken("LP", yytext);}
{right_parenthesis} { printToken("RP", yytext);}
{nl}                { printToken("NL", yytext);}
{ws} */