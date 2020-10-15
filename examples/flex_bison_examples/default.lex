/* Example: To demonstrate the simplest lex file */

%option noyywrap

%%
%%

int main(int argc, char **argv)
{
   yylex();
   return 0;
}
