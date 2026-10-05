import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_cell_highlight.dart';

class FieldCellTarget extends StatelessWidget {
  final RosterSlot? draggedSlot;
  final bool Function(RosterSlot draggedSlot) acceptsSlot;
  final ValueChanged<RosterSlot> onSlotDropped;
  const FieldCellTarget({required this.acceptsSlot, required this.draggedSlot, required this.onSlotDropped, super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget<RosterSlot>(
      onAcceptWithDetails: (details) => onSlotDropped(details.data),
      builder: (context, candidates, rejections) {
        final hoveringSlot = candidates.nonNulls.firstOrNull;
        final draggedSlot = this.draggedSlot;

        final highlight = switch ((hoveringSlot, draggedSlot)) {
          (final RosterSlot hoveringSlot, _) when acceptsSlot(hoveringSlot) => FieldCellHighlight.hoveredAvailable,
          (RosterSlot(), _) => FieldCellHighlight.hoveredForbidden,
          (null, final RosterSlot draggedSlot) when acceptsSlot(draggedSlot) => FieldCellHighlight.available,
          _ => FieldCellHighlight.none,
        };

        return CustomPaint(painter: FieldCellHighlightPainter(highlight: highlight));
      },
    );
  }
}
