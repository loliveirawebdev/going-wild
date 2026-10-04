import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_event.dart';

class CopySoldFromRosterSlot extends PreparationEvent {
  const CopySoldFromRosterSlot({required this.from});
  final RosterSlot from;

  @override
  String toString() => 'CopySoldFromRosterSlot($from)';
}
