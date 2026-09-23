import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyStun(Battle battle, Unit casterUnit, Unit targetUnit, double durationSeconds) {
  final existingStunStatusEffect = targetUnit.statusEffects.whereType<StunStatusEffect>().firstOrNull;

  if (existingStunStatusEffect == null) {
    addStatusEffect(
      battle,
      targetUnit,
      StunStatusEffect(sourceUnit: casterUnit, remainingSeconds: durationSeconds),
    );

    return;
  }

  if (durationSeconds > existingStunStatusEffect.remainingSeconds) existingStunStatusEffect.remainingSeconds = durationSeconds;
}
