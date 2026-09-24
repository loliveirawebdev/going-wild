import '../battle.dart';
import '../../events/combat/battle_event.dart';
import '../unit/status_effect/status_effect.dart';
import '../unit/unit.dart';

void acquireTarget(Battle battle, Unit unit) {
  final activeTauntStatusEffect = unit.statusEffects
      .whereType<TauntStatusEffect>()
      .where((taunt) => taunt.sourceUnit.isTargetable)
      .lastOrNull;

  final taunterUnit = activeTauntStatusEffect?.sourceUnit;
  final currentTargetUnit = unit.target;
  final keepsCurrentTarget = taunterUnit == null && currentTargetUnit != null && currentTargetUnit.isTargetable;
  if (keepsCurrentTarget) return;

  final targetableEnemyUnits = battle.targetableUnitsFromFaction(unit.faction.opposingFaction).toList();

  if (targetableEnemyUnits.isEmpty) {
    unit.target = null;
    return;
  }

  final newTargetUnit = taunterUnit ?? _pickClosestEnemyBreakingTiesByLowestHealth(unit, targetableEnemyUnits);
  if (newTargetUnit == currentTargetUnit) return;

  unit.target = newTargetUnit;

  battle.recordEvent(
    CharacterNewTargetAcquired(
      time: battle.elapsedSeconds,
      unitId: unit.id,
      targetUnitId: newTargetUnit.id,
    ),
  );
}

Unit _pickClosestEnemyBreakingTiesByLowestHealth(Unit attackerUnit, List<Unit> enemyUnits) {
  enemyUnits.sort((firstEnemyUnit, secondEnemyUnit) {
    final firstDistance = firstEnemyUnit.position.distanceToPosition(attackerUnit.position);
    final secondDistance = secondEnemyUnit.position.distanceToPosition(attackerUnit.position);
    final distanceOrder = firstDistance.compareTo(secondDistance);
    if (distanceOrder != 0) return distanceOrder;

    final healthOrder = firstEnemyUnit.currentHealth.compareTo(secondEnemyUnit.currentHealth);
    if (healthOrder != 0) return healthOrder;

    return firstEnemyUnit.id.compareTo(secondEnemyUnit.id);
  });

  return enemyUnits.first;
}
