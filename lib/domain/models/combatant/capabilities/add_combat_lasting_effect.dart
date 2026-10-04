import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:meta/meta.dart';

@useResult
Combatant addCombatLastingEffect(Combatant targetCombatant, CombatLastingEffect combatLastingEffect) {
  if (!targetCombatant.isAlive) return targetCombatant;
  return targetCombatant.createCopyWith(combatLastingEffects: [...targetCombatant.combatLastingEffects, combatLastingEffect]);
}
