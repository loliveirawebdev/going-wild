import '../../models/models.dart';
import '../battle.dart';
import '../events/battle_event.dart';
import '../unit/status_effect/status_effect.dart';
import '../unit/unit.dart';
import 'reduce_damage_by_armor.dart';

void dealDamage(Battle battle, {required Unit sourceUnit, required Unit targetUnit, required double damageAmount}) {
  if (!targetUnit.isAlive) return;

  final damageAfterArmor = reduceDamageByArmor(damageAmount, targetUnit.getCurrentStat(Stat.armor));
  var remainingDamage = damageAfterArmor * targetUnit.getCurrentStat(Stat.damageTakenPercentage);
  var absorbedByShields = 0.0;

  for (final shieldStatusEffect in targetUnit.statusEffects.whereType<ShieldStatusEffect>().toList()) {
    if (remainingDamage <= 0) break;

    final absorbedByShield = remainingDamage < shieldStatusEffect.remainingShield ? remainingDamage : shieldStatusEffect.remainingShield;
    shieldStatusEffect.remainingShield -= absorbedByShield;
    remainingDamage -= absorbedByShield;
    absorbedByShields += absorbedByShield;

    if (shieldStatusEffect.remainingShield <= 0) expireShield(battle, targetUnit, shieldStatusEffect);
  }

  targetUnit.currentHealth -= remainingDamage;

  battle.recordEvent(
    CharacterDamaged(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      sourceId: sourceUnit.id,
      amount: remainingDamage,
      absorbedByShield: absorbedByShields,
      remainingHealth: targetUnit.currentHealth < 0 ? 0 : targetUnit.currentHealth,
    ),
  );

  if (targetUnit.isAlive) return;

  targetUnit.currentHealth = 0;
  targetUnit.statusEffects.clear();
  battle.recordEvent(CharacterDied(time: battle.elapsedSeconds, unitId: targetUnit.id, killerUnitId: sourceUnit.id));
}

void expireShield(Battle battle, Unit ownerUnit, ShieldStatusEffect shieldStatusEffect) {
  ownerUnit.statusEffects.remove(shieldStatusEffect);

  battle.recordEvent(
    CharacterStatusEffectEnded(
      time: battle.elapsedSeconds,
      unitId: ownerUnit.id,
      statusEffectKind: shieldStatusEffect.statusEffectKind,
    ),
  );

  battle.deferredEffects.add((casterUnit: shieldStatusEffect.sourceUnit, effects: shieldStatusEffect.onExpire));
}
