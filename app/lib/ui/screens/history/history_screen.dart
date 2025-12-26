import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../data/history_store.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/packaging_request.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/glass_card.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchCtl = TextEditingController();

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final store = ref.read(historyStoreProvider);

    return AppScaffold(
      title: s.historyTitle,
      actions: [
        IconButton(
          tooltip: s.navWizard,
          onPressed: () => context.go('/wizard'),
          icon: const Icon(Icons.add),
        ),
      ],
      child: Column(
        children: [
          GlassCard(
            child: TextField(
              controller: _searchCtl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: s.searchHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<HistoryEntry>>(
              future: store.list(query: _searchCtl.text),
              builder: (context, snap) {
                final items = snap.data ?? const <HistoryEntry>[];
                if (items.isEmpty) {
                  return GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s.emptyHistoryTitle,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(s.emptyHistorySubtitle,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final e = items[i];
                    return _HistoryTile(
                      entry: e,
                      onOpen: () => context.push('/results', extra: e),
                      onDelete: () async {
                        await store.delete(e.id);
                        if (mounted) setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.onOpen,
    required this.onDelete,
  });

  final HistoryEntry entry;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final req = entry.request;
    return GestureDetector(
      onTap: onOpen,
      child: GlassCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req.productName,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${req.marketplace.toApi()} • ${req.category}'),
                  const SizedBox(height: 4),
                  Text(entry.createdAt.toLocal().toString()),
                ],
              ),
            ),
            IconButton(
              tooltip: s.delete,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
