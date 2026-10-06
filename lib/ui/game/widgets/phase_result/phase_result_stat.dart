import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _labelStyle = TextStyle(
  fontSize: 11,
  height: 14 / 11,
  letterSpacing: 0.6,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class PhaseResultStat extends StatelessWidget {
  final String label;
  final Widget value;
  const PhaseResultStat({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: _labelStyle),
          SizedBox(height: 28, child: Center(child: value)),
        ],
      ),
    );
  }
}
