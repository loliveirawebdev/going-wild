import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/combatant/capabilities/heal.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';

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
        sourceCombatantId: application.sourceCombatantId,
      );

      final targetAfterDamage = context.combatantWithId(targetCombatant.id);
      final damageDealt = targetHealthBefore - (targetAfterDamage.currentHealth + targetAfterDamage.currentShield);
      context = context.createCopyWithCombatant(heal(context.combatantWithId(application.sourceCombatantId), healAmount: damageDealt));
    }

    return context;
  }
}
