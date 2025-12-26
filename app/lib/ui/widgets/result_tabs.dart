import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../models/packaging_response.dart';
import 'glass_card.dart';

class ResultTabs extends StatelessWidget {
  const ResultTabs({super.key, required this.response});
  final PackagingResponse response;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: s.tabTitles),
              Tab(text: s.tabBullets),
              Tab(text: s.tabDescriptions),
              Tab(text: s.tabSeo),
              Tab(text: s.tabFaq),
              Tab(text: s.tabReplies),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _ListSection(items: response.outputs.titles),
                _ListSection(items: response.outputs.bullets),
                _DescriptionsSection(
                  shortText: response.outputs.descriptionShort,
                  longText: response.outputs.descriptionLong,
                ),
                _ListSection(items: response.outputs.seoKeywords),
                _FaqSection(items: response.outputs.faq),
                _RepliesSection(replies: response.outputs.reviewReplies),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final s = AppStrings.of(context);
      return GlassCard(child: Text(s.noData));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => GlassCard(child: Text(items[i])),
    );
  }
}

class _DescriptionsSection extends StatelessWidget {
  const _DescriptionsSection({required this.shortText, required this.longText});

  final String shortText;
  final String longText;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ListView(
      children: [
        GlassCard(child: Text(shortText.isEmpty ? s.noData : shortText)),
        const SizedBox(height: 10),
        GlassCard(child: Text(longText.isEmpty ? s.noData : longText)),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({required this.items});
  final List<FaqItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final s = AppStrings.of(context);
      return GlassCard(child: Text(s.noData));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final it = items[i];
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(it.q, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(it.a),
            ],
          ),
        );
      },
    );
  }
}

class _RepliesSection extends StatelessWidget {
  const _RepliesSection({required this.replies});
  final ReviewReplies replies;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ListView(
      children: [
        _RepliesBlock(
            title: '👍 ${s.positiveRepliesTitle}', items: replies.positive),
        const SizedBox(height: 10),
        _RepliesBlock(
            title: '😐 ${s.neutralRepliesTitle}', items: replies.neutral),
        const SizedBox(height: 10),
        _RepliesBlock(
            title: '👎 ${s.negativeRepliesTitle}', items: replies.negative),
      ],
    );
  }
}

class _RepliesBlock extends StatelessWidget {
  const _RepliesBlock({required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final s = AppStrings.of(context);
      return GlassCard(child: Text('$title ${s.noData}'));
    }
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $e'),
              )),
        ],
      ),
    );
  }
}
