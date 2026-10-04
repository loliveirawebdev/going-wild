part of 'combat_history_entry.dart';

class DeathHistoryEntry extends CombatConsequenceHistoryEntry {
  const DeathHistoryEntry({required super.tick, required super.cause, required super.combatantId, required this.killerCombatantId});
  final int? killerCombatantId;

  static List<DeathHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.hasDied)
      DeathHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        killerCombatantId: comparison.damageSourceCombatantId,
      ),
  ];
}
