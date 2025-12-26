import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getString('installation_id');
  final installationId = existing ?? const Uuid().v4();
  if (existing == null) {
    await prefs.setString('installation_id', installationId);
  }

  runApp(
    ProviderScope(
      overrides: [
        installationIdProvider.overrideWithValue(installationId),
      ],
      child: const PackagerApp(),
    ),
  );
}
