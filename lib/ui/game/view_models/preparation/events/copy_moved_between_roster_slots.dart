import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_event.dart';

class CopyMovedBetweenRosterSlots extends PreparationEvent {
  final RosterSlot to;
  final RosterSlot from;
  const CopyMovedBetweenRosterSlots({required this.to, required this.from});

  @override
  String toString() => 'CopyMovedBetweenRosterSlots($from -> $to)';
}
