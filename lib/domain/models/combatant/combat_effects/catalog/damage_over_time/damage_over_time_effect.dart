import '../../../../character/stars/star_values.dart';
import '../../../capabilities/add_combat_lasting_effect.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';
import 'damage_over_time_combat_lasting_effect.dart';

class DamageOverTimeEffect extends TargetedCombatEffect {
  const DamageOverTimeEffect({required super.target, required this.damagePerSecond, required this.seconds});

  final StarValues damagePerSecond;
  final StarValues seconds;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;

    for (final targetCombatant in application.targetsOf(target)) {
      context = context.createCopyWithCombatant(
        addCombatLastingEffect(
          context.combatantWithId(targetCombatant.id),

          DamageOverTimeCombatLastingEffect(
            sourceCombatantId: application.sourceCombatantId,
            remainingTicks: context.convertSecondsToTicks(seconds.at(application.stars)),
            damagePerSecond: damagePerSecond.at(application.stars),
          ),
        ),
      );
    }

    return context;
  }
}
