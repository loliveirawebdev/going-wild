import 'dart:ui';

import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

class RosterDrag {
  final Offset? globalPosition;
  final RosterSlot draggedSlot;
  final Position? hoveredPosition;
  const RosterDrag({required this.draggedSlot, this.globalPosition, this.hoveredPosition});

  RosterDrag createCopyMovedTo(Offset globalPosition) =>
      RosterDrag(draggedSlot: draggedSlot, globalPosition: globalPosition, hoveredPosition: hoveredPosition);

  RosterDrag createCopyHovering(Position? hoveredPosition) =>
      RosterDrag(draggedSlot: draggedSlot, globalPosition: globalPosition, hoveredPosition: hoveredPosition);
}
