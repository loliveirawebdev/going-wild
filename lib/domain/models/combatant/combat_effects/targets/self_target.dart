import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

class SelfTarget extends CombatEffectTarget {
  const SelfTarget();

  @override
  bool get reachesEnemies => false;

  @override
  List<Combatant> resolve(CombatEffectTargeting targeting) => [targeting.sourceCombatant];
}
