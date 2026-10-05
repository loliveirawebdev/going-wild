import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/top_bar_pill.dart';

const _stageStyle = TextStyle(
  fontSize: 11,
  letterSpacing: 0.4,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

class RoundStagePill extends StatelessWidget {
  const RoundStagePill({required this.roundStage, super.key});
  final RoundStage roundStage;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.topBar;

    return switch (roundStage) {
      RoundStage.preparing => TopBarPill(
        fillColor: AppColors.sky300,
        edgeColor: AppColors.surface400,
        child: Text(translations.preparing.toUpperCase(), maxLines: 1, style: _stageStyle),
      ),

      RoundStage.fighting => TopBarPill(
        edgeColor: AppColors.grass600,
        fillColor: AppColors.grass400,
        child: Text(translations.fighting.toUpperCase(), maxLines: 1, style: _stageStyle),
      ),
    };
  }
}
