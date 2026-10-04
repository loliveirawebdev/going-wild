part of 'combat_history_entry.dart';

class AbilityCastHistoryEntry extends CombatHistoryEntry {
  const AbilityCastHistoryEntry({required super.tick, required this.combatantId, required this.affectedCombatantIds});
  final int combatantId;
  final List<int> affectedCombatantIds;

  static List<AbilityCastHistoryEntry> detectedIn(CombatStepComparison comparison) {
    final actorComparison = comparison.actorComparison;
    final isAbilityStep = comparison.step.kind == CombatHistoryStepKind.castAbility;
    if (actorComparison == null || !isAbilityStep) return const [];

    return [
      AbilityCastHistoryEntry(
        tick: comparison.tick,
        combatantId: actorComparison.after.id,
        affectedCombatantIds: List.unmodifiable(comparison.affectedCombatantIds),
      ),
    ];
  }
}
