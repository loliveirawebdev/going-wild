part of 'combat_history_entry.dart';

class AttackLandedHistoryEntry extends CombatHistoryEntry {
  const AttackLandedHistoryEntry({required super.tick, required this.combatantId, required this.targetCombatantId});
  final int combatantId;
  final int targetCombatantId;

  static List<AttackLandedHistoryEntry> detectedIn(CombatStepComparison comparison) {
    final actorComparison = comparison.actorComparison;
    final isAttackStep = comparison.step.kind == CombatHistoryStepKind.attackTarget;
    if (actorComparison == null || !isAttackStep) return const [];

    final actorAfter = actorComparison.after;
    final actorBefore = actorComparison.before;
    final targetCombatantId = actorBefore.targetCombatantId;
    final ticksUntilNextAttackWhileWaiting = actorBefore.ticksUntilNextAttack - 1;
    final hasAttackTimerChanged = actorAfter.ticksUntilNextAttack != actorBefore.ticksUntilNextAttack;
    final hasAttackTimerRestarted = hasAttackTimerChanged && actorAfter.ticksUntilNextAttack != ticksUntilNextAttackWhileWaiting;
    if (!hasAttackTimerRestarted || targetCombatantId == null) return const [];

    return [AttackLandedHistoryEntry(tick: comparison.tick, combatantId: actorAfter.id, targetCombatantId: targetCombatantId)];
  }
}
