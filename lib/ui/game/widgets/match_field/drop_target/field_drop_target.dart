import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/match_field/drop_target/field_cell_highlight.dart';

const _cellReachFraction = 0.75;

class FieldDropTarget extends StatelessWidget {
  final double scale;
  final RosterDrag? drag;
  final MatchProgress matchProgress;
  final void Function(RosterSlot draggedSlot, Position position) onSlotDropped;
  const FieldDropTarget({
    required this.drag,
    required this.scale,
    required this.matchProgress,
    required this.onSlotDropped,
    super.key,
  });

  Board get _board => matchProgress.phase.engines.combatEngine.board;

  @override
  Widget build(BuildContext context) {
    final board = _board;
    final rosterDragViewModel = context.read<RosterDragViewModel>();

    return DragTarget<RosterSlot>(
      onLeave: (data) => rosterDragViewModel.hoverCell(null),
      onMove: (details) => rosterDragViewModel.hoverCell(_nearestPositionTo(context, details.offset)),
      onAcceptWithDetails: (details) {
        final position = _nearestPositionTo(context, details.offset);
        rosterDragViewModel.hoverCell(null);
        if (position != null) onSlotDropped(details.data, position);
      },
      builder: (context, candidates, rejections) => Stack(
        children: [
          for (final position in board.allPositions)
            Positioned.fromRect(
              rect: BoardSceneLayout.cellRectOf(board, position, scale: scale),
              child: CustomPaint(painter: FieldCellHighlightPainter(highlight: _highlightOf(position))),
            ),
        ],
      ),
    );
  }

  Position? _nearestPositionTo(BuildContext context, Offset globalOffset) {
    final fieldBox = context.findRenderObject() as RenderBox?;
    if (fieldBox == null) return null;

    final board = _board;
    final localOffset = fieldBox.globalToLocal(globalOffset);
    var nearestDistance = BoardSceneLayout.cellSize.width * scale * _cellReachFraction;
    Position? nearestPosition;

    for (final position in board.allPositions) {
      final distance = (BoardSceneLayout.cellRectOf(board, position, scale: scale).center - localOffset).distance;
      if (distance > nearestDistance) continue;
      nearestDistance = distance;
      nearestPosition = position;
    }

    return nearestPosition;
  }

  FieldCellHighlight _highlightOf(Position position) {
    final drag = this.drag;
    if (drag == null) return FieldCellHighlight.none;

    final boardSlot = BoardSlot(position: position);
    final acceptsDrag = checkMovingCopyBetweenRosterSlots(matchProgress, to: boardSlot, from: drag.draggedSlot) == null;

    if (drag.hoveredPosition == position) return acceptsDrag ? FieldCellHighlight.hoveredAvailable : FieldCellHighlight.hoveredForbidden;
    return acceptsDrag ? FieldCellHighlight.available : FieldCellHighlight.none;
  }
}
