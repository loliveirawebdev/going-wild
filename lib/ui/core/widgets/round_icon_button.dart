import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';

enum RoundIconButtonSize {
  small(diameter: 36, glyphSize: 18),
  medium(diameter: 48, glyphSize: 24);

  final double diameter;
  final double glyphSize;
  const RoundIconButtonSize({required this.diameter, required this.glyphSize});
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    required this.glyph,
    required this.label,
    required this.onPressed,
    super.key,
    this.disabledReason,
    this.size = RoundIconButtonSize.medium,
    this.variant = ButtonVariant.secondary,
  });

  final String label;
  final InterfaceGlyph glyph;
  final ButtonVariant variant;
  final String? disabledReason;
  final VoidCallback? onPressed;
  final RoundIconButtonSize size;

  bool get isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return PressableSurface(
      onPressed: onPressed,
      semanticLabel: label,
      width: size.diameter,
      height: size.diameter,
      borderRadius: AppRadius.pill,
      disabledReason: disabledReason,
      edgeColor: isEnabled ? variant.border : AppColors.disabledShadow,
      fillColor: isEnabled ? variant.background : AppColors.disabled,
      child: Center(
        child: InterfaceGlyphImage(
          glyph,
          size: size.glyphSize,
          color: isEnabled ? variant.foreground : AppColors.onDisabled,
        ),
      ),
    );
  }
}
