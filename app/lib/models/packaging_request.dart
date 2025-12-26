import '../utils/prompt_options.dart';

enum Marketplace { wb, ozon, avito, other }

extension MarketplaceX on Marketplace {
  String toApi() {
    switch (this) {
      case Marketplace.wb:
        return 'WB';
      case Marketplace.ozon:
        return 'OZON';
      case Marketplace.avito:
        return 'AVITO';
      case Marketplace.other:
        return 'OTHER';
    }
  }

  static Marketplace fromApi(String value) {
    switch (value) {
      case 'WB':
        return Marketplace.wb;
      case 'OZON':
        return Marketplace.ozon;
      case 'AVITO':
        return Marketplace.avito;
      default:
        return Marketplace.other;
    }
  }
}

enum Tone { neutral, friendly, premium, strict }

extension ToneX on Tone {
  String toApi() {
    switch (this) {
      case Tone.neutral:
        return 'neutral';
      case Tone.friendly:
        return 'friendly';
      case Tone.premium:
        return 'premium';
      case Tone.strict:
        return 'strict';
    }
  }

  static Tone fromApi(String value) {
    switch (value) {
      case 'friendly':
        return Tone.friendly;
      case 'premium':
        return Tone.premium;
      case 'strict':
        return Tone.strict;
      default:
        return Tone.neutral;
    }
  }
}

class Characteristic {
  const Characteristic({required this.k, required this.v});
  final String k;
  final String v;

  Map<String, dynamic> toJson() => {'k': k, 'v': v};

  static Characteristic fromJson(Map<String, dynamic> json) =>
      Characteristic(k: json['k'] as String, v: json['v'] as String);
}

class Variant {
  const Variant({required this.name, required this.value});
  final String name;
  final String value;

  Map<String, dynamic> toJson() => {'name': name, 'value': value};

  static Variant fromJson(Map<String, dynamic> json) =>
      Variant(name: json['name'] as String, value: json['value'] as String);
}

class PackagingRequest {
  const PackagingRequest({
    required this.marketplace,
    required this.category,
    required this.productName,
    this.brand,
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

  final Marketplace marketplace;
  final String category;
  final String productName;
  final String? brand;
  final List<Characteristic> characteristics;
  final List<Variant> variants;
  final String audience;
  final Tone tone;
  final List<String> forbiddenWords;
  final List<String> forbiddenClaims;
  final OutputOptions outputOptions;
  final String language;
  final String installationId;

  Map<String, dynamic> toJson() => {
        'marketplace': marketplace.toApi(),
        'category': category,
        'product_name': productName,
        'brand': brand,
        'characteristics': characteristics.map((c) => c.toJson()).toList(),
        'variants': variants.map((v) => v.toJson()).toList(),
        'audience': audience,
        'tone': tone.toApi(),
        'forbidden_words': forbiddenWords,
        'forbidden_claims': forbiddenClaims,
        'output_options': outputOptions.toJson(),
        'language': language,
        'installation_id': installationId,
      };

  static PackagingRequest fromJson(Map<String, dynamic> json) {
    return PackagingRequest(
      marketplace: MarketplaceX.fromApi(json['marketplace'] as String),
      category: json['category'] as String,
      productName: json['product_name'] as String,
      brand: json['brand'] as String?,
      characteristics: (json['characteristics'] as List<dynamic>? ?? [])
          .map((e) => Characteristic.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((e) => Variant.fromJson(e as Map<String, dynamic>))
          .toList(),
      audience: json['audience'] as String,
      tone: ToneX.fromApi(json['tone'] as String),
      forbiddenWords:
          (json['forbidden_words'] as List<dynamic>? ?? []).cast<String>(),
      forbiddenClaims:
          (json['forbidden_claims'] as List<dynamic>? ?? []).cast<String>(),
      outputOptions: OutputOptions.fromJson(
          json['output_options'] as Map<String, dynamic>),
      language: (json['language'] as String?) ?? 'ru',
      installationId: json['installation_id'] as String,
    );
  }

  PackagingRequest copyWith({
    Marketplace? marketplace,
    String? category,
    String? productName,
    String? brand,
    List<Characteristic>? characteristics,
    List<Variant>? variants,
    String? audience,
    Tone? tone,
    List<String>? forbiddenWords,
    List<String>? forbiddenClaims,
    OutputOptions? outputOptions,
    String? language,
    String? installationId,
  }) {
    return PackagingRequest(
      marketplace: marketplace ?? this.marketplace,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      characteristics: characteristics ?? this.characteristics,
      variants: variants ?? this.variants,
      audience: audience ?? this.audience,
      tone: tone ?? this.tone,
      forbiddenWords: forbiddenWords ?? this.forbiddenWords,
      forbiddenClaims: forbiddenClaims ?? this.forbiddenClaims,
      outputOptions: outputOptions ?? this.outputOptions,
      language: language ?? this.language,
      installationId: installationId ?? this.installationId,
    );
  }
}
