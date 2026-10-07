import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/damage/floating_damage_number.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

const _minimumShownDamage = 0.5;
const _numberBoxSize = Size(48, 16);
const _sideSpreads = <double>[0, -7, 7];

typedef _DamageNumber = ({int id, int amount, int combatantId, Position position, double sideSpread});

class EnemyDamageNumbersLayer extends StatefulWidget {
  final Board board;
  final double scale;
  final CombatReplayFrame combatFrame;
  const EnemyDamageNumbersLayer({required this.board, required this.scale, required this.combatFrame, super.key});

  @override
  State<EnemyDamageNumbersLayer> createState() => _EnemyDamageNumbersLayerState();
}

class _EnemyDamageNumbersLayerState extends State<EnemyDamageNumbersLayer> {
  var _nextNumberId = 0;
  final _damageNumbers = <_DamageNumber>[];

  void _showDamageOf(BuildContext context, CombatPlaybackState playbackState) {
    if (playbackState is! PlayingCombatPlaybackState || MediaQuery.disableAnimationsOf(context)) return;

    final combatantsById = {for (final combatant in playbackState.currentFrame.combatants) combatant.id: combatant};

    final newNumbers = <_DamageNumber>[
      for (final damage in playbackState.entriesSincePreviousTick.whereType<DamageTakenHistoryEntry>())
        if (combatantsById[damage.combatantId] case final victim?
            when victim.faction == Faction.enemy && damage.amount >= _minimumShownDamage)
          (
            id: _nextNumberId,
            amount: damage.amount.round(),
            combatantId: victim.id,
            position: victim.position,
            sideSpread: _sideSpreads[_nextNumberId++ % _sideSpreads.length],
          ),
    ];

    if (newNumbers.isNotEmpty) setState(() => _damageNumbers.addAll(newNumbers));
  }

  void _removeNumber(int numberId) => setState(() => _damageNumbers.removeWhere((damageNumber) => damageNumber.id == numberId));

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
            for (final damageNumber in _damageNumbers)
              Positioned.fromRect(
                key: ValueKey(damageNumber.id),
                rect: Rect.fromCenter(
                  width: _numberBoxSize.width,
                  height: _numberBoxSize.height,
                  center:
                      BoardSceneLayout.cellRectOf(
                        widget.board,
                        positionsById[damageNumber.combatantId] ?? damageNumber.position,
                        scale: widget.scale,
                      ).center +
                      Offset(damageNumber.sideSpread, -tokenRadius),
                ),
                child: Center(
                  child: FloatingDamageNumber(amount: damageNumber.amount, onDone: () => _removeNumber(damageNumber.id)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
