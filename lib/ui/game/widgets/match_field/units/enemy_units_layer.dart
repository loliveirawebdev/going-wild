import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/ui/core/widgets/transient_effects.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_head_height.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/summons/field_summon_poofs.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_appear.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

class EnemyUnitsLayer extends StatefulWidget {
  final double scale;
  final bool isDragActive;
  final MatchProgress matchProgress;
  final Map<Position, CombatReplayCombatant> startingCombatants;
  const EnemyUnitsLayer({
    required this.scale,
    required this.isDragActive,
    required this.matchProgress,
    required this.startingCombatants,
    super.key,
  });

  @override
  State<EnemyUnitsLayer> createState() => _EnemyUnitsLayerState();
}

class _EnemyUnitsLayerState extends State<EnemyUnitsLayer> with TransientEffects<EnemyUnitsLayer, Position> {
  Iterable<Position> get _wavePositions => widget.matchProgress.currentWave.enemies.map((placement) => placement.position);

  @override
  void initState() {
    super.initState();
    seedEffects(_wavePositions);
  }

  @override
  void didUpdateWidget(EnemyUnitsLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchProgress.currentRoundNumber != oldWidget.matchProgress.currentRoundNumber) {
      seedEffects(_wavePositions, replacesEqualEffects: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final engines = widget.matchProgress.phase.engines;
    final board = engines.combatEngine.board;
    final summonIds = MediaQuery.disableAnimationsOf(context) ? const <Position, int>{} : transientEffectIds;

    return IgnorePointer(
      ignoring: widget.isDragActive,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final placement in widget.matchProgress.currentWave.enemies)
            Positioned.fromRect(
              rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: scale),
              child: Center(
                child: SummonAppear(
                  summonId: summonIds[placement.position],
                  child: GestureDetector(
                    onTap: () => presentUnitSheet(
                      context,
                      engines: engines,
                      side: UnitSide.enemy,
                      characterCopy: placement.characterCopy,
                      stats: widget.startingCombatants[placement.position]!.stats,
                    ),
                    child: FieldUnit(
                      diameter: fieldTokenDiameterFor(scale),
                      characterCopy: placement.characterCopy,
                      vitals: combatVitalsOf(widget.startingCombatants[placement.position]!),
                      statusSpot: AboveHeadStatusSpot(
                        headHeight: headHeightAboveCellCenterOf(placement.characterCopy.character.sprite) * scale,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: FieldSummonPoofs(
              board: board,
              scale: scale,
              summonIds: summonIds,
              onSummonFinished: (position, summonId) => finishEffect(summonId),
            ),
          ),
        ],
      ),
    );
  }
}
