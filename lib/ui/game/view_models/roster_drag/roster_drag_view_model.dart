import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';

class RosterDragViewModel extends Cubit<RosterDrag?> {
  RosterDragViewModel() : super(null);

  void stopDragging() => emit(null);
  void startDragging(RosterSlot draggedSlot) => emit(RosterDrag(draggedSlot: draggedSlot));

  void moveDragTo(Offset globalPosition) {
    final drag = state;
    if (drag == null) return;
    emit(RosterDrag(draggedSlot: drag.draggedSlot, globalPosition: globalPosition));
  }
}
