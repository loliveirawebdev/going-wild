import '../battle.dart';
import '../../events/combat/battle_event.dart';
import '../unit/status_effect/status_effect.dart';
import '../unit/unit.dart';
import 'deal_damage.dart';
import 'heal.dart';

void advanceStatusesByOneTick(Battle battle, Unit unit) {
  final elapsedTickSeconds = battle.rules.tickSeconds;

  for (final statusEffect in unit.statusEffects.toList()) {
    if (!unit.isAlive) return;

    switch (statusEffect) {
      case DamageOverTimeStatusEffect():
        dealDamage(
          battle,
          sourceUnit: statusEffect.sourceUnit,
          targetUnit: unit,
          damageAmount: statusEffect.damagePerSecond * elapsedTickSeconds,
        );

        statusEffect.remainingSeconds -= elapsedTickSeconds;
        if (statusEffect.remainingSeconds <= 0) _removeExpiredStatusEffect(battle, unit, statusEffect);

      case HealOverTimeStatusEffect():
        heal(
          battle,
          sourceUnit: statusEffect.sourceUnit,
          targetUnit: unit,
          healAmount: statusEffect.healPerSecond * elapsedTickSeconds,
        );

        statusEffect.remainingSeconds -= elapsedTickSeconds;
        if (statusEffect.remainingSeconds <= 0) _removeExpiredStatusEffect(battle, unit, statusEffect);

      case StunStatusEffect():
        statusEffect.remainingSeconds -= elapsedTickSeconds;
        if (statusEffect.remainingSeconds <= 0) _removeExpiredStatusEffect(battle, unit, statusEffect);

      case TauntStatusEffect():
        statusEffect.remainingSeconds -= elapsedTickSeconds;
        final taunterIsGone = !statusEffect.sourceUnit.isTargetable;
        if (statusEffect.remainingSeconds <= 0 || taunterIsGone) _removeExpiredStatusEffect(battle, unit, statusEffect);

      case StatModifierStatusEffect():
        statusEffect.remainingSeconds -= elapsedTickSeconds;
        if (statusEffect.remainingSeconds <= 0) _removeExpiredStatusEffect(battle, unit, statusEffect);

      case ShieldStatusEffect():
        statusEffect.remainingSeconds -= elapsedTickSeconds;
        if (statusEffect.remainingSeconds <= 0) expireShield(battle, unit, statusEffect);

      case VanishedStatusEffect():
        statusEffect.remainingSeconds -= elapsedTickSeconds;

        if (statusEffect.remainingSeconds <= 0) {
          _removeExpiredStatusEffect(battle, unit, statusEffect);
          _reappearNextToUnit(battle, unit, statusEffect.reappearNextToUnit);
        }

      case NextHitsStatModifierStatusEffect():
        break;
    }
  }
}

void _removeExpiredStatusEffect(Battle battle, Unit unit, StatusEffect statusEffect) {
  unit.statusEffects.remove(statusEffect);
  battle.recordEvent(
    CharacterStatusEffectEnded(
      time: battle.elapsedSeconds,
      unitId: unit.id,
      statusEffectKind: statusEffect.statusEffectKind,
    ),
  );
}

void _reappearNextToUnit(Battle battle, Unit unit, Unit anchorUnit) {
  final anchorPosition = anchorUnit.isTargetable ? anchorUnit.position : unit.position;
  final freePosition = battle.pickRandomFreePositionClosestTo(anchorPosition);
  if (freePosition != null) {
    final previousPosition = unit.position;
    unit.position = freePosition;
    battle.recordEvent(
      CharacterMoved(time: battle.elapsedSeconds, unitId: unit.id, from: previousPosition, to: freePosition),
    );
  }
  if (!anchorUnit.isTargetable) return;

  unit.target = anchorUnit;
  battle.recordEvent(
    CharacterNewTargetAcquired(time: battle.elapsedSeconds, unitId: unit.id, targetUnitId: anchorUnit.id),
  );
}
