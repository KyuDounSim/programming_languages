/* Example: To demonstrate the use of ECHO and REJECT directives */

%option noyywrap

%{
#include <stdio.h>
%}

%%

a     |
ab    |
abc   |
abcd  ECHO; REJECT;
.|\n  printf("xx%c", *yytext);
 
%%

int main(int argc, char **argv)
{
   yylex();
   return 0;
}
