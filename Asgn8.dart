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



/* ============================================================
Defining Bindings, Environments, and the top level QTUM environment
============================================================= */
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


/* ============================================================
Defining Bindings, Environments, and the top level QTUM environment
============================================================= */
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



/* ============================================================
Defining the interp function which will take as inputs an ExprC and
an Environment and returnn a Value

This section includes helper functions for interp including:
  - lookup
  - extend
  - handle-PrimV
============================================================= */

  Value interp(ExprC e, Env env) {
    if (e is NumC) {
      return NumV(e.n);

    } else if (e is StrC) {
      return StrV(e.s);

    } else if (e is IdC) {
      return lookup(e.id, env);

    } else if (e is IfC) {
      final Value testValue = interp(e.test, env);
      if (testValue is BoolV) {
        if (testValue.b) {
          return interp(e.thenExpr, env);
        } else {
          return interp(e.elseExpr, env);
        }
      } throw Exception('The first clause of an if statement must evaluate to a boolean');

    } else if (e is LamC) {
      return CloV(e.params, e.body, env);

    } else if (e is AppC) {
      // defining the Value corresponding to interpreting the first clause of an AppC
      final Value lambValue = interp(e.lamb, env);
      // defining a list of Values corresponding to interpreting the list of ExprC's
      // that are the AppC's parameters
      final List<Value> argValues = e.params.map((ExprC e) => interp(e, env)).toList();

      if (lambValue is CloV) {
        // extending the environment with new identifier bindings
        Env newEnv = extend(lambValue.params, argValues, env);
        return interp(lambValue.body, newEnv);
      } else if (lambValue is PrimV) {
        // TODO: implement a handle-PrimV function and replace the placeholder with a call to it
        return NumV(0);
      } throw Exception('Not a valid function application: $lambValue');

    } else if (e is SeqC) {
      final List<Value> valSeq = e.lst.map((ExprC e) => interp(e, env)).toList();
      return valSeq.last;
    } throw Exception('Not a valid expression, cannot evaluate: $e');
  }

// lookup: a helper function that searches for a "symbol" (string
// in this case) in the environment and returns the corresponiding
// value

Value lookup(String id, Env env) {
  // NOTE: different from Racket due to the existence of nice for loops
  for(var binding in env.bindings) {
    if (binding.id == id) {
      return binding.val;
    }
  } 
  throw Exception('Unbound identifier: $id');
}

// extend: a helper function that takes in a list of names and a list of
// values and extends the current environment with the correspoinding
// bindings
Env extend(List<String> nameList, List<Value> valList, Env env) {
  if (nameList.length == valList.length) {
    for (int i = 0; i < nameList.length;) {
      env.bindings.add(Binding(nameList[i], valList[i]));
      return env;
    }
  } throw Exception('Number of identifiers and values are not the same???');
}

// handlePrimV: a helper function that takes in a string and a list of values
// and returns the proper result depending on the symbol
Value handlePrimV(String op, List<Value> args) {
  if (op == '+') {
    if (args.length == 2 && (args[0] is NumV) && (args[1] is NumV)) {
      // can cast since we checked above
      NumV n1 = (args[0] as NumV);
      NumV n2 = (args[1] as NumV); 
      return NumV(n1.n + n2.n);
    }
  } else if (op == '-') {
    if (args.length == 2 && (args[0] is NumV) && (args[1] is NumV)) {
      // can cast since we checked above
      NumV n1 = (args[0] as NumV);
      NumV n2 = (args[1] as NumV); 
      return NumV(n1.n - n2.n);
    }
  } else if (op == '*') {
    if (args.length == 2 && (args[0] is NumV) && (args[1] is NumV)) {
      // can cast since we checked above
      NumV n1 = (args[0] as NumV);
      NumV n2 = (args[1] as NumV); 
      return NumV(n1.n * n2.n);
    }
  } else if (op == '/') {
    if (args.length == 2 && (args[0] is NumV) && (args[1] is NumV) && (args[1] != 0)) {
      // can cast since we checked above
      NumV n1 = (args[0] as NumV);
      NumV n2 = (args[1] as NumV); 
      return NumV(n1.n / n2.n);
    }
  } else if (op == '<=') {
    if (args.length == 2 && (args[0] is NumV) && (args[1] is NumV)) {
      // can cast since we checked above
      NumV n1 = (args[0] as NumV);
      NumV n2 = (args[1] as NumV); 
      return BoolV(n1.n <= n2.n);
    }
  } else if (op == 'substring') {
    if (args.length == 3 
        && (args[0] is StrV) && (args[1] is NumV) && (args[2] is NumV)) {
      StrV s1 = (args[0] as StrV);
      NumV n1 = (args[1] as NumV);
      NumV n2 = (args[2] as NumV);

      //TODO: include checks on indicies being in bounds and that they are ints

      return StrV(s1.s.substring(n1.n, n2.n));
    }
  } throw Exception('Not a valid primitive operator: $op');
}



void main() {
  print('Testing dart and creating base file.');
}