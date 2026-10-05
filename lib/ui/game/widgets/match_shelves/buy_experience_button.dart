import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';

const _coinSize = 14.0;

const _labelStyle = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class BuyExperienceButton extends StatelessWidget {
  const BuyExperienceButton({
    required this.label,
    required this.onPressed,
    required this.costInCoins,
    required this.semanticLabel,
    super.key,
    this.disabledReason,
  });

  final String label;
  final int costInCoins;
  final String semanticLabel;
  final String? disabledReason;
  final VoidCallback? onPressed;

  bool get isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    const coin = GameIconImage(GameIcon.gold, size: _coinSize);

    return PressableSurface(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      borderRadius: AppRadius.pill,
      disabledReason: disabledReason,
      padding: const EdgeInsets.fromLTRB(9, 3, 8, 3),
      edgeColor: isEnabled ? AppColors.sun600 : AppColors.disabledShadow,
      fillColor: isEnabled ? AppColors.sun400 : AppColors.disabled,
      child: DefaultTextStyle(
        style: _labelStyle.copyWith(color: isEnabled ? AppColors.ink : AppColors.onDisabled),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            Row(
              spacing: 1,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEnabled) coin else ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: coin),
                Text('$costInCoins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
