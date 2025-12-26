import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packager/l10n/app_strings.dart';
import 'package:packager/ui/widgets/result_tabs.dart';

import '../helpers/sample_data.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('ResultTabs renders tabs', (tester) async {
    await tester.pumpWidget(
      testApp(
        child: Scaffold(body: ResultTabs(response: SampleData.response())),
      ),
    );
    await tester.pumpAndSettle();

    final s = AppStrings.of(tester.element(find.byType(ResultTabs)));
    expect(find.text(s.tabTitles), findsOneWidget);
    expect(find.text(s.tabBullets), findsOneWidget);
    expect(find.text(s.tabDescriptions), findsOneWidget);
    expect(find.text(s.tabSeo), findsOneWidget);
    expect(find.text(s.tabFaq), findsOneWidget);
    expect(find.text(s.tabReplies), findsOneWidget);
  });
}
