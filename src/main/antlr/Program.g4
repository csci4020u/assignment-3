grammar Program;

@header {
  import java.util.*;
}

@members {
    public int plusCounter = 0;
    public int multCounter = 0;
}

program
  : (expr NL)+ EOF
  ;

expr
  : expr '+' expr
  | expr '*' expr
  | number
  | '(' expr ')'
  ;

number
  : FLOAT
  | INT
  ;

WHITESPACE : (' ' | '\t' )+ -> skip;
NL : ('\n' | '\r')+;
FLOAT : [0-9] ('.' [0-9]*);
INT : [0-9]+;
STRING : '"' (~('"'))* '"' ;
ID : ('a' .. 'z' | 'A' .. 'Z')+;
