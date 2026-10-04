import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class LowestHealthAllyTarget extends CombatEffectTarget {
  const LowestHealthAllyTarget();

  @override
  bool get reachesEnemies => false;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) => _withLowestHealth(targeting.allyCombatants);
}

List<Combatant> _withLowestHealth(List<Combatant> candidateCombatants) {
  if (candidateCombatants.isEmpty) return [];

  final sortedCombatants = [...candidateCombatants]
    ..sort((firstCombatant, secondCombatant) {
      final healthOrder = firstCombatant.currentHealth.compareTo(secondCombatant.currentHealth);
      if (healthOrder != 0) return healthOrder;

      return firstCombatant.id.compareTo(secondCombatant.id);
    });

  return [sortedCombatants.first];
}
