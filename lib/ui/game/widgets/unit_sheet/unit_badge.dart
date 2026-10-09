import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';

class UnitBadge extends StatelessWidget {
  const UnitBadge({required this.icon, required this.label, super.key});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Pill(
      spacing: 5,
      leading: icon,
      borderColor: AppColors.surface400,
      padding: const EdgeInsets.fromLTRB(3, 2, 9, 2),
      child: Text(label, style: AppTextStyles.tag),
    );
  }
}
