import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_context.dart';
import 'package:going_wild/domain/models/combatant/capabilities/take_damage.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:meta/meta.dart';

@useResult
Combat dealDamageToCombatant(
  Combat combat, {
  required int targetCombatantId,
  required double damageAmount,
  required int? sourceCombatantId,
}) {
  final targetBeforeDamage = combat.battlefield.combatantWithId(targetCombatantId);
  final damageTaken = takeDamage(targetBeforeDamage, damageAmount: damageAmount);
  final targetAfterDamage = damageTaken.damagedCombatant;

  CombatEffectContext damagedContext = CombatContext(combat: combat).createCopyWithCombatant(targetAfterDamage);

  for (final brokenCombatLastingEffect in damageTaken.brokenCombatLastingEffects) {
    damagedContext = brokenCombatLastingEffect.applyExpirationConsequences(damagedContext, targetCombatantId);
  }

  final healthLost = targetBeforeDamage.currentHealth - targetAfterDamage.currentHealth;
  final hasDied = targetBeforeDamage.isAlive && !targetAfterDamage.isAlive;

  if (healthLost > 0 && !hasDied) {
    for (final combatLastingEffect in targetAfterDamage.combatLastingEffects) {
      damagedContext = combatLastingEffect.reactToOwnerDamaged(
        damagedContext,
        healthLost: healthLost,
        ownerCombatantId: targetCombatantId,
        sourceCombatantId: sourceCombatantId,
      );
    }
  }

  if (hasDied) {
    damagedContext = _reactToDeath(
      damagedContext,
      killedCombatantId: targetCombatantId,
      killerCombatantId: sourceCombatantId,
      killedCombatantEffects: targetBeforeDamage.combatLastingEffects,
    );
  }

  return (damagedContext as CombatContext).combat;
}

CombatEffectContext _reactToDeath(
  CombatEffectContext context, {
  required int killedCombatantId,
  required int? killerCombatantId,
  required List<CombatLastingEffect> killedCombatantEffects,
}) {
  var reactedContext = context;

  for (final combatLastingEffect in killedCombatantEffects) {
    reactedContext = combatLastingEffect.reactToOwnerDeath(
      reactedContext,
      ownerCombatantId: killedCombatantId,
      killerCombatantId: killerCombatantId,
    );
  }

  if (killerCombatantId == null) return reactedContext;

  for (final combatLastingEffect in reactedContext.combatantWithId(killerCombatantId).combatLastingEffects) {
    reactedContext = combatLastingEffect.reactToOwnerKill(
      reactedContext,
      ownerCombatantId: killerCombatantId,
      killedCombatantId: killedCombatantId,
    );
  }

  return reactedContext;
}
