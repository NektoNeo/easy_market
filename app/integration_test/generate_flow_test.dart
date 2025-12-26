import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:packager/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Generate flow (smoke)', (tester) async {
    // NOTE: This integration test expects a running backend.
    // Start: uvicorn app.main:app --reload --port 8000
    // Android emulator default URL is handled by API_BASE_URL in app.dart.
    app.main();
    await tester.pumpAndSettle();

    // TODO(P2,qa): Implement real e2e with backend:
    // - fill wizard
    // - tap generate
    // - assert results visible
    expect(true, isTrue);
  });
}
