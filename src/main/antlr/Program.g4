grammar Program;

@header {
  import java.util.*;
}

program 
  returns [Code code]
  : block EOF {$code = $block.code;}
  ;

block
  returns [Code code]
  @init {
    $code = Program.empty();
  }
  : (
    stmt        { Program.add($code, $stmt.code); }
    NL
    )+
  ;


stmt
  returns [Code code]
  : expr        { $code = Print.expr($expr.code); }
  | print       { $code = $print.code; }
  | assignment  { $code = $assignment.code; }
  | branch      { $code = $branch.code; }
  ;

print
  returns [Code code]
  @init {
    $code = Print.empty();
  }
  : 'print' 
    (
    output      { Print.add($code, $output.code); }
    )+
  ;

output
  returns [StringCode code]
  : STRING      { $code = Output.string($STRING.text); }
  | expr        { $code = Output.expr($expr.code); }
    (':' INT    { $code = Output.expr($expr.code, $INT.text); }
    )?
  ;

assignment
  returns [Code code]
  : 'let' ID '=' expr { $code = Assignment.make($ID.text, $expr.code); }
  ;

branch
  returns [Code code]
  : 'if' cond '{' NL
    block
    '}'
    (
    'else' '{' NL
    block
    '}'
    )
  ;

cond
  returns [Code code]
  : expr '<' expr
  | expr '==' expr
  | expr '>' expr
  | '(' cond ')'
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
  | ID                        { $code = Expr.variable($ID.text); }
  ;

number
  returns [Code code]
  : FLOAT       { $code = Literal.num($FLOAT.text); }
  | INT         { $code = Literal.num($INT.text); }
  ;

WHITESPACE : (' ' | '\t' )+ -> skip;
NL : ('\n' | '\r')+;
FLOAT : [0-9] ('.' [0-9]*);
INT : [0-9]+;
STRING : '"' (~('"'))* '"' ;
ID : ('a' .. 'z' | 'A' .. 'Z')+;
