import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';

class RosterDragViewModel extends Cubit<RosterDrag?> {
  RosterDragViewModel() : super(null);

  void startDragging(RosterSlot draggedSlot) => emit(RosterDrag(draggedSlot: draggedSlot));
  void stopDragging() => emit(null);

  void moveDragTo(Offset globalPosition) {
    final drag = state;
    if (drag != null) emit(drag.createCopyMovedTo(globalPosition));
  }

  void hoverCell(Position? position) {
    final drag = state;
    if (drag != null && drag.hoveredPosition != position) emit(drag.createCopyHovering(position));
  }
}
