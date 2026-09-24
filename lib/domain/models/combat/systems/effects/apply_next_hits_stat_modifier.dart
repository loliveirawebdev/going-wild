import '../../../models.dart';
import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyNextHitsStatModifier(Battle battle, Unit casterUnit, Unit targetUnit, NextHitsStatBuffEffect effect) {
  targetUnit.statusEffects.removeWhere(
    (effect) => effect is NextHitsStatModifierStatusEffect && effect.stat == effect.stat && effect.sourceUnit == casterUnit,
  );

  final nextHitsStatModifierStatusEffect = NextHitsStatModifierStatusEffect(
    sourceUnit: casterUnit,
    stat: effect.stat,
    changeType: effect.changeType,
    value: effect.value.at(casterUnit.stars),
    remainingHits: effect.hits,
  );

  addStatusEffect(battle, targetUnit, nextHitsStatModifierStatusEffect);
}
