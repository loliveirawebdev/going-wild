import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class NearbyEnemiesTarget extends CombatEffectTarget {
  const NearbyEnemiesTarget();

  @override
  bool get reachesEnemies => true;

  @override
  bool get reachesSeveralEnemies => true;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) =>
      targeting.combatantsNear(targeting.sourceCombatant, targeting.enemyCombatants);
}
