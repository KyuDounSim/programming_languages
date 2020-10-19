%{
#define YYSTYPE int
#include <stdio.h>
int yyerror(const char*s);
int yylex();
%}

%token CHAR STAR PLUS QUESTION_M LP RP NL

%%

input: /* empty */
| input line;

line: NL
| expr NL               { printf("\t%d\n", $1); };

expr: expr term         {$$ = $1 + $2;}
| term                  {$$ = $1;};

term: unit QUESTION_M   {$$ = 0;}
| unit STAR             {$$ = 0;}
| unit PLUS             {$$ = $1;}
| unit                  {$$ = $1;};

unit: LP expr RP        {$$ = $2; }
| CHAR                  { $$ = 1; };

%%


int main() { return yyparse(); }
int yyerror(const char* s) { printf("%s\n", s); return 0; }

