import 'package:flutter/widgets.dart';

const _gradientStops = [0.0, 0.3, 0.58];

class RarityArtGradient extends StatelessWidget {
  const RarityArtGradient({required this.rarityColor, super.key});

  final Color rarityColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: _gradientStops,
          colors: [rarityColor.withValues(alpha: 0.55), rarityColor.withValues(alpha: 0.25), rarityColor.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
