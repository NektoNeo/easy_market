import 'package:flutter/material.dart';

import '../../../../l10n/app_strings.dart';
import '../../../../models/packaging_request.dart';
import '../../../widgets/glass_card.dart';
import '../wizard_screen.dart';

class AudienceStep extends StatefulWidget {
  const AudienceStep(
      {super.key, required this.state, required this.controller});

  final WizardState state;
  final WizardController controller;

  @override
  State<AudienceStep> createState() => _AudienceStepState();
}

class _AudienceStepState extends State<AudienceStep> {
  late final TextEditingController _audienceCtl;

  @override
  void initState() {
    super.initState();
    _audienceCtl = TextEditingController(text: widget.state.audience);
  }

  @override
  void didUpdateWidget(covariant AudienceStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_audienceCtl.text != widget.state.audience) {
      _audienceCtl.text = widget.state.audience;
    }
  }

  @override
  void dispose() {
    _audienceCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final st = widget.state;
    final ctl = widget.controller;

    return ListView(
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _audienceCtl,
                decoration: InputDecoration(labelText: s.audienceLabel),
                maxLines: 2,
                onChanged: ctl.setAudience,
              ),
              const SizedBox(height: 14),
              Text(s.toneLabel, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<Tone>(
                key: ValueKey(st.tone),
                initialValue: st.tone,
                items: [
                  DropdownMenuItem(
                      value: Tone.neutral, child: Text(s.toneNeutral)),
                  DropdownMenuItem(
                      value: Tone.friendly, child: Text(s.toneFriendly)),
                  DropdownMenuItem(
                      value: Tone.premium, child: Text(s.tonePremium)),
                  DropdownMenuItem(
                      value: Tone.strict, child: Text(s.toneStrict)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    ctl.setTone(v);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.forbiddenWordsLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(s.forbiddenWordsHint),
              const SizedBox(height: 10),
              if (st.forbiddenWords.isEmpty) Text(s.noData),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final w in st.forbiddenWords)
                    InputChip(
                      label: Text(w),
                      onDeleted: () => ctl.removeForbiddenWord(w),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _openAddForbiddenDialog(context),
                icon: const Icon(Icons.add),
                label: Text(s.addForbiddenWord),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Future<void> _openAddForbiddenDialog(BuildContext context) async {
    final s = AppStrings.of(context);
    final wordCtl = TextEditingController();

    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(s.addForbiddenWord),
          content: TextField(
            controller: wordCtl,
            decoration: InputDecoration(labelText: s.forbiddenWordsLabel),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(s.cancel)),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(wordCtl.text),
              child: Text(s.add),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget.controller.addForbiddenWord(result);
    }
  }
}
