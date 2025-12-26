import 'package:flutter_test/flutter_test.dart';
import 'package:packager/data/mappers/packaging_mapper.dart';
import 'package:packager/models/packaging_request.dart';
import 'package:packager/models/packaging_response_dto.dart';
import 'package:packager/utils/prompt_options.dart';

void main() {
  test('PackagingMapper.toDto produces correct keys', () {
    const req = PackagingRequest(
      marketplace: Marketplace.ozon,
      category: 'Электроника',
      productName: 'Кабель',
      brand: null,
      characteristics: [],
      variants: [],
      audience: 'Пользователи',
      tone: Tone.strict,
      forbiddenWords: [],
      forbiddenClaims: [],
      outputOptions: OutputOptions(),
      language: 'ru',
      installationId: '00000000-0000-0000-0000-000000000000',
    );

    final dto = PackagingMapper.toDto(req);
    final json = dto.toJson();

    expect(json['marketplace'], 'OZON');
    expect(json['product_name'], 'Кабель');
    expect(json.containsKey('output_options'), isTrue);
  });

  test('PackagingMapper.toDomain maps response', () {
    final dto = PackagingResponseDto.fromJson({
      'meta': {
        'request_id': 'req',
        'provider': 'mock',
        'model': 'm',
        'latency_ms': 1
      },
      'missing_info_questions': [],
      'risk_flags': [],
      'outputs': {
        'titles': [],
        'bullets': [],
        'description_short': '',
        'description_long': '',
        'seo_keywords': [],
        'faq': [],
        'review_replies': {'positive': [], 'neutral': [], 'negative': []}
      },
      'compliance_notes': []
    });

    final domain = PackagingMapper.toDomain(dto);
    expect(domain.meta.provider, 'mock');
  });
}
