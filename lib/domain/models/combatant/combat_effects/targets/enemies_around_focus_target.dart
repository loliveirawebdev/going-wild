import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class EnemiesAroundFocusTarget extends CombatEffectTarget {
  const EnemiesAroundFocusTarget();

  @override
  bool get reachesEnemies => true;

  @override
  bool get reachesSeveralEnemies => true;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) {
    final focusCombatant = targeting.focusCombatant;
    if (focusCombatant == null) return [];

    return targeting.combatantsNear(focusCombatant, targeting.enemyCombatants);
  }
}
