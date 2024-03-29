/* Example: To use a C++ scanner class */

%option noyywrap

%{
#include <iostream>
  using namespace std;
int mylineno=0;
%}

string   \"[^\n"]+\"
ws       [ \t]+

alpha    [A-Za-z]
dig      [0-9]
name     ({alpha}|{dig}|\$)({alpha}|{dig}|[_.\-/$])*
num1     [-+]?{dig}+\.?([eE][-+]?{dig}+)?
num2     [-+]?{dig}*\.{dig}+([eE][-+]?{dig}+)?
number   {num1}|{num2}

%%

{ws}     /* skip blanks and tabs */

"/*"     {
             int c;

             while((c = yyinput()) != 0)
             {
            	if (c == '\n')
                    ++mylineno;
            	else if (c == '*')
                {
               	    if ((c = yyinput()) == '/')
                        break;
                    else
                  	    unput(c);
                 }
               }
           }

{number} cout << "number " << YYText() << '\n';

\n       mylineno++;

{name}   cout << "name " << YYText() << '\n';

{string} cout << "string " << YYText() << '\n';

.        cout << "unrecognized " << YYText() << endl; 


%%

int main(int argc, char** argv)
{
   FlexLexer* lexer = new yyFlexLexer;
/*
   while (lexer->yylex()!=0)
   	;
*/
lexer->yylex();

   return 0;
}
