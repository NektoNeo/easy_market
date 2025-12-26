import 'package:flutter_test/flutter_test.dart';
import 'package:packager/data/history_store.dart';
import 'package:packager/l10n/app_strings.dart';
import 'package:packager/ui/screens/history/history_screen.dart';

import '../helpers/sample_data.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('HistoryScreen shows empty state', (tester) async {
    final store = InMemoryHistoryStore();

    await tester
        .pumpWidget(testApp(child: const HistoryScreen(), historyStore: store));
    await tester.pumpAndSettle();

    final s = AppStrings.of(tester.element(find.byType(HistoryScreen)));
    expect(find.text(s.emptyHistoryTitle), findsOneWidget);
  });

  testWidgets('HistoryScreen shows saved entry', (tester) async {
    final store = InMemoryHistoryStore();
    await store.save(
        request: SampleData.request(), response: SampleData.response());

    await tester
        .pumpWidget(testApp(child: const HistoryScreen(), historyStore: store));
    await tester.pumpAndSettle();

    expect(find.text('Крем для рук'), findsOneWidget);
  });
}
