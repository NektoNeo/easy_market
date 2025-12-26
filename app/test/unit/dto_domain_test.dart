import 'package:flutter_test/flutter_test.dart';
import 'package:packager/models/packaging_request.dart';
import 'package:packager/models/packaging_request_dto.dart';
import 'package:packager/utils/prompt_options.dart';

void main() {
  test('PackagingRequestDto fromDomain/toDomain roundtrip', () {
    const req = PackagingRequest(
      marketplace: Marketplace.wb,
      category: 'Категория',
      productName: 'Товар',
      brand: 'Бренд',
      characteristics: [Characteristic(k: 'Объём', v: '50 мл')],
      variants: [],
      audience: 'Аудитория',
      tone: Tone.neutral,
      forbiddenWords: ['лечит'],
      forbiddenClaims: [],
      outputOptions: OutputOptions(faqCount: 2),
      language: 'ru',
      installationId: '00000000-0000-0000-0000-000000000000',
    );

    final dto = PackagingRequestDto.fromDomain(req);
    final back = dto.toDomain();

    expect(back.marketplace, Marketplace.wb);
    expect(back.category, 'Категория');
    expect(back.productName, 'Товар');
    expect(back.brand, 'Бренд');
    expect(back.characteristics.first.k, 'Объём');
  });
}
