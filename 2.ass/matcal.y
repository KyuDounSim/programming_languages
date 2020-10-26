%{
#define YYSTYPE void*
#include <stdio.h>
#include "helpers.h"
%}

/* Define tokens here */
%token T_NL T_INT
 /********** Start: add your tokens here **********/
%token LSB RSB LCB RCB SEMICOLON COMMA ADD SUB MUL
%left ADD SUB 
%left MUL
%nonassoc LCB RCB
 /********** End: add your tokens here **********/

%%
input:  /* empty */ 
    |   input line;

line:   T_NL 
    |   expr T_NL { print_matrix($1); };

/********** Start: add your grammar rules here **********/
expr:   expr ADD expr {$$ = matrix_add($1, $3);}
    |   expr SUB expr {$$ = matrix_sub($1, $3);}
    |   sub_expr      {$$ = $1;};

sub_expr:    sub_expr MUL unit {$$ = matrix_mul($1, $3);}
        |    unit              {$$ = $1;};

unit:   LCB expr RCB {$$ = $2;}
    |   matrix    {$$ = $1;};

matrix: LSB ROWS RSB {$$ = $2;}
      | ROW          {$$ = $1;};

ROWS: ROWS SEMICOLON ROW {$$ = append_row($1, $3);}
    | ROW {$$ = $1;};

ROW: ROW COMMA element {$$ = append_element($1, $3);}
   | element           {$$ = $1;};
/********** End: add your grammar rules here **********/

element:  T_INT { $$ = element2matrix((long)$1); };
%%

int main() { return yyparse(); }
int yyerror(const char* s) { printf("%s\n", s); return 0; }
