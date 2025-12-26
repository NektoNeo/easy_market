import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/packaging_request.dart';
import '../../../utils/prompt_options.dart';
import '../../../utils/validators.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/glass_loader.dart';
import '../../widgets/primary_button.dart';
import 'steps/audience_step.dart';
import 'steps/basics_step.dart';
import 'steps/output_step.dart';

final wizardControllerProvider =
    StateNotifierProvider<WizardController, WizardState>(
        (ref) => WizardController());

class WizardState {
  const WizardState({
    required this.step,
    required this.marketplace,
    required this.category,
    required this.productName,
    required this.brand,
    required this.characteristics,
    required this.variants,
    required this.audience,
    required this.tone,
    required this.forbiddenWords,
    required this.outputOptions,
    required this.isSubmitting,
    required this.errorCode,
  });

  final int step;
  final Marketplace marketplace;
  final String category;
  final String productName;
  final String brand;
  final List<Characteristic> characteristics;
  final List<Variant> variants;
  final String audience;
  final Tone tone;
  final List<String> forbiddenWords;
  final OutputOptions outputOptions;

  final bool isSubmitting;
  final String? errorCode;

  bool get basicsValid =>
      category.trim().isNotEmpty && productName.trim().isNotEmpty;

  bool get audienceValid => audience.trim().isNotEmpty;

  bool get canGenerate => basicsValid && audienceValid && !isSubmitting;

  WizardState copyWith({
    int? step,
    Marketplace? marketplace,
    String? category,
    String? productName,
    String? brand,
    List<Characteristic>? characteristics,
    List<Variant>? variants,
    String? audience,
    Tone? tone,
    List<String>? forbiddenWords,
    OutputOptions? outputOptions,
    bool? isSubmitting,
    String? errorCode,
  }) {
    return WizardState(
      step: step ?? this.step,
      marketplace: marketplace ?? this.marketplace,
      category: category ?? this.category,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      characteristics: characteristics ?? this.characteristics,
      variants: variants ?? this.variants,
      audience: audience ?? this.audience,
      tone: tone ?? this.tone,
      forbiddenWords: forbiddenWords ?? this.forbiddenWords,
      outputOptions: outputOptions ?? this.outputOptions,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorCode: errorCode,
    );
  }

  static WizardState initial() => const WizardState(
        step: 0,
        marketplace: Marketplace.wb,
        category: '',
        productName: '',
        brand: '',
        characteristics: [],
        variants: [],
        audience: '',
        tone: Tone.neutral,
        forbiddenWords: [],
        outputOptions: OutputOptions(),
        isSubmitting: false,
        errorCode: null,
      );
}

class WizardController extends StateNotifier<WizardState> {
  WizardController() : super(WizardState.initial());

  void setStep(int step) => state = state.copyWith(step: step);

  void setMarketplace(Marketplace v) => state = state.copyWith(marketplace: v);

  void setCategory(String v) => state = state.copyWith(category: v);

  void setProductName(String v) => state = state.copyWith(productName: v);

  void setBrand(String v) => state = state.copyWith(brand: v);

  void addCharacteristic(Characteristic c) {
    final next = [...state.characteristics, c];
    state = state.copyWith(characteristics: next);
  }

  void removeCharacteristicAt(int index) {
    final next = [...state.characteristics]..removeAt(index);
    state = state.copyWith(characteristics: next);
  }

  void setAudience(String v) => state = state.copyWith(audience: v);

  void setTone(Tone v) => state = state.copyWith(tone: v);

  void addForbiddenWord(String w) {
    final word = w.trim();
    if (word.isEmpty) return;
    final next = {...state.forbiddenWords, word}.toList();
    state = state.copyWith(forbiddenWords: next);
  }

  void removeForbiddenWord(String w) {
    final next = [...state.forbiddenWords]..remove(w);
    state = state.copyWith(forbiddenWords: next);
  }

  void setOutputOptions(OutputOptions o) =>
      state = state.copyWith(outputOptions: o);

  void setSubmitting(bool v) => state = state.copyWith(isSubmitting: v);

  void setError(String? code) => state = state.copyWith(errorCode: code);
}

