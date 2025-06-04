/*
CSC 430: Assignment 8

Using Dart to implement the QTUM language
*/



/*
Defining an ExprC as an abstract class

All the subtypes of ExprC's will extend this abstract class instead
of being a part of a union type
*/
abstract class ExprC {}

class NumC extends ExprC {
  // defines an instance variable called "n" that is a double
  final double n;
  
  // constructor repsonsible for making an instance of a NumC
  NumC(this.n);
}

class StrC extends ExprC {
  final String s;

  StrC(this.s);
}

class IdC extends ExprC {
  // Symbols are replaced with strings
  final String id;

  IdC(this.id);
}

class IfC extends ExprC {
  final ExprC test;
  final ExprC thenExpr;
  final ExprC elseExpr;

  IfC(this.test, this.thenExpr, this.elseExpr);
}

class LamC extends ExprC {
  final List<String> params;
  final ExprC body;

  LamC(this.params, this.body);
}

class AppC extends ExprC {
  final ExprC lamb;
  final List<ExprC> params;

  AppC(this.lamb, this.params);
}

class SeqC extends ExprC {
  final List<ExprC> lst;

  SeqC(this.lst);
}



/*
Defining a Value as an abstract class

Subtypes will also extend this abstract class instead of 
being in a union type
*/
abstract class Value {}

class NumV extends Value {
  final double n;

  NumV(this.n);
}

class StrV extends Value {
  final String s;

  StrV(this.s);
}

class BoolV extends Value {
  final bool b;

  BoolV(this.b); 
}

class PrimV extends Value {
  final String s;

  PrimV(this.s);
}

class CloV extends Value {
  final List<String> params;
  final ExprC body;
  final Env env;

  CloV(this.params, this.body, this.env);
}



/*
Defining Bindings, Environments, and the top level QTUM environment
*/
class Binding {
  final String id;
  final Value val;

  Binding(this.id, this.val);
}

class Env {
  final List<Binding> bindings;

  Env(this.bindings);
}

final topEnv = Env([
  Binding('+', PrimV('+')),
  Binding('-', PrimV('-')),
  Binding('*', PrimV('*')),
  Binding('/', PrimV('/')),
  Binding('<=', PrimV('<=')),
  Binding('substring', PrimV('substring')),
  Binding('strlen', PrimV('strlen')),
  Binding('equal?', PrimV('equal?')),
  Binding('true', BoolV(true)),
  Binding('false', BoolV(false)),
  Binding('error', PrimV('error')),
  Binding('println', PrimV('println')),
  Binding('read-num', PrimV('read-num')),
  Binding('read-str', PrimV('read-str')),
  Binding('++', PrimV('++'))]);

void main() {
  print('Testing dart and creating base file.');
}