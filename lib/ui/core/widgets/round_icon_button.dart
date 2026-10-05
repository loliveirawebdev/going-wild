import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';

enum RoundIconButtonSize {
  small(diameter: 36, glyphSize: 18, gameIconSize: 24),
  medium(diameter: 48, glyphSize: 24, gameIconSize: 30),
  extraSmall(diameter: 30, glyphSize: 14, gameIconSize: 18);

  final double diameter;
  final double glyphSize;
  final double gameIconSize;
  const RoundIconButtonSize({required this.diameter, required this.glyphSize, required this.gameIconSize});
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    required InterfaceGlyph this.glyph,
    required this.label,
    required this.onPressed,
    super.key,
    this.disabledReason,
    this.size = RoundIconButtonSize.medium,
    this.variant = ButtonVariant.secondary,
  }) : gameIcon = null;

  const RoundIconButton.gameIcon({
    required GameIcon this.gameIcon,
    required this.label,
    required this.onPressed,
    super.key,
    this.disabledReason,
    this.size = RoundIconButtonSize.medium,
    this.variant = ButtonVariant.secondary,
  }) : glyph = null;

  final String label;
  final GameIcon? gameIcon;
  final InterfaceGlyph? glyph;
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
      child: Center(child: _buildIcon()),
    );
  }

  Widget _buildIcon() {
    final gameIcon = this.gameIcon;

    if (gameIcon == null) {
      return InterfaceGlyphImage(
        glyph!,
        size: size.glyphSize,
        color: isEnabled ? variant.foreground : AppColors.onDisabled,
      );
    }

    final gameIconImage = GameIconImage(gameIcon, size: size.gameIconSize);
    return isEnabled ? gameIconImage : ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: gameIconImage);
  }
}
