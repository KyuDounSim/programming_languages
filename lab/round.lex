/* Lab06 exercise skeleton */

%option noyywrap

%{
#include <stdio.h>
%}
/* Add your flex rules here */
%%
[a-z]	{printf("%c", *yytext - 32);}
[A-Z]	{printf("%c", *yytext + 32);}
.	{printf("*");}
%%

int main(int argc, char **argv){
    yylex();
    return 0;
}