class WizardScreen extends ConsumerWidget {
  const WizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final st = ref.watch(wizardControllerProvider);
    final ctl = ref.read(wizardControllerProvider.notifier);

    final steps = <Widget>[
      BasicsStep(state: st, controller: ctl),
      AudienceStep(state: st, controller: ctl),
      OutputStep(state: st, controller: ctl),
    ];

    Future<void> onGenerate() async {
      if (!st.canGenerate) return;
      ctl.setError(null);

      final installationId = ref.read(installationIdProvider);
      if (!Validators.isUuidLike(installationId)) {
        ctl.setError('INVALID_INSTALLATION');
        return;
      }

      final req = PackagingRequest(
        marketplace: st.marketplace,
        category: st.category.trim(),
        productName: st.productName.trim(),
        brand: st.brand.trim().isEmpty ? null : st.brand.trim(),
        characteristics: st.characteristics,
        variants: st.variants,
        audience: st.audience.trim(),
        tone: st.tone,
        forbiddenWords: st.forbiddenWords,
        forbiddenClaims: const [],
        outputOptions: st.outputOptions,
        language: 'ru',
        installationId: installationId,
      );

      ctl.setSubmitting(true);
      try {
        final api = ref.read(apiClientProvider);
        final res = await api.generatePackaging(req);

        final store = ref.read(historyStoreProvider);
        final entry = await store.save(request: req, response: res);

        if (context.mounted) {
          // Reset is optional; keep form for iterative runs.
          ctl.setSubmitting(false);
          context.push('/results', extra: entry);
        }
      } catch (e) {
        ctl.setSubmitting(false);
        // Very lightweight error mapping.
        final msg = e.toString();
        if (msg.contains('RATE_LIMIT')) {
          ctl.setError('RATE_LIMIT');
        } else if (msg.contains('NETWORK')) {
          ctl.setError('NETWORK');
        } else if (msg.contains('SERVER')) {
          ctl.setError('SERVER');
        } else {
          ctl.setError('UNKNOWN');
        }
      }
    }

    String? errorText() {
      final code = st.errorCode;
      if (code == null) return null;
      switch (code) {
        case 'RATE_LIMIT':
          return s.errorRateLimited;
        case 'NETWORK':
          return s.errorNetwork;
        case 'SERVER':
          return s.errorServer;
        case 'INVALID_INSTALLATION':
        case 'INVALID':
          return s.errorInvalid;
        default:
          return s.errorServer;
      }
    }

    return Stack(
      children: [
        AppScaffold(
          title: s.wizardTitle,
          actions: [
            IconButton(
              tooltip: s.historyTitle,
              onPressed: () => context.push('/history'),
              icon: const Icon(Icons.history),
            ),
          ],
          child: Column(
            children: [
              _WizardStepper(
                current: st.step,
                onStepTapped: (i) => ctl.setStep(i),
                labels: [s.stepBasics, s.stepAudience, s.stepOutput],
              ),
              const SizedBox(height: 12),
              Expanded(child: steps[st.step]),
              if (errorText() != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorText()!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              if (st.step < steps.length - 1) ...[
                PrimaryButton(
                  label: s.next,
                  onPressed: () {
                    if (st.step == 0 && !st.basicsValid) {
                      ctl.setError('INVALID');
                      return;
                    }
                    if (st.step == 1 && !st.audienceValid) {
                      ctl.setError('INVALID');
                      return;
                    }
                    ctl.setError(null);
                    ctl.setStep(st.step + 1);
                  },
                ),
                const SizedBox(height: 12),
              ] else ...[
                PrimaryButton(
                  label: s.generate,
                  isLoading: st.isSubmitting,
                  onPressed: st.canGenerate ? onGenerate : null,
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        if (st.isSubmitting) GlassLoader(label: s.generate),
      ],
    );
  }
}

class _WizardStepper extends StatelessWidget {
  const _WizardStepper({
    required this.current,
    required this.onStepTapped,
    required this.labels,
  });

  final int current;
  final ValueChanged<int> onStepTapped;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final active = i == current;
        return Expanded(
          child: InkWell(
            onTap: () => onStepTapped(i),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: active
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(_alpha(0.15)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

int _alpha(double opacity) => (opacity * 255).round();
