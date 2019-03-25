grammar Program;

@header {
  import java.util.*;
}

program
  : (
    stmt
    NL
    )+ EOF
  ;

stmt
  : expr
  | print
  ;

print
  : 'print' (output { Action.print($output.v); })+ { Action.println(); }
  ;

output
  returns [String v]
  : STRING        { $v = Action.toString($STRING.text); }
  | expr          { $v = Action.toString($expr.v); }
    ( ':' INT     { $v = Action.toString($expr.v, $INT.text); } 
    )?
  ;

expr
  returns [double v]
  @init { $v = 0.0; }
  : e1=expr '^' e2=expr { $v = Math.pow($e1.v, $e2.v); }
  | '-' expr            { $v = - $expr.v; }
  | e1=expr '*' e2=expr { $v = $e1.v * $e2.v; }
  | e1=expr '/' e2=expr { $v = $e1.v / $e2.v; }
  | e1=expr '+' e2=expr { $v = $e1.v + $e2.v; }
  | e1=expr '-' e2=expr { $v = $e1.v - $e2.v; }
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
