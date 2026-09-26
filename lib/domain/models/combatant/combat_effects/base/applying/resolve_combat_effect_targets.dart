import '../combat_effect_context.dart';
import '../../../combatant.dart';
import '../combat_effect_target.dart';

List<Combatant> resolveCombatEffectTargets(CombatEffectContext context, Combatant sourceCombatant, CombatEffectTarget effectTarget) {
  final radius = context.nearbyRadius;
  final focusCombatantId = sourceCombatant.targetCombatantId;
  final allyCombatants = context.aliveCombatantsFromFaction(sourceCombatant.faction).toList();
  final enemyCombatants = context.targetableCombatantsFromFaction(sourceCombatant.faction.opposingFaction).toList();

  final focusCombatant = focusCombatantId == null ? null : context.combatantWithId(focusCombatantId);
  final hasFocus = focusCombatant != null && focusCombatant.isTargetable;

  bool Function(Combatant combatant) filterNearCombatant(Combatant centerCombatant) {
    return (Combatant combatant) => _isNear(
      combatant,
      centerCombatant,
      radius,
    );
  }

  return switch (effectTarget) {
    CombatEffectTarget.self => [sourceCombatant],
    CombatEffectTarget.allEnemies => enemyCombatants,
    CombatEffectTarget.focus => hasFocus ? [focusCombatant] : [],
    CombatEffectTarget.lowestHealthAlly => _combatantWithLowestHealth(allyCombatants),
    CombatEffectTarget.lowestHealthEnemy => _combatantWithLowestHealth(enemyCombatants),
    CombatEffectTarget.farthestEnemy => _combatantFarthestFrom(sourceCombatant, enemyCombatants),
    CombatEffectTarget.nearbyAllies => allyCombatants.where(filterNearCombatant(sourceCombatant)).toList(),
    CombatEffectTarget.nearbyEnemies => enemyCombatants.where(filterNearCombatant(sourceCombatant)).toList(),
    CombatEffectTarget.enemiesAroundFocus => hasFocus ? enemyCombatants.where(filterNearCombatant(focusCombatant)).toList() : [],
  };
}

bool _isNear(Combatant combatant, Combatant centerCombatant, int radius) {
  final distanceBetweenCombatantAndCenterCombatant = combatant.position.distanceToPosition(centerCombatant.position);
  return distanceBetweenCombatantAndCenterCombatant <= radius;
}

List<Combatant> _combatantWithLowestHealth(List<Combatant> combatants) {
  if (combatants.isEmpty) return [];

  combatants.sort((firstCombatant, secondCombatant) {
    final healthOrder = firstCombatant.currentHealth.compareTo(secondCombatant.currentHealth);
    if (healthOrder != 0) return healthOrder;

    return firstCombatant.id.compareTo(secondCombatant.id);
  });

  return [combatants.first];
}

List<Combatant> _combatantFarthestFrom(Combatant sourceCombatant, List<Combatant> combatants) {
  if (combatants.isEmpty) return [];

  combatants.sort((firstCombatant, secondCombatant) {
    final firstDistance = firstCombatant.position.distanceToPosition(sourceCombatant.position);
    final secondDistance = secondCombatant.position.distanceToPosition(sourceCombatant.position);

    final distanceOrder = secondDistance.compareTo(firstDistance);
    if (distanceOrder != 0) return distanceOrder;

    return firstCombatant.id.compareTo(secondCombatant.id);
  });

  return [combatants.first];
}
