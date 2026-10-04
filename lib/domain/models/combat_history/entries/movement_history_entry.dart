part of 'combat_history_entry.dart';

class MovementHistoryEntry extends CombatConsequenceHistoryEntry {
  const MovementHistoryEntry({
    required super.tick,
    required super.cause,
    required this.toPosition,
    required super.combatantId,
    required this.fromPosition,
    required this.sourceCombatantId,
  });

  final Position toPosition;
  final Position fromPosition;
  final int sourceCombatantId;

  static List<MovementHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    if (comparison.hasMoved)
      MovementHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        toPosition: comparison.after.position,
        fromPosition: comparison.before.position,
        sourceCombatantId: comparison.step.actorCombatantId,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWith(position: toPosition);
}
