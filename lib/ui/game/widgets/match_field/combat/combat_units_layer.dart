import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/player_options.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/live_combat_unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

const _combatStepDuration = Duration(milliseconds: 180);

class CombatUnitsLayer extends StatelessWidget {
  final double scale;
  final CombatReplayFrame combatFrame;
  final MatchProgress matchProgress;
  const CombatUnitsLayer({required this.scale, required this.combatFrame, required this.matchProgress, super.key});

  @override
  Widget build(BuildContext context) {
    final board = matchProgress.phase.engines.combatEngine.board;
    final combatantsInPaintOrder = [
      ...combatFrame.combatants.where((combatant) => !combatant.isAlive),
      ...combatFrame.combatants.where((combatant) => combatant.isAlive),
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final combatant in combatantsInPaintOrder)
          AnimatedPositioned.fromRect(
            key: ValueKey(combatant.id),
            curve: Curves.easeOut,
            duration: _combatStepDuration,
            rect: BoardSceneLayout.cellRectOf(board, combatant.position, scale: scale),
            child: OverflowBox(
              maxHeight: double.infinity,
              child: GestureDetector(
                onTap: () => _openSheetOf(context, combatant),
                child: CombatUnit(diameter: fieldTokenDiameterFor(scale), combatant: combatant),
              ),
            ),
          ),
      ],
    );
  }

  void _openSheetOf(BuildContext context, CombatReplayCombatant combatant) {
    final engines = matchProgress.phase.engines;
    final characterCopy = combatant.characterCopy;

    if (combatant.faction == Faction.enemy) {
      presentLiveCombatUnitSheet(context, engines: engines, side: UnitSide.enemy, combatant: combatant);
      return;
    }

    final (:valueInCoins, :rejection) = PlayerOptions(matchProgress).saleOf(characterCopy);

    presentLiveCombatUnitSheet(
      context,
      engines: engines,
      side: UnitSide.team,
      combatant: combatant,
      sale: UnitSale(
        onSell: null,
        valueInCoins: valueInCoins,
        disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
      ),
    );
  }
}
