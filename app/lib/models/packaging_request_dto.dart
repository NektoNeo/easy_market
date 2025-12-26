import 'packaging_request.dart';
import '../utils/prompt_options.dart';

class PackagingRequestDto {
  const PackagingRequestDto({
    required this.marketplace,
    required this.category,
    required this.productName,
    required this.brand,
    required this.characteristics,
    required this.variants,
    required this.audience,
    required this.tone,
    required this.forbiddenWords,
    required this.forbiddenClaims,
    required this.outputOptions,
    required this.language,
    required this.installationId,
  });

  final String marketplace;
  final String category;
  final String productName;
  final String? brand;
  final List<Map<String, dynamic>> characteristics;
  final List<Map<String, dynamic>> variants;
  final String audience;
  final String tone;
  final List<String> forbiddenWords;
  final List<String> forbiddenClaims;
  final Map<String, dynamic> outputOptions;
  final String language;
  final String installationId;

  Map<String, dynamic> toJson() => {
        'marketplace': marketplace,
        'category': category,
        'product_name': productName,
        'brand': brand,
        'characteristics': characteristics,
        'variants': variants,
        'audience': audience,
        'tone': tone,
        'forbidden_words': forbiddenWords,
        'forbidden_claims': forbiddenClaims,
        'output_options': outputOptions,
        'language': language,
        'installation_id': installationId,
      };

  static PackagingRequestDto fromDomain(PackagingRequest d) {
    return PackagingRequestDto(
      marketplace: d.marketplace.toApi(),
      category: d.category,
      productName: d.productName,
      brand: d.brand,
      characteristics: d.characteristics.map((c) => c.toJson()).toList(),
      variants: d.variants.map((v) => v.toJson()).toList(),
      audience: d.audience,
      tone: d.tone.toApi(),
      forbiddenWords: d.forbiddenWords,
      forbiddenClaims: d.forbiddenClaims,
      outputOptions: d.outputOptions.toJson(),
      language: d.language,
      installationId: d.installationId,
    );
  }

  PackagingRequest toDomain() {
    return PackagingRequest(
      marketplace: MarketplaceX.fromApi(marketplace),
      category: category,
      productName: productName,
      brand: brand,
      characteristics: characteristics
          .map((e) => Characteristic.fromJson(e))
          .toList(growable: false),
      variants:
          variants.map((e) => Variant.fromJson(e)).toList(growable: false),
      audience: audience,
      tone: ToneX.fromApi(tone),
      forbiddenWords: forbiddenWords,
      forbiddenClaims: forbiddenClaims,
      outputOptions: OutputOptions.fromJson(outputOptions),
      language: language,
      installationId: installationId,
    );
  }
}
