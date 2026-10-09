import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/deal_damage.dart';
import 'package:going_wild/domain/models/combatant/capabilities/gain_mana.dart';
import 'package:meta/meta.dart';

@useResult
Combat attackTarget(Combat combat, int attackerCombatantId) {
  final attackerCombatant = combat.battlefield.combatantWithId(attackerCombatantId);
  final targetCombatantId = attackerCombatant.targetCombatantId;
  if (targetCombatantId == null) return combat;

  final attackerRange = attackerCombatant.getCurrentStat(Stat.range);
  final targetCombatant = combat.battlefield.combatantWithId(targetCombatantId);
  final isTargetInReach = attackerCombatant.position.canReach(targetCombatant.position, attackerRange);
  if (!targetCombatant.isTargetable || !isTargetInReach) return combat;

  final ticksUntilNextAttack = attackerCombatant.ticksUntilNextAttack - 1;
  final waitingAttackerCombatant = attackerCombatant.createCopyWith(ticksUntilNextAttack: ticksUntilNextAttack);
  final waitingCombat = combat.createCopyWithCombatant(waitingAttackerCombatant);
  if (ticksUntilNextAttack > 0) return waitingCombat;

  final damagedCombat = dealDamageToCombatant(
    waitingCombat,
    targetCombatantId: targetCombatantId,
    sourceCombatantId: attackerCombatantId,
    damageAmount: waitingAttackerCombatant.getCurrentStat(Stat.damage),
  );

  final manaPerHit = combat.rules.manaPerHit.toDouble();
  final attackerCombatantWithMana = gainMana(damagedCombat.battlefield.combatantWithId(attackerCombatantId), manaAmount: manaPerHit);

  final combatLastingEffectsAfterAttack = attackerCombatantWithMana.combatLastingEffects
      .map((combatLastingEffect) => combatLastingEffect.createCopyAfterAttackLanded())
      .nonNulls
      .toList();

  final landedAttackerCombatant = attackerCombatantWithMana.createCopyWith(combatLastingEffects: combatLastingEffectsAfterAttack);
  final ticksUntilAttackAfterLanding = combat.rules.ticksBetweenActions(landedAttackerCombatant.getCurrentStat(Stat.attackSpeed));
  final attackerCombatantAfterAttack = landedAttackerCombatant.createCopyWith(ticksUntilNextAttack: ticksUntilAttackAfterLanding);

  return damagedCombat.createCopyWithCombatant(attackerCombatantAfterAttack);
}
