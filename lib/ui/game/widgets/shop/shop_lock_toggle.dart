import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';

const _toggleHeight = 38.0;
const _lockIconSize = 20.0;
const _pressedScaleReduction = 0.05;

const _labelStyle = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class ShopLockToggle extends StatelessWidget {
  const ShopLockToggle({required this.isLocked, required this.onPressed, super.key, this.disabledReason});

  final bool isLocked;
  final String? disabledReason;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.shop;
    final label = isLocked ? translations.unlockButton : translations.lockButton;
    const lockIcon = GameIconImage(GameIcon.lock, size: _lockIconSize);

    return Pressable(
      onPressed: onPressed,
      semanticLabel: label,
      disabledReason: disabledReason,
      builder: (context, pressedAmount, child) => Transform.scale(scale: 1 - _pressedScaleReduction * pressedAmount, child: child),
      child: AnimatedContainer(
        height: _toggleHeight,
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.only(left: 7, right: 12),
        decoration: BoxDecoration(
          borderRadius: AppRadius.pill,
          color: isLocked ? AppColors.sun400 : AppColors.surface100,
          border: Border.all(color: isLocked ? AppColors.sun600 : AppColors.surface400, width: AppBorderWidth.thick),
        ),
        child: Row(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLocked) lockIcon else ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: lockIcon),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _labelStyle.copyWith(color: onPressed == null ? AppColors.inkMuted : AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
