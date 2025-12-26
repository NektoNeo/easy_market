import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_card.dart';

class GlassLoader extends StatelessWidget {
  const GlassLoader({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withAlpha(_alpha(0.12))),
          ),
        ),
        Center(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Flexible(child: Text(label)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

int _alpha(double opacity) => (opacity * 255).round();
