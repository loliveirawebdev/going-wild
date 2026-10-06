import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/projectiles/thrown_pebble.dart';

const _meleeRange = 1;

typedef _Throw = ({int id, Position from, Position to});

class RangedAttacksLayer extends StatefulWidget {
  final Board board;
  final double scale;
  const RangedAttacksLayer({required this.board, required this.scale, super.key});

  @override
  State<RangedAttacksLayer> createState() => _RangedAttacksLayerState();
}

class _RangedAttacksLayerState extends State<RangedAttacksLayer> {
  var _nextThrowId = 0;
  final _throws = <_Throw>[];

  void _throwPebblesOf(BuildContext context, CombatPlaybackState playbackState) {
    if (playbackState is! PlayingCombatPlaybackState || MediaQuery.disableAnimationsOf(context)) return;

    final combatantsById = {for (final combatant in playbackState.currentFrame.combatants) combatant.id: combatant};
    final newThrows = <_Throw>[
      for (final attack in playbackState.entriesSincePreviousTick.whereType<AttackLandedHistoryEntry>())
        if ((combatantsById[attack.combatantId], combatantsById[attack.targetCombatantId]) case (final attacker?, final target?)
            when attacker.attackRange > _meleeRange)
          (id: _nextThrowId++, from: attacker.position, to: target.position),
    ];

    if (newThrows.isNotEmpty) setState(() => _throws.addAll(newThrows));
  }

  void _removeThrow(int throwId) => setState(() => _throws.removeWhere((pebbleThrow) => pebbleThrow.id == throwId));

  Offset _centerOf(Position position) => BoardSceneLayout.cellRectOf(widget.board, position, scale: widget.scale).center;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CombatPlaybackBloc, CombatPlaybackState>(
      listener: _throwPebblesOf,
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final pebbleThrow in _throws)
              Positioned.fill(
                key: ValueKey(pebbleThrow.id),
                child: ThrownPebble(
                  from: _centerOf(pebbleThrow.from),
                  to: _centerOf(pebbleThrow.to),
                  onLanded: () => _removeThrow(pebbleThrow.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
