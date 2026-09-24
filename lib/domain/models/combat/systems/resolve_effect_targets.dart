import '../../models.dart';
import '../battle.dart';
import '../unit/unit.dart';

List<Unit> resolveEffectTargets(Battle battle, Unit casterUnit, EffectTarget effectTarget) {
  final allyUnits = battle.aliveUnitsFromFaction(casterUnit.faction).toList();
  final enemyUnits = battle.targetableUnitsFromFaction(casterUnit.faction.opposingFaction).toList();
  final radius = battle.rules.nearbyRadius;
  final focusUnit = casterUnit.target;
  final hasFocus = focusUnit != null && focusUnit.isTargetable;
  bool isNear(Unit unit, Unit centerUnit) => unit.position.distanceToPosition(centerUnit.position) <= radius;

  return switch (effectTarget) {
    EffectTarget.self => [casterUnit],
    EffectTarget.focus => hasFocus ? [focusUnit] : [],
    EffectTarget.lowestHealthAlly => _unitWithLowestHealth(allyUnits),
    EffectTarget.lowestHealthEnemy => _unitWithLowestHealth(enemyUnits),
    EffectTarget.farthestEnemy => _unitFarthestFrom(casterUnit, enemyUnits),
    EffectTarget.nearbyAllies => allyUnits.where((allyUnit) => isNear(allyUnit, casterUnit)).toList(),
    EffectTarget.nearbyEnemies => enemyUnits.where((enemyUnit) => isNear(enemyUnit, casterUnit)).toList(),
    EffectTarget.enemiesAroundFocus => hasFocus ? enemyUnits.where((enemyUnit) => isNear(enemyUnit, focusUnit)).toList() : [],
    EffectTarget.allEnemies => enemyUnits,
  };
}

List<Unit> _unitWithLowestHealth(List<Unit> units) {
  if (units.isEmpty) return [];
  units.sort((firstUnit, secondUnit) => firstUnit.currentHealth.compareTo(secondUnit.currentHealth));
  return [units.first];
}

List<Unit> _unitFarthestFrom(Unit casterUnit, List<Unit> units) {
  if (units.isEmpty) return [];

  units.sort((firstUnit, secondUnit) {
    final firstDistance = firstUnit.position.distanceToPosition(casterUnit.position);
    final secondDistance = secondUnit.position.distanceToPosition(casterUnit.position);
    return secondDistance.compareTo(firstDistance);
  });

  return [units.first];
}
