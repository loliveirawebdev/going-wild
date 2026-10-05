import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

class RosterDragViewModel extends Cubit<RosterSlot?> {
  RosterDragViewModel() : super(null);

  void stopDragging() => emit(null);
  void startDragging(RosterSlot draggedSlot) => emit(draggedSlot);
}
