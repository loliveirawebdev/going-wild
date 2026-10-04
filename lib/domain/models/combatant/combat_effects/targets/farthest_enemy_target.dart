import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class FarthestEnemyTarget extends CombatEffectTarget {
  const FarthestEnemyTarget();

  @override
  bool get reachesEnemies => true;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) {
    final enemyCombatants = targeting.enemyCombatants;
    if (enemyCombatants.isEmpty) return [];

    final sourcePosition = targeting.sourceCombatant.position;
    final sortedCombatants = [...enemyCombatants]
      ..sort((firstCombatant, secondCombatant) {
        final firstDistance = firstCombatant.position.distanceToPosition(sourcePosition);
        final secondDistance = secondCombatant.position.distanceToPosition(sourcePosition);

        final distanceOrder = secondDistance.compareTo(firstDistance);
        if (distanceOrder != 0) return distanceOrder;

        return firstCombatant.id.compareTo(secondCombatant.id);
      });

    return [sortedCombatants.first];
  }
}
