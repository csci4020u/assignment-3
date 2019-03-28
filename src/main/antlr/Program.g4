grammar Program;

@header {
  import java.util.*;
}

program 
  returns [Code code]
  @init {
    $code = Program.emptyProgram();
  }
  : (
    stmt        { $code = Program.add($code, $stmt.code); }
    NL
    )+ EOF
  ;

stmt
  returns [Code code]
  : expr        { $code = $expr.code; }
  | print       { $code = $expr.code; }
  ;

print
  returns [Code code]
  : 'print' (output)+
  ;

output
  returns [StringCode code]
  : STRING      { $code = Output.string($STRING.text); }
  | expr        { $code = Output.expr($expr.code); }
    (':' INT    { $code = Output.expr($expr.code, $INT.text); }
    )?
  ;

expr
  returns [Code code]
  : e1=expr '^' e2=expr       { $code = Expr.pow($e1.code, $e2.code); }
  | e1=expr '*' e2=expr       { $code = Expr.mul($e1.code, $e2.code); }
  | e1=expr '/' e2=expr       { $code = Expr.div($e1.code, $e2.code); }
  | e1=expr '+' e2=expr       { $code = Expr.plus($e1.code, $e2.code); }
  | e1=expr '-' e2=expr       { $code = Expr.sub($e1.code, $e2.code); }
  | '-' expr                  { $code = Expr.neg($expr.code); }
  | '(' expr ')'              { $code = $expr.code; }
  | number                    { $code = $number.code; }
  ;

number
  returns [Code code]
  : FLOAT
  | INT
  ;

WHITESPACE : (' ' | '\t' )+ -> skip;
NL : ('\n' | '\r')+;
FLOAT : [0-9] ('.' [0-9]*);
INT : [0-9]+;
STRING : '"' (~('"'))* '"' ;
ID : ('a' .. 'z' | 'A' .. 'Z')+;
