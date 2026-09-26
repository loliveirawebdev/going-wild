import '../../../../character/stars/star_values.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';

class DamageEffect extends TargetedCombatEffect {
  const DamageEffect({required super.target, required this.value});
  final StarValues value;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;

    for (final targetCombatant in application.targetsOf(target)) {
      context = context.createCopyWithDamageDealt(
        targetCombatantId: targetCombatant.id,
        damageAmount: value.at(application.stars),
      );
    }

    return context;
  }
}
