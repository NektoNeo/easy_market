import 'app_strings.dart';

class StringsRu extends AppStrings {
  const StringsRu();

  @override
  String get appTitle => 'Packager';

  @override
  String get navWizard => 'Создать';
  @override
  String get navHistory => 'История';

  @override
  String get wizardTitle => 'Упаковка за 3 минуты';
  @override
  String get stepBasics => 'Основное';
  @override
  String get stepAudience => 'Аудитория';
  @override
  String get stepOutput => 'Вывод';

  @override
  String get marketplaceLabel => 'Маркетплейс';
  @override
  String get marketplaceWb => 'WB';
  @override
  String get marketplaceOzon => 'Ozon';
  @override
  String get marketplaceAvito => 'Avito';
  @override
  String get marketplaceOther => 'Другое';
  @override
  String get categoryLabel => 'Категория';
  @override
  String get productNameLabel => 'Название товара';
  @override
  String get brandLabel => 'Бренд (опционально)';

  @override
  String get characteristicsLabel => 'Характеристики';
  @override
  String get addCharacteristic => 'Добавить характеристику';
  @override
  String get characteristicKeyLabel => 'Параметр';
  @override
  String get characteristicValueLabel => 'Значение';
  @override
  String get add => 'Добавить';
  @override
  String get cancel => 'Отмена';

  @override
  String get audienceLabel => 'Целевая аудитория';
  @override
  String get toneLabel => 'Тон';
  @override
  String get toneNeutral => 'Нейтрально';
  @override
  String get toneFriendly => 'Дружелюбно';
  @override
  String get tonePremium => 'Премиум';
  @override
  String get toneStrict => 'Строго';
  @override
  String get forbiddenWordsLabel => 'Запрещённые слова';
  @override
  String get forbiddenWordsHint => 'например: лечит, 100%, лучший';
  @override
  String get addForbiddenWord => 'Добавить слово';

  @override
  String get outputOptionsLabel => 'Параметры вывода';
  @override
  String get titleVariantsLabel => 'Варианты заголовка';
  @override
  String get bulletsCountLabel => 'Пункты (буллеты)';
  @override
  String get faqCountLabel => 'FAQ (вопросы)';
  @override
  String get repliesCountLabel => 'Ответы на отзывы (на тональность)';
  @override
  String get needShortDescriptionLabel => 'Короткое описание';
  @override
  String get needLongDescriptionLabel => 'Длинное описание';
  @override
  String get needSeoLabel => 'SEO ключи';

  @override
  String get next => 'Далее';
  @override
  String get back => 'Назад';
  @override
  String get generate => 'Сгенерировать';

  @override
  String get resultsTitle => 'Результат';
  @override
  String get noData => '—';
  @override
  String get metaProviderLabel => 'Провайдер';
  @override
  String get saveToHistory => 'Сохранить в историю';
  @override
  String get copied => 'Скопировано';
  @override
  String get copyAll => 'Копировать всё';
  @override
  String get copySection => 'Копировать раздел';

  @override
  String get tabTitles => 'Заголовки';
  @override
  String get tabBullets => 'Буллеты';
  @override
  String get tabDescriptions => 'Описание';
  @override
  String get tabSeo => 'SEO';
  @override
  String get tabFaq => 'FAQ';
  @override
  String get tabReplies => 'Отзывы';

  @override
  String get positiveRepliesTitle => 'Позитивные';
  @override
  String get neutralRepliesTitle => 'Нейтральные';
  @override
  String get negativeRepliesTitle => 'Негативные';

  @override
  String get missingInfoTitle => 'Нужно уточнить';
  @override
  String get missingInfoSubtitle =>
      'Без этих данных нельзя писать факты — добавьте и перегенерируйте.';
  @override
  String get riskFlagsTitle => 'Риски';
  @override
  String get complianceNotesTitle => 'Подсказки';

  @override
  String get historyTitle => 'История';
  @override
  String get emptyHistoryTitle => 'Пока пусто';
  @override
  String get emptyHistorySubtitle =>
      'Создайте первую генерацию — она появится здесь.';
  @override
  String get searchHint => 'Поиск по названию…';
  @override
  String get delete => 'Удалить';

  @override
  String get errorRequired => 'Заполните обязательные поля';
  @override
  String get errorInvalid => 'Проверьте корректность данных';
  @override
  String get errorNetwork => 'Нет соединения или сервер недоступен';
  @override
  String get errorServer => 'Ошибка сервера';
  @override
  String get errorRateLimited => 'Слишком много запросов — попробуйте позже';
  @override
  String get retry => 'Повторить';
}
