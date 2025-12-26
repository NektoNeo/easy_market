class OutputOptions {
  const OutputOptions({
    this.titleVariants = 5,
    this.bulletsCount = 6,
    this.needShortDescription = true,
    this.needLongDescription = true,
    this.needSeo = true,
    this.faqCount = 10,
    this.reviewRepliesPerSentiment = 3,
  });

  final int titleVariants;
  final int bulletsCount;
  final bool needShortDescription;
  final bool needLongDescription;
  final bool needSeo;
  final int faqCount;
  final int reviewRepliesPerSentiment;

  OutputOptions copyWith({
    int? titleVariants,
    int? bulletsCount,
    bool? needShortDescription,
    bool? needLongDescription,
    bool? needSeo,
    int? faqCount,
    int? reviewRepliesPerSentiment,
  }) {
    return OutputOptions(
      titleVariants: titleVariants ?? this.titleVariants,
      bulletsCount: bulletsCount ?? this.bulletsCount,
      needShortDescription: needShortDescription ?? this.needShortDescription,
      needLongDescription: needLongDescription ?? this.needLongDescription,
      needSeo: needSeo ?? this.needSeo,
      faqCount: faqCount ?? this.faqCount,
      reviewRepliesPerSentiment:
          reviewRepliesPerSentiment ?? this.reviewRepliesPerSentiment,
    );
  }

  Map<String, dynamic> toJson() => {
        'title_variants': titleVariants,
        'bullets_count': bulletsCount,
        'need_short_description': needShortDescription,
        'need_long_description': needLongDescription,
        'need_seo': needSeo,
        'faq_count': faqCount,
        'review_replies_per_sentiment': reviewRepliesPerSentiment,
      };

  static OutputOptions fromJson(Map<String, dynamic> json) {
    return OutputOptions(
      titleVariants: (json['title_variants'] ?? 5) as int,
      bulletsCount: (json['bullets_count'] ?? 6) as int,
      needShortDescription: (json['need_short_description'] ?? true) as bool,
      needLongDescription: (json['need_long_description'] ?? true) as bool,
      needSeo: (json['need_seo'] ?? true) as bool,
      faqCount: (json['faq_count'] ?? 10) as int,
      reviewRepliesPerSentiment:
          (json['review_replies_per_sentiment'] ?? 3) as int,
    );
  }
}
