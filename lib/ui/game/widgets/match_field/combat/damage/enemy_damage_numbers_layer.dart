import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/core/widgets/transient_effects.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/damage/floating_damage_number.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

const _minimumShownDamage = 0.5;
const _numberBoxSize = Size(48, 16);
const _sideSpreads = <double>[0, -7, 7];

typedef _DamageNumber = ({int amount, int combatantId, Position position});

class EnemyDamageNumbersLayer extends StatefulWidget {
  final Board board;
  final double scale;
  final CombatReplayFrame combatFrame;
  const EnemyDamageNumbersLayer({required this.board, required this.scale, required this.combatFrame, super.key});

  @override
  State<EnemyDamageNumbersLayer> createState() => _EnemyDamageNumbersLayerState();
}

class _EnemyDamageNumbersLayerState extends State<EnemyDamageNumbersLayer> with TransientEffects<EnemyDamageNumbersLayer, _DamageNumber> {
  void _showDamageOf(BuildContext context, CombatPlaybackState playbackState) {
    if (playbackState is! PlayingCombatPlaybackState || MediaQuery.disableAnimationsOf(context)) return;

    final combatantsById = {for (final combatant in playbackState.currentFrame.combatants) combatant.id: combatant};
    spawnEffects([
      for (final damage in playbackState.entriesSincePreviousTick.whereType<DamageTakenHistoryEntry>())
        if (combatantsById[damage.combatantId] case final victim?
            when victim.faction == Faction.enemy && damage.amount >= _minimumShownDamage)
          (amount: damage.amount.round(), combatantId: victim.id, position: victim.position),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final tokenRadius = fieldTokenDiameterFor(widget.scale) / 2;
    final positionsById = {for (final combatant in widget.combatFrame.combatants) combatant.id: combatant.position};

    return BlocListener<CombatPlaybackBloc, CombatPlaybackState>(
      listener: _showDamageOf,
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (:id, effect: damageNumber) in transientEffects)
              Positioned.fromRect(
                key: ValueKey(id),
                rect: Rect.fromCenter(
                  width: _numberBoxSize.width,
                  height: _numberBoxSize.height,
                  center:
                      BoardSceneLayout.cellRectOf(
                        widget.board,
                        positionsById[damageNumber.combatantId] ?? damageNumber.position,
                        scale: widget.scale,
                      ).center +
                      Offset(_sideSpreads[id % _sideSpreads.length], -tokenRadius),
                ),
                child: Center(
                  child: FloatingDamageNumber(amount: damageNumber.amount, onDone: () => finishEffect(id)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
