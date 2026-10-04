part of 'combat_history_entry.dart';

class HealReceivedHistoryEntry extends CombatConsequenceHistoryEntry {
  const HealReceivedHistoryEntry({
    required super.tick,
    required super.cause,
    required this.amount,
    required super.combatantId,
    required this.currentHealth,
    required this.sourceCombatantId,
  });

  final double amount;
  final double currentHealth;
  final int? sourceCombatantId;

  static List<HealReceivedHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.healthDifference > 0)
      HealReceivedHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        amount: comparison.healthDifference,
        currentHealth: comparison.after.currentHealth,
        sourceCombatantId: comparison.healSourceCombatantId,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWith(currentHealth: currentHealth);
}
