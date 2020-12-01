%option noyywrap
%{
#include <iostream>
  using namespace std;
int numlines=0, numchars=0;
%}

%%
\n    	++numlines; ++numchars;
.     	++numchars;
%%
int main(int argc, char **argv)
{  yylex();
   cout << "# of lines = " << numlines << endl 
        << "# of chars = " << numchars << endl;
   return 0; }
