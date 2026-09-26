import '../../../../character/stars/star_values.dart';
import '../../../capabilities/heal.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';

class LifestealEffect extends TargetedCombatEffect {
  const LifestealEffect({required super.target, required this.value});
  final StarValues value;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;

    for (final targetCombatant in application.targetsOf(target)) {
      final targetBeforeDamage = context.combatantWithId(targetCombatant.id);
      final targetHealthBefore = targetBeforeDamage.currentHealth + targetBeforeDamage.currentShield;

      context = context.createCopyWithDamageDealt(
        targetCombatantId: targetCombatant.id,
        damageAmount: value.at(application.stars),
      );

      final targetAfterDamage = context.combatantWithId(targetCombatant.id);
      final damageDealt = targetHealthBefore - (targetAfterDamage.currentHealth + targetAfterDamage.currentShield);
      context = context.createCopyWithCombatant(heal(context.combatantWithId(application.sourceCombatantId), healAmount: damageDealt));
    }

    return context;
  }
}
