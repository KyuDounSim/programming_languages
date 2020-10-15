/* Example: same as the Unix utility "wc". */

%option noyywrap 

%{
int numlines=0, numchars=0;
%}

%%

\n    	++numlines; ++numchars;
.     	++numchars;

%%

int main(int argc, char **argv)
{
   yylex();
   printf("# of lines = %d, # of chars = %d\n", numlines, numchars);

   return 0;
}
