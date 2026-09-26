import 'package:meta/meta.dart';

import '../../combatant/capabilities/take_damage.dart';
import '../../combatant/combat_effects/base/combat_effect_context.dart';
import '../combat.dart';
import '../combat_context.dart';

@useResult
Combat dealDamageToCombatant(Combat combat, {required int targetCombatantId, required double damageAmount}) {
  final targetCombatant = combat.battlefield.combatantWithId(targetCombatantId);
  final damageTaken = takeDamage(targetCombatant, damageAmount: damageAmount);

  CombatEffectContext damagedContext = CombatContext(combat: combat).createCopyWithCombatant(damageTaken.damagedCombatant);

  for (final brokenCombatLastingEffect in damageTaken.brokenCombatLastingEffects) {
    damagedContext = brokenCombatLastingEffect.applyExpirationConsequences(damagedContext, targetCombatantId);
  }

  return (damagedContext as CombatContext).combat;
}
