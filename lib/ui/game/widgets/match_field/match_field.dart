import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/copy_moved_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/draggable_field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_cell_highlight.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_rejection_toast.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/roster_unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

const _tokenSizeFraction = 0.82;
const _cellReachFraction = 0.75;
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
  final _fieldTargetKey = GlobalKey();
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

        return BlocBuilder<RosterDragViewModel, RosterDrag?>(
          buildWhen: (previous, current) =>
              previous?.draggedSlot != current?.draggedSlot || previous?.hoveredPosition != current?.hoveredPosition,
          builder: (context, drag) => Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: _buildFieldTarget(matchProgress, drag)),
              ..._buildTeamUnits(matchProgress, isDragActive: drag != null),
              if (matchProgress.isInProgress) ..._buildEnemyUnits(matchProgress, isDragActive: drag != null),
              ?_buildRejectionToast(matchProgress),
            ],
          ),
        );
      },
    );
  }

  Position? _nearestPositionTo(Board board, Offset globalOffset) {
    final fieldBox = _fieldTargetKey.currentContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null) return null;

    final localOffset = fieldBox.globalToLocal(globalOffset);
    final reachDistance = BoardSceneLayout.cellSize.width * widget.scale * _cellReachFraction;
    Position? nearestPosition;
    var nearestDistance = reachDistance;

    for (final position in board.allPositions) {
      final distance = (BoardSceneLayout.cellRectOf(board, position, scale: widget.scale).center - localOffset).distance;
      if (distance > nearestDistance) continue;
      nearestDistance = distance;
      nearestPosition = position;
    }

    return nearestPosition;
  }

  Widget _buildFieldTarget(MatchProgress matchProgress, RosterDrag? drag) {
    final board = matchProgress.phase.engines.combatEngine.board;
    final rosterDragViewModel = context.read<RosterDragViewModel>();

    return DragTarget<RosterSlot>(
      key: _fieldTargetKey,
      onLeave: (data) => rosterDragViewModel.hoverCell(null),
      onMove: (details) => rosterDragViewModel.hoverCell(_nearestPositionTo(board, details.offset)),
      onAcceptWithDetails: (details) {
        final position = _nearestPositionTo(board, details.offset);
        rosterDragViewModel.hoverCell(null);
        if (position != null) _dropSlot(matchProgress, details.data, position);
      },
      builder: (context, candidates, rejections) => Stack(
        children: [
          for (final position in board.allPositions)
            Positioned.fromRect(
              rect: BoardSceneLayout.cellRectOf(board, position, scale: widget.scale),
              child: CustomPaint(painter: FieldCellHighlightPainter(highlight: _highlightOf(matchProgress, position, drag))),
            ),
        ],
      ),
    );
  }

  FieldCellHighlight _highlightOf(MatchProgress matchProgress, Position position, RosterDrag? drag) {
    if (drag == null) return FieldCellHighlight.none;
    final acceptsDrag =
        checkMovingCopyBetweenRosterSlots(
          matchProgress,
          to: BoardSlot(position: position),
          from: drag.draggedSlot,
        ) ==
        null;

    if (drag.hoveredPosition == position) return acceptsDrag ? FieldCellHighlight.hoveredAvailable : FieldCellHighlight.hoveredForbidden;
    return acceptsDrag ? FieldCellHighlight.available : FieldCellHighlight.none;
  }

  double get _tokenDiameter => BoardSceneLayout.cellSize.height * widget.scale * _tokenSizeFraction;

  Iterable<Widget> _buildTeamUnits(MatchProgress matchProgress, {required bool isDragActive}) {
    final board = matchProgress.phase.engines.combatEngine.board;

    return [
      for (final placement in matchProgress.playerRoster.placements)
        Positioned.fromRect(
          key: ValueKey(placement.position),
          rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: widget.scale),
          child: Center(
            child: DraggableFieldUnit(
              diameter: _tokenDiameter,
              position: placement.position,
              isAnotherDragActive: isDragActive,
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
    ];
  }

  Iterable<Widget> _buildEnemyUnits(MatchProgress matchProgress, {required bool isDragActive}) {
    final engines = matchProgress.phase.engines;
    final board = engines.combatEngine.board;

    return [
      for (final placement in matchProgress.currentWave.enemies)
        Positioned.fromRect(
          rect: BoardSceneLayout.cellRectOf(board, placement.position, scale: widget.scale),
          child: IgnorePointer(
            ignoring: isDragActive,
            child: Center(
              child: GestureDetector(
                onTap: () => presentUnitSheet(context, engines: engines, side: UnitSide.enemy, characterCopy: placement.characterCopy),
                child: FieldUnitToken(side: FieldUnitSide.enemy, diameter: _tokenDiameter, characterCopy: placement.characterCopy),
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
