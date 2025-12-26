import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packager/data/history_store.dart';
import 'package:packager/l10n/app_strings.dart';
import 'package:packager/ui/screens/wizard/wizard_screen.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('Wizard flow navigation works', (tester) async {
    final store = InMemoryHistoryStore();

    await tester
        .pumpWidget(testApp(child: const WizardScreen(), historyStore: store));
    await tester.pumpAndSettle();

    final s = AppStrings.of(tester.element(find.byType(WizardScreen)));

    // Basics step: fill category + name
    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(3)); // category, product, brand
    await tester.enterText(fields.at(0), 'Категория');
    await tester.enterText(fields.at(1), 'Товар');
    await tester.pumpAndSettle();

    await tester.tap(find.text(s.next));
    await tester.pumpAndSettle();

    // Audience step: fill audience
    final audienceField = find.byType(TextField).first;
    await tester.enterText(audienceField, 'Покупатели');
    await tester.pumpAndSettle();
    await tester.tap(find.text(s.next));
    await tester.pumpAndSettle();

    // Output step: generate button should be visible
    expect(find.text(s.generate), findsOneWidget);
  });
}
