import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_units_layer.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/enemy_units_layer.dart';
import 'package:going_wild/ui/game/widgets/match_field/drop_target/field_drop_target.dart';
import 'package:going_wild/ui/game/widgets/match_field/rejection/field_rejection_toast.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/team_units_layer.dart';

const _toastDuration = Duration(milliseconds: 1800);

class MatchField extends StatefulWidget {
  final double scale;
  const MatchField({required this.scale, super.key});

  @override
  State<MatchField> createState() => _MatchFieldState();
}

class _MatchFieldState extends State<MatchField> {
  Timer? _toastTimer;
  ({String message, Position position})? _rejection;

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _dropSlot(MatchProgress matchProgress, RosterSlot draggedSlot, Position position) {
    final boardSlot = BoardSlot(position: position);
    final rejection = checkMovingCopyBetweenRosterSlots(matchProgress, to: boardSlot, from: draggedSlot);

    if (rejection == null) {
      context.read<PreparationBloc>().add(CopyMovedBetweenRosterSlots(to: boardSlot, from: draggedSlot));
      return;
    }

    _toastTimer?.cancel();
    _toastTimer = Timer(_toastDuration, () => setState(() => _rejection = null));
    setState(() => _rejection = (message: rejectionMessageOf(context.t, rejection), position: position));
  }

  CombatReplayFrame? _combatFrameOf(MatchProgress matchProgress, CombatPlaybackState playbackState) {
    if (matchProgress.roundStage != RoundStage.fighting) return null;

    return switch (playbackState) {
      PlayingCombatPlaybackState() => playbackState.currentFrame,
      FinishedCombatPlaybackState() => playbackState.finalFrame,
      IdleCombatPlaybackState() => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, preparationState) {
        if (preparationState is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = preparationState.matchProgress;

        return BlocBuilder<CombatPlaybackBloc, CombatPlaybackState>(
          builder: (context, playbackState) => BlocBuilder<RosterDragViewModel, RosterDrag?>(
            buildWhen: (previous, current) =>
                previous?.draggedSlot != current?.draggedSlot || previous?.hoveredPosition != current?.hoveredPosition,
            builder: (context, drag) => _buildLayers(matchProgress, _combatFrameOf(matchProgress, playbackState), drag),
          ),
        );
      },
    );
  }

  Widget _buildLayers(MatchProgress matchProgress, CombatReplayFrame? combatFrame, RosterDrag? drag) {
    final scale = widget.scale;
    final rejection = _rejection;
    final isDragActive = drag != null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: FieldDropTarget(
            drag: drag,
            scale: scale,
            matchProgress: matchProgress,
            onSlotDropped: (draggedSlot, position) => _dropSlot(matchProgress, draggedSlot, position),
          ),
        ),
        if (combatFrame != null)
          Positioned.fill(
            child: CombatUnitsLayer(scale: scale, combatFrame: combatFrame, matchProgress: matchProgress),
          )
        else ...[
          Positioned.fill(
            child: TeamUnitsLayer(scale: scale, isDragActive: isDragActive, matchProgress: matchProgress),
          ),
          if (matchProgress.isInProgress)
            Positioned.fill(
              child: EnemyUnitsLayer(scale: scale, isDragActive: isDragActive, matchProgress: matchProgress),
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
