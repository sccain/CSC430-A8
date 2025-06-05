import 'package:test/test.dart';
import '../Asgn8.dart';

void main() {
  test('interp and serialize evaluate a NumC', () {
    final numExpr = NumC(42.0);
    expect(interp(numExpr, topEnv).serialize(), "42.0");
  });

  test('interp evaluates a factorial function', () {
    final factorial = LamC(
        ['x', 'rec'],
        IfC(
            (AppC(IdC('equal?'), [IdC('x'), NumC(0.0)])),
            NumC(1.0),
            AppC(IdC('rec'), [
              AppC(IdC('-'), [IdC('x'), NumC(1.0)]),
              IdC('rec')
            ])));
    expect(interp(AppC(factorial, [NumC(5.0), factorial]), topEnv).serialize(),
        "120.0");
  });
}
