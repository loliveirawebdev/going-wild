import '../../../models.dart';
import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyHealOverTime(Battle battle, Unit casterUnit, Unit targetUnit, HealEffect effect) {
  final healPerSecond = effect.healPerSecond.at(casterUnit.stars);
  final seconds = effect.seconds.at(casterUnit.stars);

  addStatusEffect(
    battle,
    targetUnit,
    HealOverTimeStatusEffect(sourceUnit: casterUnit, healPerSecond: healPerSecond, remainingSeconds: seconds),
  );
}
