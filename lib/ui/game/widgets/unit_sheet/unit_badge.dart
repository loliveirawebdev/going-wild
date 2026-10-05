import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _labelStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class UnitBadge extends StatelessWidget {
  const UnitBadge({required this.icon, required this.label, super.key});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 2, 9, 2),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(label, style: _labelStyle),
        ],
      ),
    );
  }
}
