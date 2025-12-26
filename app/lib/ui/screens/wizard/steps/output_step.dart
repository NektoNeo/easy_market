import 'package:flutter/material.dart';

import '../../../../l10n/app_strings.dart';
import '../../../widgets/glass_card.dart';
import '../wizard_screen.dart';

class OutputStep extends StatelessWidget {
  const OutputStep({super.key, required this.state, required this.controller});

  final WizardState state;
  final WizardController controller;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final o = state.outputOptions;

    return ListView(
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.outputOptionsLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _IntRow(
                label: s.titleVariantsLabel,
                value: o.titleVariants,
                min: 1,
                max: 10,
                onChanged: (v) =>
                    controller.setOutputOptions(o.copyWith(titleVariants: v)),
              ),
              const SizedBox(height: 10),
              _IntRow(
                label: s.bulletsCountLabel,
                value: o.bulletsCount,
                min: 0,
                max: 10,
                onChanged: (v) =>
                    controller.setOutputOptions(o.copyWith(bulletsCount: v)),
              ),
              const SizedBox(height: 10),
              _IntRow(
                label: s.faqCountLabel,
                value: o.faqCount,
                min: 0,
                max: 15,
                onChanged: (v) =>
                    controller.setOutputOptions(o.copyWith(faqCount: v)),
              ),
              const SizedBox(height: 10),
              _IntRow(
                label: s.repliesCountLabel,
                value: o.reviewRepliesPerSentiment,
                min: 0,
                max: 6,
                onChanged: (v) => controller
                    .setOutputOptions(o.copyWith(reviewRepliesPerSentiment: v)),
              ),
              const Divider(height: 24),
              SwitchListTile(
                value: o.needShortDescription,
                onChanged: (v) => controller
                    .setOutputOptions(o.copyWith(needShortDescription: v)),
                title: Text(s.needShortDescriptionLabel),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: o.needLongDescription,
                onChanged: (v) => controller
                    .setOutputOptions(o.copyWith(needLongDescription: v)),
                title: Text(s.needLongDescriptionLabel),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: o.needSeo,
                onChanged: (v) =>
                    controller.setOutputOptions(o.copyWith(needSeo: v)),
                title: Text(s.needSeoLabel),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _IntRow extends StatelessWidget {
  const _IntRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: DropdownButtonFormField<int>(
            key: ValueKey(value),
            initialValue: value,
            items: [
              for (int i = min; i <= max; i++)
                DropdownMenuItem(value: i, child: Text('$i'))
            ],
            onChanged: (v) {
              if (v != null) {
                onChanged(v);
              }
            },
          ),
        ),
      ],
    );
  }
}
