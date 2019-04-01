import java.util.*;

class Program implements Code {
    public double eval(Map<String, Double> scope) {
        for(Code c : this.list) {
            c.eval(scope);
        }
        return 0.0;
    }
    List<Code> list;

    static Program empty() {
        Program p = new Program();
        p.list = new ArrayList<Code>();
        return p;
    }
    static void add(Code p, Code c) {
        ((Program)p).list.add(c);
    }
}

class Print implements Code {
    List<StringCode> list;
    public double eval(Map<String, Double> scope) {
        for(StringCode s : this.list) {
            System.out.print(s.eval(scope) + " ");
        }
        System.out.println();
        return 0.0;
    }

    static Print empty() {
        Print x = new Print();
        x.list = new ArrayList<StringCode>();
        return x;
    }

    static void add(Code x, StringCode c) {
        ((Print)x).list.add(c);
    }

    static Code expr(Code c) {
        Print p = empty();
        add(p, Output.expr(c));
        return p;
    }
}

class Output {
    static StringCode string(String text) {
        return new StringCode() {
            public String eval(Map<String, Double> scope) {
                return text.substring(1, text.length()-1);
            }
        };
    }
    static StringCode expr(Code code) {
        return new StringCode() {
            public String eval(Map<String, Double> scope) {
                return (new Double(code.eval(scope))).toString();
            }
        };
    }
    static StringCode expr(Code code, String precision) {
        return new StringCode() {
            public String eval(Map<String, Double> scope) {
                return String.format("%." + precision + "f", code.eval(scope));
            }
        };
    }
}

class Assignment {
    static Code make(String variable, Code code) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                double result = code.eval(scope);
                scope.put(variable, result);
                return result;
            }
        };
    }
}

class Expr {
    static Code pow(Code x, Code y) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return Math.pow(x.eval(scope), y.eval(scope));
            }
        };
    }
    static Code mul(Code x, Code y) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return x.eval(scope) * y.eval(scope);
            }
        };
    }
    static Code div(Code x, Code y) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return x.eval(scope) / y.eval(scope);
            }
        };
    }
    static Code plus(Code x, Code y) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return x.eval(scope) + y.eval(scope);
            }
        };
    }
    static Code sub(Code x, Code y) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return x.eval(scope) - y.eval(scope);
            }
        };
    }
    static Code neg(Code x) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return -x.eval(scope);
            }
        };
    }
    static Code variable(String variable) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                if(scope.containsKey(variable))
                    return scope.get(variable);
                else
                    return 0.0;
            }
        };
    }
}

class Literal {
    static Code num(String text) {
        return new Code() {
            public double eval(Map<String, Double> scope) {
                return Double.parseDouble(text);
            }
        };
    }
}
