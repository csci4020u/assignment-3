grammar Program;

@header {
  import java.util.*;
}

program
  : (
    expr 
    NL {Action.print($expr.v);}
    )+ EOF
  ;

expr
  returns [double v]
  @init { $v = 0.0; }
  : e1=expr '*' e2=expr { $v = $e1.v * $e2.v; }
  | e1=expr '+' e2=expr { $v = $e1.v + $e2.v; }
  | number              { $v = $number.v; } 
  | '(' expr ')'        { $v = $expr.v; }
  ;

number 
  returns [double v]
  : FLOAT { $v = Double.parseDouble($FLOAT.text); }
  | INT   { $v = Double.parseDouble($INT.text); }
  ;

WHITESPACE : (' ' | '\t' )+ -> skip;
NL : ('\n' | '\r')+;
FLOAT : [0-9] ('.' [0-9]*);
INT : [0-9]+;
STRING : '"' (~('"'))* '"' ;
ID : ('a' .. 'z' | 'A' .. 'Z')+;
