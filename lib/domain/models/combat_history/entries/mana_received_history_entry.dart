part of 'combat_history_entry.dart';

class ManaReceivedHistoryEntry extends CombatConsequenceHistoryEntry {
  const ManaReceivedHistoryEntry({
    required super.tick,
    required super.cause,
    required this.amount,
    required super.combatantId,
    required this.currentMana,
  });

  final double amount;
  final double currentMana;

  static List<ManaReceivedHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.manaDifference > 0)
      ManaReceivedHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        amount: comparison.manaDifference,
        currentMana: comparison.after.currentMana,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWith(currentMana: currentMana);
}
