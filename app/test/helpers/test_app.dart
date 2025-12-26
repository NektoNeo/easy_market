import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:packager/app.dart';
import 'package:packager/data/history_store.dart';
import 'package:packager/l10n/app_strings.dart';

Widget testApp({
  required Widget child,
  String installationId = '00000000-0000-0000-0000-000000000000',
  HistoryStore? historyStore,
}) {
  return ProviderScope(
    overrides: [
      installationIdProvider.overrideWithValue(installationId),
      if (historyStore != null)
        historyStoreProvider.overrideWithValue(historyStore),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppStrings.supportedLocales,
      locale: const Locale('ru', 'RU'),
      home: child,
    ),
  );
}
