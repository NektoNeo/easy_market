import 'packaging_request.dart';

enum RiskSeverity { low, medium, high }

extension RiskSeverityX on RiskSeverity {
  static RiskSeverity fromApi(String value) {
    switch (value) {
      case 'high':
        return RiskSeverity.high;
      case 'medium':
        return RiskSeverity.medium;
      default:
        return RiskSeverity.low;
    }
  }

  String toApi() {
    switch (this) {
      case RiskSeverity.high:
        return 'high';
      case RiskSeverity.medium:
        return 'medium';
      case RiskSeverity.low:
        return 'low';
    }
  }
}

class Meta {
  const Meta({
    required this.requestId,
    required this.provider,
    required this.model,
    required this.latencyMs,
  });

  final String requestId;
  final String provider;
  final String model;
  final int latencyMs;

  Map<String, dynamic> toJson() => {
        'request_id': requestId,
        'provider': provider,
        'model': model,
        'latency_ms': latencyMs,
      };

  static Meta fromJson(Map<String, dynamic> json) => Meta(
        requestId: json['request_id'] as String,
        provider: json['provider'] as String,
        model: json['model'] as String,
        latencyMs: (json['latency_ms'] as num).toInt(),
      );
}

class RiskFlag {
  const RiskFlag(
      {required this.code, required this.severity, required this.snippet});
  final String code;
  final RiskSeverity severity;
  final String snippet;

  Map<String, dynamic> toJson() => {
        'code': code,
        'severity': severity.toApi(),
        'snippet': snippet,
      };

  static RiskFlag fromJson(Map<String, dynamic> json) => RiskFlag(
        code: json['code'] as String,
        severity: RiskSeverityX.fromApi(json['severity'] as String),
        snippet: json['snippet'] as String,
      );
}

class FaqItem {
  const FaqItem({required this.q, required this.a});
  final String q;
  final String a;

  Map<String, dynamic> toJson() => {'q': q, 'a': a};

  static FaqItem fromJson(Map<String, dynamic> json) => FaqItem(
        q: json['q'] as String,
        a: json['a'] as String,
      );
}

class ReviewReplies {
  const ReviewReplies({
    required this.positive,
    required this.neutral,
    required this.negative,
  });

  final List<String> positive;
  final List<String> neutral;
  final List<String> negative;

  Map<String, dynamic> toJson() => {
        'positive': positive,
        'neutral': neutral,
        'negative': negative,
      };

  static ReviewReplies fromJson(Map<String, dynamic> json) => ReviewReplies(
        positive: (json['positive'] as List<dynamic>? ?? []).cast<String>(),
        neutral: (json['neutral'] as List<dynamic>? ?? []).cast<String>(),
        negative: (json['negative'] as List<dynamic>? ?? []).cast<String>(),
      );
}

class Outputs {
  const Outputs({
    required this.titles,
    required this.bullets,
    required this.descriptionShort,
    required this.descriptionLong,
    required this.seoKeywords,
    required this.faq,
    required this.reviewReplies,
  });

  final List<String> titles;
  final List<String> bullets;
  final String descriptionShort;
  final String descriptionLong;
  final List<String> seoKeywords;
  final List<FaqItem> faq;
  final ReviewReplies reviewReplies;

  Map<String, dynamic> toJson() => {
        'titles': titles,
        'bullets': bullets,
        'description_short': descriptionShort,
        'description_long': descriptionLong,
        'seo_keywords': seoKeywords,
        'faq': faq.map((e) => e.toJson()).toList(),
        'review_replies': reviewReplies.toJson(),
      };

  static Outputs fromJson(Map<String, dynamic> json) => Outputs(
        titles: (json['titles'] as List<dynamic>? ?? []).cast<String>(),
        bullets: (json['bullets'] as List<dynamic>? ?? []).cast<String>(),
        descriptionShort: (json['description_short'] as String?) ?? '',
        descriptionLong: (json['description_long'] as String?) ?? '',
        seoKeywords:
            (json['seo_keywords'] as List<dynamic>? ?? []).cast<String>(),
        faq: (json['faq'] as List<dynamic>? ?? [])
            .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        reviewReplies: ReviewReplies.fromJson(
            json['review_replies'] as Map<String, dynamic>),
      );
}

class PackagingResponse {
  const PackagingResponse({
    required this.meta,
    required this.missingInfoQuestions,
    required this.riskFlags,
    required this.outputs,
    required this.complianceNotes,
  });

  final Meta meta;
  final List<String> missingInfoQuestions;
  final List<RiskFlag> riskFlags;
  final Outputs outputs;
  final List<String> complianceNotes;

  Map<String, dynamic> toJson() => {
        'meta': meta.toJson(),
        'missing_info_questions': missingInfoQuestions,
        'risk_flags': riskFlags.map((e) => e.toJson()).toList(),
        'outputs': outputs.toJson(),
        'compliance_notes': complianceNotes,
      };

  static PackagingResponse fromJson(Map<String, dynamic> json) =>
      PackagingResponse(
        meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
        missingInfoQuestions:
            (json['missing_info_questions'] as List<dynamic>? ?? [])
                .cast<String>(),
        riskFlags: (json['risk_flags'] as List<dynamic>? ?? [])
            .map((e) => RiskFlag.fromJson(e as Map<String, dynamic>))
            .toList(),
        outputs: Outputs.fromJson(json['outputs'] as Map<String, dynamic>),
        complianceNotes:
            (json['compliance_notes'] as List<dynamic>? ?? []).cast<String>(),
      );
}

/// A convenience struct for "result context" screens.
class ResultContext {
  const ResultContext({
    required this.request,
    required this.response,
  });

  final PackagingRequest request;
  final PackagingResponse response;
}
