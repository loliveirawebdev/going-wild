import 'package:meta/meta.dart';

import '../combatant.dart';
import '../combat_effects/base/lasting/combat_lasting_effect.dart';

@useResult
Combatant addCombatLastingEffect(Combatant targetCombatant, CombatLastingEffect combatLastingEffect) {
  if (!targetCombatant.isAlive) return targetCombatant;
  return targetCombatant.createCopyWith(combatLastingEffects: [...targetCombatant.combatLastingEffects, combatLastingEffect]);
}
