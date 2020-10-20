bison -d regex.y
flex -o regex.lex.c regex.lex
gcc -o regex regex.lex.c regex.tab.c
  