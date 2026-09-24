import '../../models.dart';
import '../battle.dart';
import '../events/battle_event.dart';
import '../unit/status_effect/status_effect.dart';
import '../unit/unit.dart';
import 'deal_damage.dart';
import 'gain_mana.dart';
import 'is_target_in_range.dart';

void attackTarget(Battle battle, Unit attackerUnit) {
  final targetUnit = attackerUnit.target;
  if (targetUnit == null || !isTargetInRange(attackerUnit, targetUnit)) return;

  attackerUnit.secondsUntilNextAttack -= battle.rules.tickSeconds;
  if (attackerUnit.secondsUntilNextAttack > 0) return;

  battle.recordEvent(
    CharacterAttackLanded(
      time: battle.elapsedSeconds,
      unitId: attackerUnit.id,
      targetUnitId: targetUnit.id,
    ),
  );

  dealDamage(
    battle,
    sourceUnit: attackerUnit,
    targetUnit: targetUnit,
    damageAmount: attackerUnit.getCurrentStat(Stat.damage),
  );

  gainMana(
    battle,
    attackerUnit,
    battle.rules.manaPerHit.toDouble(),
  );

  _consumeOneHitFromNextHitsModifiers(attackerUnit);
  attackerUnit.secondsUntilNextAttack = 1 / attackerUnit.getCurrentStat(Stat.attackSpeed);
}

void _consumeOneHitFromNextHitsModifiers(Unit attackerUnit) {
  for (final modifier in attackerUnit.statusEffects.whereType<NextHitsStatModifierStatusEffect>().toList()) {
    modifier.remainingHits -= 1;
    if (modifier.remainingHits <= 0) attackerUnit.statusEffects.remove(modifier);
  }
}
