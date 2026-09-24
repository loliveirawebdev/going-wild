import '../../../models.dart';
import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyDamageOverTime(Battle battle, Unit casterUnit, Unit targetUnit, DamageOverTimeEffect effect) {
  final damagePerSecond = effect.damagePerSecond.at(casterUnit.stars);
  final seconds = effect.seconds.at(casterUnit.stars);

  addStatusEffect(
    battle,
    targetUnit,
    DamageOverTimeStatusEffect(sourceUnit: casterUnit, damagePerSecond: damagePerSecond, remainingSeconds: seconds),
  );
}
