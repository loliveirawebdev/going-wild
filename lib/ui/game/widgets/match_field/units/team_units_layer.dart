import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/draggable_field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/roster_unit_sheet.dart';

class TeamUnitsLayer extends StatelessWidget {
  final double scale;
  final bool isDragActive;
  final MatchProgress matchProgress;
  const TeamUnitsLayer({required this.scale, required this.isDragActive, required this.matchProgress, super.key});

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
              child: DraggableFieldUnit(
                position: placement.position,
                isAnotherDragActive: isDragActive,
                diameter: fieldTokenDiameterFor(scale),
                characterCopy: placement.characterCopy,
                onPressed: () => presentRosterUnitSheet(
                  context,
                  matchProgress: matchProgress,
                  characterCopy: placement.characterCopy,
                  rosterSlot: BoardSlot(position: placement.position),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
