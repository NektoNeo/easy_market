import 'package:flutter/widgets.dart';

import 'strings_en.dart';
import 'strings_ru.dart';

abstract class AppStrings {
  const AppStrings();

  static AppStrings of(BuildContext context) {
    final AppStrings? strings =
        Localizations.of<AppStrings>(context, AppStrings);
    return strings ?? const StringsRu();
  }

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static const supportedLocales = <Locale>[
    Locale('ru', 'RU'),
    Locale('en', 'US'),
  ];

  // App
  String get appTitle;

  // Navigation
  String get navWizard;
  String get navHistory;

  // Wizard
  String get wizardTitle;
  String get stepBasics;
  String get stepAudience;
  String get stepOutput;

  String get marketplaceLabel;
  String get marketplaceWb;
  String get marketplaceOzon;
  String get marketplaceAvito;
  String get marketplaceOther;
  String get categoryLabel;
  String get productNameLabel;
  String get brandLabel;

  String get characteristicsLabel;
  String get addCharacteristic;
  String get characteristicKeyLabel;
  String get characteristicValueLabel;
  String get add;
  String get cancel;

  String get audienceLabel;
  String get toneLabel;
  String get toneNeutral;
  String get toneFriendly;
  String get tonePremium;
  String get toneStrict;
  String get forbiddenWordsLabel;
  String get forbiddenWordsHint;
  String get addForbiddenWord;

  String get outputOptionsLabel;
  String get titleVariantsLabel;
  String get bulletsCountLabel;
  String get faqCountLabel;
  String get repliesCountLabel;
  String get needShortDescriptionLabel;
  String get needLongDescriptionLabel;
  String get needSeoLabel;

  String get next;
  String get back;
  String get generate;

  // Results
  String get resultsTitle;
  String get noData;
  String get metaProviderLabel;
  String get saveToHistory;
  String get copied;
  String get copyAll;
  String get copySection;

  String get tabTitles;
  String get tabBullets;
  String get tabDescriptions;
  String get tabSeo;
  String get tabFaq;
  String get tabReplies;

  String get positiveRepliesTitle;
  String get neutralRepliesTitle;
  String get negativeRepliesTitle;

  String get missingInfoTitle;
  String get missingInfoSubtitle;
  String get riskFlagsTitle;
  String get complianceNotesTitle;

  // History
  String get historyTitle;
  String get emptyHistoryTitle;
  String get emptyHistorySubtitle;
  String get searchHint;
  String get delete;

  // Errors
  String get errorRequired;
  String get errorInvalid;
  String get errorNetwork;
  String get errorServer;
  String get errorRateLimited;
  String get retry;
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) async {
    if (locale.languageCode == 'en') return const StringsEn();
    return const StringsRu();
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppStrings> old) => false;
}
