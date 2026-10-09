import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/round/starting_combatants_of.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/player_options.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_units_layer.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/damage/enemy_damage_numbers_layer.dart';
import 'package:going_wild/ui/game/widgets/match_field/drop_target/field_drop_target.dart';
import 'package:going_wild/ui/game/widgets/match_field/rejection/field_rejection_toast.dart';
import 'package:going_wild/ui/game/widgets/match_field/stage/field_stage.dart';
import 'package:going_wild/ui/game/widgets/match_field/stage/field_stage_view.dart';
import 'package:going_wild/ui/game/widgets/match_field/summons/field_summon_poofs.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/enemy_units_layer.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/team_units_layer.dart';
import 'package:going_wild/ui/game/widgets/summon/roster_summons.dart';

const _toastDuration = Duration(milliseconds: 1800);

class MatchField extends StatefulWidget {
  final double scale;
  const MatchField({required this.scale, super.key});

  @override
  State<MatchField> createState() => _MatchFieldState();
}

class _MatchFieldState extends State<MatchField> {
  Timer? _toastTimer;
  FieldStage? _stage;
  ({String message, Position position})? _rejection;

  @override
  void dispose() {
    _toastTimer?.cancel();
    _stage?.unitPoints.dispose();
    super.dispose();
  }

  FieldStage _stageOf(MatchProgress matchProgress) {
    final combatEngine = matchProgress.phase.engines.combatEngine;
    return _stage ??= FieldStage(board: combatEngine.board, rules: combatEngine.rules);
  }

  void _dropSlot(RosterSlot draggedSlot, Position position) {
    context.read<PreparationBloc>().add(
      CopyMovedBetweenRosterSlots(
        to: BoardSlot(position: position),
        from: draggedSlot,
      ),
    );
  }

  bool _isNewRejection(PreparationState previous, PreparationState current) {
    final previousRejection = previous is ReadyPreparationState ? previous.rejection : null;
    final currentRejection = current is ReadyPreparationState ? current.rejection : null;
    return currentRejection != null && currentRejection.id != previousRejection?.id;
  }

  void _showRejection(BuildContext context, PreparationState preparationState) {
    final rejection = preparationState is ReadyPreparationState ? preparationState.rejection : null;
    final rejectedEvent = rejection?.event;
    if (rejection == null || rejectedEvent is! CopyMovedBetweenRosterSlots) return;

    final target = rejectedEvent.to;
    if (target is! BoardSlot) return;

    _toastTimer?.cancel();
    _toastTimer = Timer(_toastDuration, () => setState(() => _rejection = null));
    setState(() => _rejection = (message: rejectionMessageOf(context.t, rejection.error), position: target.position));
  }

  CombatReplayFrame? _combatFrameOf(CombatPlaybackState playbackState) => switch (playbackState) {
    PlayingCombatPlaybackState() => playbackState.currentFrame,
    FinishedCombatPlaybackState() => playbackState.finalFrame,
    IdleCombatPlaybackState() => null,
  };

  Widget _buildCombatLayers(MatchProgress matchProgress) {
    final scale = widget.scale;
    final board = matchProgress.phase.engines.combatEngine.board;

    return BlocBuilder<CombatPlaybackBloc, CombatPlaybackState>(
      buildWhen: (previous, current) => !identical(_combatFrameOf(previous), _combatFrameOf(current)),
      builder: (context, playbackState) {
        final combatFrame = _combatFrameOf(playbackState);
        if (combatFrame == null) return const SizedBox.shrink();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CombatUnitsLayer(
                scale: scale,
                combatFrame: combatFrame,
                matchProgress: matchProgress,
                unitPoints: _stageOf(matchProgress).unitPoints,
              ),
            ),
            Positioned.fill(
              child: EnemyDamageNumbersLayer(scale: scale, board: board, combatFrame: combatFrame),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreparationBloc, PreparationState>(
      listenWhen: _isNewRejection,
      listener: _showRejection,
      builder: (context, preparationState) {
        if (preparationState is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = preparationState.matchProgress;

        return RosterSummons<Position>(
          slotKeyOf: (slot) => switch (slot) {
            BoardSlot(:final position) => position,
            InventorySlot() => null,
          },
          builder: (context, summonIds, onSummonFinished) => BlocBuilder<RosterDragViewModel, RosterDrag?>(
            buildWhen: (previous, current) =>
                previous?.draggedSlot != current?.draggedSlot || previous?.hoveredPosition != current?.hoveredPosition,
            builder: (context, drag) => _buildLayers(
              drag: drag,
              summonIds: summonIds,
              matchProgress: matchProgress,
              onSummonFinished: onSummonFinished,
            ),
          ),
        );
      },
    );
  }

  Iterable<CombatReplayCombatant> _standingCombatantsOf(
    MatchProgress matchProgress, {
    required Map<Position, CombatReplayCombatant> startingCombatants,
  }) {
    if (matchProgress.isInProgress) return startingCombatants.values;
    return startingCombatants.values.where((combatant) => combatant.faction == Faction.team);
  }

  Widget _buildLayers({
    required RosterDrag? drag,
    required MatchProgress matchProgress,
    required Map<Position, int> summonIds,
    required SummonFinished<Position> onSummonFinished,
  }) {
    final scale = widget.scale;
    final rejection = _rejection;
    final isDragActive = drag != null;
    final isFighting = matchProgress.roundStage == RoundStage.fighting;
    final startingCombatants = isFighting
        ? const <Position, CombatReplayCombatant>{}
        : {
            for (final combatant in startingCombatantsOf(matchProgress)) combatant.position: CombatReplayCombatant.fromCombatant(combatant),
          };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: FieldDropTarget(
            drag: drag,
            scale: scale,
            matchProgress: matchProgress,
            onSlotDropped: _dropSlot,
          ),
        ),
        Positioned.fill(
          child: FieldStageView(
            stage: _stageOf(matchProgress),
            standingCombatants: isFighting ? null : _standingCombatantsOf(matchProgress, startingCombatants: startingCombatants),
            hiddenIds: {
              if (drag?.draggedSlot case BoardSlot(:final position)) ?startingCombatants[position]?.id,
            },
          ),
        ),

        if (isFighting) ...[
          Positioned.fill(child: _buildCombatLayers(matchProgress)),
        ] else ...[
          Positioned.fill(
            child: TeamUnitsLayer(
              scale: scale,
              canRearrangeRoster: PlayerOptions(matchProgress).canRearrangeRoster,
              summonIds: summonIds,
              startingCombatants: startingCombatants,
              isDragActive: isDragActive,
              matchProgress: matchProgress,
            ),
          ),
          if (matchProgress.isInProgress)
            Positioned.fill(
              child: EnemyUnitsLayer(
                scale: scale,
                startingCombatants: startingCombatants,
                isDragActive: isDragActive,
                matchProgress: matchProgress,
              ),
            ),
          Positioned.fill(
            child: FieldSummonPoofs(
              scale: scale,
              summonIds: summonIds,
              onSummonFinished: onSummonFinished,
              board: matchProgress.phase.engines.combatEngine.board,
            ),
          ),
        ],

        if (rejection != null)
          PositionedFieldRejectionToast(
            scale: scale,
            message: rejection.message,
            position: rejection.position,
            board: matchProgress.phase.engines.combatEngine.board,
          ),
      ],
    );
  }
}
