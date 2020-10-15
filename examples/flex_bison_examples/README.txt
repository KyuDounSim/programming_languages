This directory contains 

(A) flex examples:
- count.lex: a lex file for counting #lines, #chars in an input file;
- count-cc1.lex: same functionality as count.lex, with C++ statements;
- count-cc2.lex: same functionality as count.lex, with C++ scanner class;
- default.lex: demonstrate the default lex rule;
- reject.lex: demonstrate the use of ECHO and REJECT directives;
- encrypt.lex: demonstrate the use of yytex;
- cxx.lex: a lex file for C/C++ numbers, strings, and names.

(B) bison examples:
- rpn-calc-all.y: a single bison file to generate a reverse-polish notation calculator;
- rpn-calc-all-cc.y: same functionality as rpn-calc-all.y, with C++ statements;
- rpn-cal.y and rpn-calc.lex: a bison file and a lex file to generate a reverse-polish notation calculator;
- infix-calc.y and infix-calc.lex: a bison file and a lex file to generate an infix notation calculator 
with specified operator associativity and precedence.
