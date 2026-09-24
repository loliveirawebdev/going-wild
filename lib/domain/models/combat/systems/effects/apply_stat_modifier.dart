import '../../../models.dart';
import '../../battle.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyStatModifier(
  Battle battle,
  Unit casterUnit,
  Unit targetUnit, {
  required Stat stat,
  required StatChangeType changeType,
  required StarValues value,
  required StarValues seconds,
}) {
  final casterAbilityId = casterUnit.character.ability.id;

  final existingStatModifierStatusEffect = targetUnit.statusEffects
      .whereType<StatModifierStatusEffect>()
      .where((modifier) => modifier.stat == stat && modifier.sourceUnit.character.ability.id == casterAbilityId)
      .firstOrNull;

  if (existingStatModifierStatusEffect != null) {
    existingStatModifierStatusEffect.remainingSeconds = seconds.at(casterUnit.stars);
    return;
  }

  final statModifierStatusEffect = StatModifierStatusEffect(
    sourceUnit: casterUnit,
    stat: stat,
    changeType: changeType,
    value: value.at(casterUnit.stars),
    remainingSeconds: seconds.at(casterUnit.stars),
  );

  addStatusEffect(battle, targetUnit, statModifierStatusEffect);
}
