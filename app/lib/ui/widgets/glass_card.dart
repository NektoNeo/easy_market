import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.blur = 16,
    this.opacity = 0.12,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: scheme.surface.withAlpha(_alpha(opacity)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: scheme.onSurface.withAlpha(_alpha(0.12)),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

int _alpha(double opacity) => (opacity * 255).round();
