import 'package:test/test.dart';
import '../Asgn8.dart';

//'dart pub get' for packages
// run 'dart test' in cmd line
void main() {
  group('Basic Interp/Serialize Values', () {
    test('interp and serialize evaluate a NumC', () {
      final numExpr = NumC(42.0);
      expect(interp(numExpr, topEnv).serialize(), "42.0");
    });

    test('interp/serialize evaluate a strC', () {
      final strExpr = StrC("hello");
      expect(interp(strExpr, topEnv).serialize(), "hello");
    });

    test('interp/serialize evaluate IfC', () {
      final testTrue = IdC('true');
      final thenExpr = StrC("then");
      final elseExpr = StrC("else");
      final ifThenExpr = IfC(testTrue, thenExpr, elseExpr);
      expect(interp(ifThenExpr, topEnv).serialize(), "then");
      final testFalse = IdC('false');
      final ifElseExpr = IfC(testFalse, thenExpr, elseExpr);
      expect(interp(ifElseExpr, topEnv).serialize(), "else");
    });

    test('interp a basic lamC + serialized a closure', () {
      // basic test
      final lamExpr = LamC(['a', 'b', 'c'], NumC(5));
      expect(interp(lamExpr, topEnv).serialize(), "#<procedure>");
    });
  });

  group('interpreting primitive functions', () {
    test('Interpreting an addition', () {
      final addC = AppC((IdC('+')), [NumC(5), NumC(5)]);
      expect(interp(addC, topEnv).serialize(), "10.0");
    });

    test('Interpreting subtraction', () {
      final subC = AppC((IdC('-')), [NumC(5), NumC(5)]);
      expect(interp(subC, topEnv).serialize(), "0.0");
    });

    test('Interpreting multiplication', () {
      final multC = AppC((IdC('*')), [NumC(5), NumC(5)]);
      expect(interp(multC, topEnv).serialize(), "25.0");
    });

    test('Interpreting division', () {
      final divC = AppC((IdC('/')), [NumC(5), NumC(5)]);
      expect(interp(divC, topEnv).serialize(), "1.0");
    });

    test('Interpreting less-than/equal', () {
      final eqC = AppC((IdC('<=')), [NumC(5), NumC(5)]);
      expect(interp(eqC, topEnv).serialize(), "true");
      final lessC = AppC((IdC('<=')), [NumC(0), NumC(5)]);
      expect(interp(lessC, topEnv).serialize(), "true");
      final moreC = AppC((IdC('<=')), [NumC(10), NumC(5)]);
      expect(interp(moreC, topEnv).serialize(), "false");
    });

    test('Interpreting substring', () {
      final substringC =
          AppC((IdC('substring')), [StrC("substring test"), NumC(3), NumC(9)]);
      expect(interp(substringC, topEnv).serialize(), "string");
    });

    /*   
  Binding('substring', PrimV('substring')),
  Binding('strlen', PrimV('strlen')),
  Binding('equal?', PrimV('equal?')),
  Binding('true', BoolV(true)),
  Binding('false', BoolV(false)),
  Binding('error', PrimV('error')),
  Binding('println', PrimV('println')),
  Binding('read-num', PrimV('read-num')),
  Binding('read-str', PrimV('read-str')),
  Binding('++', PrimV('++')), */
  });

  test('interp factorial function', () {
    final factorial = LamC(['x', 'rec'], 
    IfC ( (AppC (IdC ('equal?'), [IdC('x'), NumC(0.0)])),
        NumC(1.0),
        AppC( IdC('*'), [IdC('x'), AppC(IdC('rec'), [AppC(IdC('-'), [IdC('x'), NumC(1.0)]), IdC('rec')])])
    ));
    expect(interp(AppC(factorial, [NumC(5.0), factorial]), topEnv).serialize(), "120.0");
  });
}
