import 'package:flutter_test/flutter_test.dart';
import 'package:packager/utils/prompt_options.dart';

void main() {
  test('OutputOptions json roundtrip', () {
    const o = OutputOptions(
        titleVariants: 3, bulletsCount: 2, needSeo: false, faqCount: 1);
    final json = o.toJson();
    final o2 = OutputOptions.fromJson(json);
    expect(o2.titleVariants, 3);
    expect(o2.bulletsCount, 2);
    expect(o2.needSeo, false);
    expect(o2.faqCount, 1);
  });
}
