import 'dart:ui';

import 'package:going_wild/domain/models/roster/roster_slot.dart';

class RosterDrag {
  final Offset? globalPosition;
  final RosterSlot draggedSlot;
  const RosterDrag({required this.draggedSlot, this.globalPosition});
}
