part of 'combat_history_entry.dart';

class DamageTakenHistoryEntry extends CombatHistoryEntry {
  const DamageTakenHistoryEntry({
    required super.tick,
    required this.amount,
    required this.combatantId,
    required this.currentHealth,
    required this.absorbedByShield,
    required this.sourceCombatantId,
  });

  final double amount;
  final int combatantId;
  final double currentHealth;
  final int? sourceCombatantId;
  final double absorbedByShield;
}
