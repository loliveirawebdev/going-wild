import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/top_bar_pill.dart';

const _labelStyle = TextStyle(
  fontSize: 10,
  letterSpacing: 0.5,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _valueStyle = TextStyle(
  fontSize: 18,
  height: 20 / 18,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class RoundPill extends StatelessWidget {
  const RoundPill({required this.label, required this.roundCount, required this.roundNumber, super.key});

  final String label;
  final int roundCount;
  final int roundNumber;

  @override
  Widget build(BuildContext context) {
    return TopBarPill(
      edgeColor: AppColors.surface400,
      fillColor: AppColors.surface100,
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: _labelStyle),
          Text('$roundNumber/$roundCount', style: _valueStyle),
        ],
      ),
    );
  }
}
