part of 'combat_history_entry.dart';

class TargetAcquiredHistoryEntry extends CombatConsequenceHistoryEntry {
  const TargetAcquiredHistoryEntry({
    required super.tick,
    required super.cause,
    required super.combatantId,
    required this.targetCombatantId,
  });
  final int targetCombatantId;

  static List<TargetAcquiredHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.acquiredTargetCombatantId case final targetCombatantId?)
      TargetAcquiredHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        targetCombatantId: targetCombatantId,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWith(targetCombatantId: targetCombatantId);
}
