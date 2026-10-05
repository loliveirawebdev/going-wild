import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_cell_target.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_rejection_toast.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_unit_token.dart';

const _tokenSizeFraction = 0.82;
const _toastDuration = Duration(milliseconds: 1800);
const _toastWidth = 220.0;
const _toastEdgeInset = 8.0;

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, preparationState) {
        if (preparationState is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = preparationState.matchProgress;
        final board = matchProgress.phase.engines.combatEngine.board;

        return BlocBuilder<RosterDragViewModel, RosterSlot?>(
          builder: (context, draggedSlot) => Stack(
            clipBehavior: Clip.none,
            children: [
              ..._buildCellTargets(matchProgress, draggedSlot),
              ..._buildUnitTokens(board, matchProgress.playerRoster.placements, side: FieldUnitSide.team),
              if (matchProgress.isInProgress) ..._buildUnitTokens(board, matchProgress.currentWave.enemies, side: FieldUnitSide.enemy),
              ?_buildRejectionToast(matchProgress),
            ],
          ),
        );
      },
    );
  }

  Iterable<Widget> _buildCellTargets(MatchProgress matchProgress, RosterSlot? draggedSlot) {
    final board = matchProgress.phase.engines.combatEngine.board;

    return [
      for (final position in board.allPositions)
        Positioned.fromRect(
          rect: BoardSceneLayout.cellRectOf(board, position, scale: widget.scale),
          child: FieldCellTarget(
            draggedSlot: draggedSlot,
            onSlotDropped: (slot) => _dropSlot(matchProgress, slot, position),
            acceptsSlot: (slot) =>
                checkMovingCopyBetweenRosterSlots(
                  matchProgress,
                  to: BoardSlot(position: position),
                  from: slot,
                ) ==
                null,
          ),
        ),
    ];
  }

  Iterable<Widget> _buildUnitTokens(Board board, List<Placement> placements, {required FieldUnitSide side}) {
    return [
      for (final placement in placements)
        Positioned.fromRect(
          rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: widget.scale),
          child: IgnorePointer(
            child: Center(
              child: FieldUnitToken(
                side: side,
                characterCopy: placement.characterCopy,
                diameter: BoardSceneLayout.cellSize.height * widget.scale * _tokenSizeFraction,
              ),
            ),
          ),
        ),
    ];
  }

  Widget? _buildRejectionToast(MatchProgress matchProgress) {
    final rejection = _rejection;
    if (rejection == null) return null;

    final board = matchProgress.phase.engines.combatEngine.board;
    final cellRect = BoardSceneLayout.cellRectOf(board, rejection.position, scale: widget.scale);

    final fieldWidth = BoardSceneLayout.imageSize.width * widget.scale;
    final left = (cellRect.center.dx - _toastWidth / 2).clamp(_toastEdgeInset, fieldWidth - _toastWidth - _toastEdgeInset);

    return Positioned(
      left: left,
      width: _toastWidth,
      top: cellRect.top - cellRect.height * 0.55,
      child: IgnorePointer(
        child: Center(child: FieldRejectionToast(message: rejection.message)),
      ),
    );
  }
}
