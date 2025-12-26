import '../utils/prompt_options.dart';
import '../models/packaging_request.dart';

class TemplatePreset {
  const TemplatePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.tone,
    required this.defaultFaqCount,
  });

  final String id;
  final String name;
  final String description;
  final Tone tone;
  final int defaultFaqCount;

  OutputOptions applyTo(OutputOptions current) {
    return current.copyWith(faqCount: defaultFaqCount);
  }
}

const seedTemplates = <TemplatePreset>[
  TemplatePreset(
    id: 'cosmetics',
    name: 'Косметика',
    description: 'Уход, кремы, шампуни (без медицинских обещаний).',
    tone: Tone.friendly,
    defaultFaqCount: 8,
  ),
  TemplatePreset(
    id: 'clothes',
    name: 'Одежда',
    description: 'Одежда и обувь (состав, размеры, уход).',
    tone: Tone.neutral,
    defaultFaqCount: 6,
  ),
  TemplatePreset(
    id: 'electronics',
    name: 'Электроника',
    description: 'Гаджеты и аксессуары (совместимость, параметры).',
    tone: Tone.strict,
    defaultFaqCount: 8,
  ),
  TemplatePreset(
    id: 'home',
    name: 'Дом',
    description: 'Дом и кухня (материалы, размеры).',
    tone: Tone.neutral,
    defaultFaqCount: 6,
  ),
];
