import 'package:flutter/material.dart';

import '../../../../l10n/app_strings.dart';
import '../../../../models/packaging_request.dart';
import '../../../widgets/glass_card.dart';
import '../wizard_screen.dart';

class BasicsStep extends StatefulWidget {
  const BasicsStep({super.key, required this.state, required this.controller});

  final WizardState state;
  final WizardController controller;

  @override
  State<BasicsStep> createState() => _BasicsStepState();
}

class _BasicsStepState extends State<BasicsStep> {
  late final TextEditingController _categoryCtl;
  late final TextEditingController _nameCtl;
  late final TextEditingController _brandCtl;

  @override
  void initState() {
    super.initState();
    _categoryCtl = TextEditingController(text: widget.state.category);
    _nameCtl = TextEditingController(text: widget.state.productName);
    _brandCtl = TextEditingController(text: widget.state.brand);
  }

  @override
  void didUpdateWidget(covariant BasicsStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_categoryCtl.text != widget.state.category) {
      _categoryCtl.text = widget.state.category;
    }
    if (_nameCtl.text != widget.state.productName) {
      _nameCtl.text = widget.state.productName;
    }
    if (_brandCtl.text != widget.state.brand) {
      _brandCtl.text = widget.state.brand;
    }
  }

  @override
  void dispose() {
    _categoryCtl.dispose();
    _nameCtl.dispose();
    _brandCtl.dispose();
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
              Text(s.marketplaceLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<Marketplace>(
                key: ValueKey(st.marketplace),
                initialValue: st.marketplace,
                items: [
                  DropdownMenuItem(
                      value: Marketplace.wb, child: Text(s.marketplaceWb)),
                  DropdownMenuItem(
                      value: Marketplace.ozon, child: Text(s.marketplaceOzon)),
                  DropdownMenuItem(
                      value: Marketplace.avito,
                      child: Text(s.marketplaceAvito)),
                  DropdownMenuItem(
                      value: Marketplace.other,
                      child: Text(s.marketplaceOther)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    ctl.setMarketplace(v);
                  }
                },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _categoryCtl,
                decoration: InputDecoration(labelText: s.categoryLabel),
                onChanged: ctl.setCategory,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(labelText: s.productNameLabel),
                onChanged: ctl.setProductName,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _brandCtl,
                decoration: InputDecoration(labelText: s.brandLabel),
                onChanged: ctl.setBrand,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.characteristicsLabel,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (st.characteristics.isEmpty) Text(s.noData),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 0; i < st.characteristics.length; i++)
                    InputChip(
                      label: Text(
                          '${st.characteristics[i].k}: ${st.characteristics[i].v}'),
                      onDeleted: () => ctl.removeCharacteristicAt(i),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _openAddDialog(context),
                icon: const Icon(Icons.add),
                label: Text(s.addCharacteristic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Future<void> _openAddDialog(BuildContext context) async {
    final s = AppStrings.of(context);
    final keyCtl = TextEditingController();
    final valueCtl = TextEditingController();

    final result = await showDialog<Characteristic?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(s.addCharacteristic),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: keyCtl,
                  decoration:
                      InputDecoration(labelText: s.characteristicKeyLabel)),
              const SizedBox(height: 10),
              TextField(
                  controller: valueCtl,
                  decoration:
                      InputDecoration(labelText: s.characteristicValueLabel)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(s.cancel)),
            FilledButton(
              onPressed: () {
                final k = keyCtl.text.trim();
                final v = valueCtl.text.trim();
                if (k.isEmpty || v.isEmpty) {
                  Navigator.of(context).pop(null);
                  return;
                }
                Navigator.of(context).pop(Characteristic(k: k, v: v));
              },
              child: Text(s.add),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget.controller.addCharacteristic(result);
    }
  }
}
