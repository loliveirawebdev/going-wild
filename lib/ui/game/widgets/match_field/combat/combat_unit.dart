import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit_bars.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

const _barsGap = 2.0;
const _fadeDuration = Duration(milliseconds: 250);

class CombatUnit extends StatelessWidget {
  final double diameter;
  final CombatReplayCombatant combatant;
  const CombatUnit({required this.diameter, required this.combatant, super.key});

  @override
  Widget build(BuildContext context) {
    final token = FieldUnitToken(
      diameter: diameter,
      characterCopy: combatant.characterCopy,
      side: combatant.faction == Faction.team ? FieldUnitSide.team : FieldUnitSide.enemy,
    );

    if (!combatant.isAlive) {
      return AnimatedOpacity(
        opacity: 0.45,
        duration: _fadeDuration,
        child: ColorFiltered(colorFilter: AppColorFilters.inactiveIcon, child: token),
      );
    }

    return Column(
      spacing: _barsGap,
      mainAxisSize: MainAxisSize.min,
      children: [
        token,
        CombatUnitBars(width: diameter, combatant: combatant),
      ],
    );
  }
}
