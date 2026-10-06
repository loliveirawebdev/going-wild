import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _pillHeight = 38.0;
const _iconSize = 26.0;

const _valueStyle = TextStyle(
  fontSize: 20,
  height: 1,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _labelStyle = TextStyle(
  fontSize: 13,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class RewardPill extends StatelessWidget {
  final String value;
  final String label;
  final GameIcon icon;
  final bool isNegative;
  const RewardPill({required this.icon, required this.value, required this.label, super.key, this.isNegative = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
      child: Container(
        height: _pillHeight,
        padding: const EdgeInsets.only(left: 6, right: 14),
        decoration: BoxDecoration(
          color: AppColors.surface100,
          borderRadius: AppRadius.pill,
          boxShadow: AppShadows.pressNeutral,
          border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
        ),
        child: Row(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: [
            GameIconImage(icon, size: _iconSize),
            Text(value, style: _valueStyle.copyWith(color: isNegative ? AppColors.danger : AppColors.grass600)),
            Text(label, style: _labelStyle),
          ],
        ),
      ),
    );
  }
}
