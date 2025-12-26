import 'app_strings.dart';

class StringsEn extends AppStrings {
  const StringsEn();

  @override
  String get appTitle => 'Packager';

  @override
  String get navWizard => 'Create';
  @override
  String get navHistory => 'History';

  @override
  String get wizardTitle => 'Packaging in 3 minutes';
  @override
  String get stepBasics => 'Basics';
  @override
  String get stepAudience => 'Audience';
  @override
  String get stepOutput => 'Output';

  @override
  String get marketplaceLabel => 'Marketplace';
  @override
  String get marketplaceWb => 'WB';
  @override
  String get marketplaceOzon => 'Ozon';
  @override
  String get marketplaceAvito => 'Avito';
  @override
  String get marketplaceOther => 'Other';
  @override
  String get categoryLabel => 'Category';
  @override
  String get productNameLabel => 'Product name';
  @override
  String get brandLabel => 'Brand (optional)';

  @override
  String get characteristicsLabel => 'Characteristics';
  @override
  String get addCharacteristic => 'Add characteristic';
  @override
  String get characteristicKeyLabel => 'Key';
  @override
  String get characteristicValueLabel => 'Value';
  @override
  String get add => 'Add';
  @override
  String get cancel => 'Cancel';

  @override
  String get audienceLabel => 'Audience';
  @override
  String get toneLabel => 'Tone';
  @override
  String get toneNeutral => 'Neutral';
  @override
  String get toneFriendly => 'Friendly';
  @override
  String get tonePremium => 'Premium';
  @override
  String get toneStrict => 'Strict';
  @override
  String get forbiddenWordsLabel => 'Forbidden words';
  @override
  String get forbiddenWordsHint => 'e.g. cures, 100%, best';
  @override
  String get addForbiddenWord => 'Add word';

  @override
  String get outputOptionsLabel => 'Output options';
  @override
  String get titleVariantsLabel => 'Title variants';
  @override
  String get bulletsCountLabel => 'Bullets';
  @override
  String get faqCountLabel => 'FAQ count';
  @override
  String get repliesCountLabel => 'Review replies per sentiment';
  @override
  String get needShortDescriptionLabel => 'Short description';
  @override
  String get needLongDescriptionLabel => 'Long description';
  @override
  String get needSeoLabel => 'SEO keywords';

  @override
  String get next => 'Next';
  @override
  String get back => 'Back';
  @override
  String get generate => 'Generate';

  @override
  String get resultsTitle => 'Results';
  @override
  String get noData => '—';
  @override
  String get metaProviderLabel => 'Provider';
  @override
  String get saveToHistory => 'Save to history';
  @override
  String get copied => 'Copied';
  @override
  String get copyAll => 'Copy all';
  @override
  String get copySection => 'Copy section';

  @override
  String get tabTitles => 'Titles';
  @override
  String get tabBullets => 'Bullets';
  @override
  String get tabDescriptions => 'Description';
  @override
  String get tabSeo => 'SEO';
  @override
  String get tabFaq => 'FAQ';
  @override
  String get tabReplies => 'Reviews';

  @override
  String get positiveRepliesTitle => 'Positive';
  @override
  String get neutralRepliesTitle => 'Neutral';
  @override
  String get negativeRepliesTitle => 'Negative';

  @override
  String get missingInfoTitle => 'Need details';
  @override
  String get missingInfoSubtitle => 'Add missing info and re-generate.';
  @override
  String get riskFlagsTitle => 'Risks';
  @override
  String get complianceNotesTitle => 'Notes';

  @override
  String get historyTitle => 'History';
  @override
  String get emptyHistoryTitle => 'No items yet';
  @override
  String get emptyHistorySubtitle =>
      'Create your first generation to see it here.';
  @override
  String get searchHint => 'Search…';
  @override
  String get delete => 'Delete';

  @override
  String get errorRequired => 'Please fill required fields';
  @override
  String get errorInvalid => 'Please check your input';
  @override
  String get errorNetwork => 'No connection or server unreachable';
  @override
  String get errorServer => 'Server error';
  @override
  String get errorRateLimited => 'Too many requests — try later';
  @override
  String get retry => 'Retry';
}
