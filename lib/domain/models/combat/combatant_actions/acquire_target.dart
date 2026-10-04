import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
Combat acquireTarget(Combat combat, int combatantId) {
  final combatant = combat.battlefield.combatantWithId(combatantId);
  final currentTargetCombatantId = combatant.targetCombatantId;

  final forcedTargetCombatant = combatant.combatLastingEffects
      .map((combatLastingEffect) => combatLastingEffect.forcedTargetCombatantId)
      .nonNulls
      .map(combat.battlefield.combatantWithId)
      .where((forcedCombatant) => forcedCombatant.isTargetable)
      .lastOrNull;

  final currentTargetCombatant = currentTargetCombatantId == null ? null : combat.battlefield.combatantWithId(currentTargetCombatantId);
  final keepsCurrentTarget = forcedTargetCombatant == null && currentTargetCombatant != null && currentTargetCombatant.isTargetable;
  if (keepsCurrentTarget) return combat;

  final opposingFaction = combatant.faction.opposingFaction;
  final targetableEnemyCombatants = combat.battlefield.targetableCombatantsFromFaction(opposingFaction).toList();
  if (targetableEnemyCombatants.isEmpty) return combat;

  final newTargetCombatant = forcedTargetCombatant ?? _pickClosestEnemyBreakingTiesByLowestHealth(combatant, targetableEnemyCombatants);
  if (newTargetCombatant.id == currentTargetCombatantId) return combat;

  final combatantWithNewTarget = combatant.createCopyWith(targetCombatantId: newTargetCombatant.id);
  return combat.createCopyWithCombatant(combatantWithNewTarget);
}

Combatant _pickClosestEnemyBreakingTiesByLowestHealth(Combatant attackerCombatant, List<Combatant> enemyCombatants) {
  enemyCombatants.sort((firstEnemyCombatant, secondEnemyCombatant) {
    final firstDistance = firstEnemyCombatant.position.distanceToPosition(attackerCombatant.position);
    final secondDistance = secondEnemyCombatant.position.distanceToPosition(attackerCombatant.position);

    final distanceOrder = firstDistance.compareTo(secondDistance);
    if (distanceOrder != 0) return distanceOrder;

    final healthOrder = firstEnemyCombatant.currentHealth.compareTo(secondEnemyCombatant.currentHealth);
    if (healthOrder != 0) return healthOrder;

    return firstEnemyCombatant.id.compareTo(secondEnemyCombatant.id);
  });

  return enemyCombatants.first;
}
