import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/draggable_field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_appear.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/roster_unit_sheet.dart';

class TeamUnitsLayer extends StatelessWidget {
  const TeamUnitsLayer({
    required this.scale,
    required this.summonIds,
    required this.isDragActive,
    required this.matchProgress,
    required this.startingCombatants,
    super.key,
  });

  final double scale;
  final bool isDragActive;
  final MatchProgress matchProgress;
  final Map<Position, int> summonIds;
  final Map<Position, CombatReplayCombatant> startingCombatants;

  @override
  Widget build(BuildContext context) {
    final board = matchProgress.phase.engines.combatEngine.board;

    return Stack(
      children: [
        for (final placement in matchProgress.playerRoster.placements)
          Positioned.fromRect(
            key: ValueKey(placement.position),
            rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: scale),
            child: Center(
              child: SummonAppear(
                summonId: summonIds[placement.position],

                child: DraggableFieldUnit(
                  position: placement.position,
                  vitals: combatVitalsOf(startingCombatants[placement.position]!),
                  isAnotherDragActive: isDragActive,
                  diameter: fieldTokenDiameterFor(scale),
                  characterCopy: placement.characterCopy,
                  onPressed: () => presentRosterUnitSheet(
                    context,
                    matchProgress: matchProgress,
                    characterCopy: placement.characterCopy,
                    stats: startingCombatants[placement.position]!.stats,
                    rosterSlot: BoardSlot(position: placement.position),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
