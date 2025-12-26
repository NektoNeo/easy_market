import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/api_client.dart';
import 'data/history_store.dart';
import 'l10n/app_strings.dart';
import 'models/packaging_response.dart';
import 'ui/screens/history/history_screen.dart';
import 'ui/screens/results/results_screen.dart';
import 'ui/screens/wizard/wizard_screen.dart';
import 'ui/theme/app_theme.dart';

/// Installation id is generated in main.dart and injected here via override.
final installationIdProvider =
    Provider<String>((ref) => throw UnimplementedError());

/// API base URL can be overridden with:
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
final apiBaseUrlProvider = Provider<String>((ref) {
  const defined = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  if (defined.isNotEmpty) return defined;

  // Reasonable defaults for local dev.
  if (Platform.isAndroid) return 'http://10.0.2.2:8000';
  return 'http://localhost:8000';
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final installationId = ref.watch(installationIdProvider);
  return ApiClient(baseUrl: baseUrl, installationId: installationId);
});

final historyStoreProvider = Provider<HistoryStore>((ref) {
  return SharedPrefsHistoryStore();
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/wizard',
    routes: [
      GoRoute(
        path: '/wizard',
        builder: (context, state) => const WizardScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is HistoryEntry) {
            return ResultsScreen(entry: extra);
          }
          if (extra is PackagingResponse) {
            return ResultsScreen(entry: HistoryEntry.temporary(extra));
          }
          return ResultsScreen(entry: HistoryEntry.empty());
        },
      ),
    ],
  );
});

class PackagerApp extends ConsumerWidget {
  const PackagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppStrings.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppStrings.supportedLocales,
      routerConfig: router,
    );
  }
}
