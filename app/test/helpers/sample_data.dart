import 'package:packager/models/packaging_request.dart';
import 'package:packager/models/packaging_response.dart';
import 'package:packager/utils/prompt_options.dart';

class SampleData {
  static PackagingRequest request(
      {String installationId = '00000000-0000-0000-0000-000000000000'}) {
    return PackagingRequest(
      marketplace: Marketplace.wb,
      category: 'Уход',
      productName: 'Крем для рук',
      brand: 'MyBrand',
      characteristics: const [Characteristic(k: 'Объём', v: '50 мл')],
      variants: const [],
      audience: 'Люди с сухой кожей',
      tone: Tone.friendly,
      forbiddenWords: const ['лечит'],
      forbiddenClaims: const [],
      outputOptions:
          const OutputOptions(faqCount: 3, reviewRepliesPerSentiment: 1),
      language: 'ru',
      installationId: installationId,
    );
  }

  static PackagingResponse response() {
    return const PackagingResponse(
      meta: Meta(
          requestId: 'req_test',
          provider: 'mock',
          model: 'mock-1',
          latencyMs: 42),
      missingInfoQuestions: [],
      riskFlags: [],
      outputs: Outputs(
        titles: ['Крем для рук, 50 мл'],
        bullets: ['Объём: 50 мл'],
        descriptionShort: 'Крем для рук.',
        descriptionLong: 'Крем для рук. Проверьте факты.',
        seoKeywords: ['крем', 'рук'],
        faq: [FaqItem(q: 'Какой объём?', a: '50 мл')],
        reviewReplies: ReviewReplies(
            positive: ['Спасибо!'],
            neutral: ['Спасибо!'],
            negative: ['Сожалеем!']),
      ),
      complianceNotes: ['Проверьте факты'],
    );
  }
}
