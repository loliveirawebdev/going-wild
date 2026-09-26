part of 'combat_history_entry.dart';

class TargetAcquiredHistoryEntry extends CombatHistoryEntry {
  const TargetAcquiredHistoryEntry({required super.tick, required this.combatantId, required this.targetCombatantId});
  final int targetCombatantId;
  final int combatantId;
}
