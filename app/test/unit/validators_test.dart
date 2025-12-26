import 'package:flutter_test/flutter_test.dart';
import 'package:packager/utils/validators.dart';

void main() {
  test('requiredText returns error for empty', () {
    expect(Validators.requiredText(''), 'required');
    expect(Validators.requiredText('   '), 'required');
    expect(Validators.requiredText(null), 'required');
  });

  test('requiredText ok', () {
    expect(Validators.requiredText('x'), isNull);
  });

  test('isUuidLike works for relaxed uuid', () {
    expect(
        Validators.isUuidLike('00000000-0000-0000-0000-000000000000'), isTrue);
    expect(Validators.isUuidLike('abc'), isFalse);
  });
}
