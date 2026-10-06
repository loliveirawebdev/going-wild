import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

class EnemyUnitsLayer extends StatelessWidget {
  final double scale;
  final bool isDragActive;
  final MatchProgress matchProgress;
  const EnemyUnitsLayer({required this.scale, required this.isDragActive, required this.matchProgress, super.key});

  @override
  Widget build(BuildContext context) {
    final engines = matchProgress.phase.engines;
    final board = engines.combatEngine.board;

    return IgnorePointer(
      ignoring: isDragActive,
      child: Stack(
        children: [
          for (final placement in matchProgress.currentWave.enemies)
            Positioned.fromRect(
              rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: scale),
              child: Center(
                child: GestureDetector(
                  onTap: () => presentUnitSheet(context, engines: engines, side: UnitSide.enemy, characterCopy: placement.characterCopy),
                  child: FieldUnit(
                    side: FieldUnitSide.enemy,
                    diameter: fieldTokenDiameterFor(scale),
                    characterCopy: placement.characterCopy,
                    vitals: startingVitalsOf(
                      engines.characterEngine.statsAtStars(placement.characterCopy.character, stars: placement.characterCopy.stars),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
