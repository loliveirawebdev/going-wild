import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/widgets/button.dart';

const _maxWidth = 250.0;

class SplashPlayButton extends StatelessWidget {
  const SplashPlayButton({required this.label, required this.onPressed, super.key, this.disabledReason});

  final String label;
  final String? disabledReason;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Button(
        label: label,
        fillsWidth: true,
        onPressed: onPressed,
        size: ButtonSize.extraLarge,
        disabledReason: disabledReason,
      ),
    );
  }
}
