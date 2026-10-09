import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/low_health_trigger.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/localization/ability_lines.dart';
import 'package:going_wild/ui/core/localization/formatted_number.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _costIconSize = 14.0;

const _costStyle = TextStyle(
  fontSize: 14,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _triggerStyle = TextStyle(
  fontSize: 11,
  height: 14 / 11,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _lineStyle = TextStyle(
  fontSize: 13,
  height: 18 / 13,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class UnitAbilityBlock extends StatelessWidget {
  const UnitAbilityBlock({required this.stars, required this.ability, required this.manaCost, super.key});

  final int stars;
  final double manaCost;
  final Ability ability;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        color: Color.lerp(AppColors.surface100, AppColors.mana, 0.14),
        border: Border.all(color: Color.lerp(AppColors.surface400, AppColors.mana, 0.55)!, width: AppBorderWidth.thin),
      ),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(translations.abilityTitle.toUpperCase(), style: AppTextStyles.overline)),
              _buildTrigger(context),
            ],
          ),
          for (final line in abilityLinesOf(context.t, ability, stars: stars)) Text(line, style: _lineStyle),
        ],
      ),
    );
  }

  Widget _buildTrigger(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final trigger = ability.trigger;

    if (trigger is LowHealthTrigger) {
      return Text(translations.lowHealthTrigger(percentage: formattedNumberOf(context.t, trigger.healthPercentage)), style: _triggerStyle);
    }

    return Semantics(
      label: translations.manaCostLabel(cost: manaCost.round()),
      child: ExcludeSemantics(
        child: Row(
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            const GameIconImage(GameIcon.mana, size: _costIconSize),
            Text('${manaCost.round()}', style: _costStyle),
          ],
        ),
      ),
    );
  }
}
