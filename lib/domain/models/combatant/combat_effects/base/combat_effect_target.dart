import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_targeting.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

abstract class CombatEffectTarget {
  const CombatEffectTarget();

  bool get reachesEnemies;
  bool get reachesSeveralEnemies => false;

  List<Combatant> resolve(CombatEffectTargeting targeting);
}
