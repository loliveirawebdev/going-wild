part of 'combat_history_entry.dart';

class DamageTakenHistoryEntry extends CombatConsequenceHistoryEntry {
  const DamageTakenHistoryEntry({
    required super.tick,
    required super.cause,
    required this.amount,
    required super.combatantId,
    required this.currentHealth,
    required this.absorbedByShield,
    required this.sourceCombatantId,
  });

  final double amount;
  final double currentHealth;
  final int? sourceCombatantId;
  final double absorbedByShield;

  static List<DamageTakenHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.damageAmount > 0)
      DamageTakenHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        amount: comparison.damageAmount,
        combatantId: comparison.after.id,
        currentHealth: comparison.after.currentHealth,
        absorbedByShield: comparison.absorbedByShield,
        sourceCombatantId: comparison.damageSourceCombatantId,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWith(currentHealth: currentHealth);
}
