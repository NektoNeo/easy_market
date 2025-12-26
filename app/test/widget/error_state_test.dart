import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packager/l10n/app_strings.dart';
import 'package:packager/ui/widgets/error_state.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('ErrorState renders and calls retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      testApp(
        child: Builder(
          builder: (context) {
            final s = AppStrings.of(context);
            return ErrorState(
              title: s.errorServer,
              message: s.errorNetwork,
              retryLabel: s.retry,
              onRetry: () => retried = true,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final s = AppStrings.of(tester.element(find.byType(ErrorState)));
    final retryLabel = s.retry;

    expect(find.text(retryLabel), findsOneWidget);
    await tester.tap(find.text(retryLabel));
    await tester.pump();
    expect(retried, isTrue);
  });
}
