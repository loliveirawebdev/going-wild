import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:meta/meta.dart';

@useResult
Combat advanceCombatLastingEffectsByOneTick(Combat combat, int combatantId) {
  final combatContext = CombatContext(combat: combat);
  final combatant = combat.battlefield.combatantWithId(combatantId);
  final combatLastingEffectsBeforeTick = combatant.combatLastingEffects;

  final combatLastingEffectsAfterTick = [
    for (final combatLastingEffect in combatLastingEffectsBeforeTick)
      combatLastingEffect.expiresEarly(combatContext) ? null : combatLastingEffect.createCopyAfterOneTick(),
  ];

  final combatantAfterTick = combatant.createCopyWith(combatLastingEffects: combatLastingEffectsAfterTick.nonNulls.toList());
  CombatEffectContext advancedContext = combatContext.createCopyWithCombatant(combatantAfterTick);

  for (var index = 0; index < combatLastingEffectsBeforeTick.length; index++) {
    final isCombatantDead = !advancedContext.combatantWithId(combatantId).isAlive;
    if (isCombatantDead) break;

    final combatLastingEffect = combatLastingEffectsBeforeTick[index];
    advancedContext = combatLastingEffect.applyTickConsequences(advancedContext, combatantId);

    final hasExpired = combatLastingEffectsAfterTick[index] == null;
    if (hasExpired) advancedContext = combatLastingEffect.applyExpirationConsequences(advancedContext, combatantId);
  }

  return (advancedContext as CombatContext).combat;
}
