part of 'combat_history_entry.dart';

class AttackLandedHistoryEntry extends CombatHistoryEntry {
  const AttackLandedHistoryEntry({required super.tick, required this.combatantId, required this.targetCombatantId});
  final int targetCombatantId;
  final int combatantId;
}
