import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app.dart';
import '../../../data/history_store.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/packaging_request.dart';
import '../../../models/packaging_response.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/glass_card.dart';
import '../../../ui/widgets/result_tabs.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key, required this.entry});
  final HistoryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final resp = entry.response;
    final req = entry.request;

    Future<void> copyAll() async {
      final buffer = StringBuffer();
      void add(String title, String body) {
        if (body.trim().isEmpty) return;
        buffer.writeln(title);
        buffer.writeln(body);
        buffer.writeln();
      }

      add(s.tabTitles, resp.outputs.titles.join('\n'));
      add(s.tabBullets, resp.outputs.bullets.join('\n'));
      add(s.tabDescriptions, resp.outputs.descriptionShort);
      add(s.tabDescriptions, resp.outputs.descriptionLong);
      add(s.tabSeo, resp.outputs.seoKeywords.join(', '));
      add(s.tabFaq,
          resp.outputs.faq.map((e) => 'Q: ${e.q}\nA: ${e.a}').join('\n\n'));
      add(
          s.tabReplies,
          [
            ...resp.outputs.reviewReplies.positive,
            ...resp.outputs.reviewReplies.neutral,
            ...resp.outputs.reviewReplies.negative,
          ].join('\n'));

      await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(s.copied)));
      }
    }

    Future<void> saveIfTemporary() async {
      if (entry.id != 'temp') return;
      final store = ref.read(historyStoreProvider);
      // Note: temporary entry may have dummy request; in real usage pass a real request.
      await store.save(request: req, response: resp);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(s.saveToHistory)));
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // push to results of saved
        // ignore: use_build_context_synchronously
        // (router is GoRouter; simple pop is enough for skeleton)
      }
    }

    return AppScaffold(
      title: s.resultsTitle,
      actions: [
        IconButton(
          tooltip: s.copyAll,
          onPressed: copyAll,
          icon: const Icon(Icons.copy_all),
        ),
        if (entry.id == 'temp')
          IconButton(
            tooltip: s.saveToHistory,
            onPressed: saveIfTemporary,
            icon: const Icon(Icons.bookmark_add),
          ),
      ],
      child: Column(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.productName.isEmpty ? s.resultsTitle : req.productName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text('${req.marketplace.toApi()} • ${req.category}'),
                const SizedBox(height: 6),
                Text(
                    '${s.metaProviderLabel}: ${resp.meta.provider} • ${resp.meta.latencyMs}ms'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (resp.missingInfoQuestions.isNotEmpty) ...[
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.missingInfoTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(s.missingInfoSubtitle),
                  const SizedBox(height: 10),
                  ...resp.missingInfoQuestions.map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $q'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (resp.riskFlags.isNotEmpty) ...[
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.riskFlagsTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...resp.riskFlags.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                            '• ${f.code} (${f.severity.toApi()}): ${f.snippet}'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (resp.complianceNotes.isNotEmpty) ...[
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.complianceNotesTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...resp.complianceNotes.map((n) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $n'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Expanded(child: ResultTabs(response: resp)),
        ],
      ),
    );
  }
}
