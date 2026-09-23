import '../../../models/models.dart';
import '../../battle.dart';
import '../../unit/unit.dart';
import '../deal_damage.dart';
import '../heal.dart';

void applyLifesteal(Battle battle, Unit casterUnit, Unit targetUnit, LifestealEffect effect) {
  final targetHealthBefore = targetUnit.currentHealth + targetUnit.currentShield;
  dealDamage(battle, sourceUnit: casterUnit, targetUnit: targetUnit, damageAmount: effect.value.at(casterUnit.stars));
  final damageDealt = targetHealthBefore - (targetUnit.currentHealth + targetUnit.currentShield);
  heal(battle, sourceUnit: casterUnit, targetUnit: casterUnit, healAmount: damageDealt);
}
