part of 'combat_history_entry.dart';

class HealReceivedHistoryEntry extends CombatHistoryEntry {
  const HealReceivedHistoryEntry({
    required super.tick,
    required this.amount,
    required this.combatantId,
    required this.currentHealth,
    required this.sourceCombatantId,
  });

  final double amount;
  final int combatantId;
  final double currentHealth;
  final int? sourceCombatantId;
}
