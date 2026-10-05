import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';

enum ButtonVariant {
  reward(background: AppColors.sun400, foreground: AppColors.ink, shadows: AppShadows.pressSun),
  primary(background: AppColors.grass400, foreground: AppColors.ink, shadows: AppShadows.pressGrass),
  danger(background: AppColors.barn600, foreground: AppColors.onPrimary, shadows: AppShadows.pressBarn),
  secondary(background: AppColors.surface100, foreground: AppColors.ink, shadows: AppShadows.pressNeutral);

  final Color background;
  final Color foreground;
  final List<BoxShadow> shadows;
  const ButtonVariant({required this.background, required this.foreground, required this.shadows});

  Color get border => shadows.first.color;
}

enum ButtonSize {
  small(fontSize: 15, lineHeight: 18, padding: EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.space3)),
  large(fontSize: 22, lineHeight: 26, padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.space6)),
  medium(fontSize: 18, lineHeight: 22, padding: EdgeInsets.symmetric(vertical: 10, horizontal: AppSpacing.space4)),
  extraLarge(fontSize: 24, lineHeight: 28, padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.space6));

  final double fontSize;
  final double lineHeight;
  final EdgeInsets padding;
  const ButtonSize({required this.fontSize, required this.lineHeight, required this.padding});
}

class Button extends StatelessWidget {
  const Button({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.trailing,
    this.disabledReason,
    this.fillsWidth = false,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final Widget? icon;
  final bool fillsWidth;
  final ButtonSize size;
  final Widget? trailing;
  final ButtonVariant variant;
  final String? disabledReason;
  final VoidCallback? onPressed;

  bool get isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final foreground = isEnabled ? variant.foreground : AppColors.onDisabled;

    final labelStyle = TextStyle(
      color: foreground,
      letterSpacing: 0.3,
      fontSize: size.fontSize,
      fontFamily: AppFonts.display,
      fontWeight: FontWeight.w400,
      height: size.lineHeight / size.fontSize,
    );

    return PressableSurface(
      onPressed: onPressed,
      padding: size.padding,
      borderRadius: AppRadius.medium,
      disabledReason: disabledReason,
      edgeColor: isEnabled ? variant.border : AppColors.disabledShadow,
      fillColor: isEnabled ? variant.background : AppColors.disabled,
      child: DefaultTextStyle(
        style: labelStyle,
        child: Row(
          spacing: AppSpacing.space2,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fillsWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null)
              SizedBox.square(
                dimension: size.fontSize,
                child: isEnabled ? icon : ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: icon),
              ),
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
