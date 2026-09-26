import '../../../../character/stars/star_values.dart';
import '../../../capabilities/add_combat_lasting_effect.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';
import 'heal_over_time_combat_lasting_effect.dart';

class HealOverTimeEffect extends TargetedCombatEffect {
  const HealOverTimeEffect({required super.target, required this.healPerSecond, required this.seconds});
  final StarValues healPerSecond;
  final StarValues seconds;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final isAlreadyHealing = currentTargetCombatant.combatLastingEffects.any((effect) => effect is HealOverTimeCombatLastingEffect);
      if (isAlreadyHealing) continue;

      final healOverTime = HealOverTimeCombatLastingEffect(
        sourceCombatantId: application.sourceCombatantId,
        remainingTicks: context.convertSecondsToTicks(seconds.at(application.stars)),
        healPerSecond: healPerSecond.at(application.stars),
      );

      context = context.createCopyWithCombatant(addCombatLastingEffect(currentTargetCombatant, healOverTime));
    }

    return context;
  }
}
