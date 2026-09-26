import '../../../../character/stars/star_values.dart';
import '../../../capabilities/add_combat_lasting_effect.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';
import 'shield_combat_lasting_effect.dart';

class ShieldEffect extends TargetedCombatEffect {
  const ShieldEffect({required super.target, required this.value, required this.seconds, this.onExpire = const []});
  final List<CombatEffect> onExpire;
  final StarValues seconds;
  final StarValues value;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final amount = value.at(application.stars);
    final durationTicks = context.convertSecondsToTicks(seconds.at(application.stars));

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final isAlreadyShielded = currentTargetCombatant.combatLastingEffects.any((effect) => effect is ShieldCombatLastingEffect);
      if (isAlreadyShielded) continue;

      final shield = ShieldCombatLastingEffect(
        remainingShield: amount,
        remainingTicks: durationTicks,
        onExpire: onExpire,
        sourceCombatantId: application.sourceCombatantId,
      );

      context = context.createCopyWithCombatant(addCombatLastingEffect(currentTargetCombatant, shield));
    }

    return context;
  }
}
