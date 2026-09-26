part of 'combat_history_entry.dart';

class MovementHistoryEntry extends CombatHistoryEntry {
  const MovementHistoryEntry({
    required super.tick,
    required this.toPosition,
    required this.combatantId,
    required this.fromPosition,
    required this.sourceCombatantId,
  });

  final int combatantId;
  final Position toPosition;
  final Position fromPosition;
  final int sourceCombatantId;
}
