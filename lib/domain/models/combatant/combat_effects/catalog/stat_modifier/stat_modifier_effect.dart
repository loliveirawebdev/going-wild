import '../../../../character/stars/star_values.dart';
import '../../../../character/stats/stat.dart';
import '../../../../character/stats/stat_change_type.dart';
import '../../../../character/stats/stat_modification.dart';
import '../../../capabilities/add_combat_lasting_effect.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';
import 'stat_modifier_combat_lasting_effect.dart';

class StatModifierEffect extends TargetedCombatEffect {
  const StatModifierEffect({
    required this.stat,
    required this.value,
    required super.target,
    required this.seconds,
    required this.changeType,
  });

  final Stat stat;
  final StarValues value;
  final StarValues seconds;
  final StatChangeType changeType;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final statModification = StatModification(stat: stat, value: value.at(application.stars), changeType: changeType);

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final hasSameStatModification = currentTargetCombatant.combatLastingEffects.whereType<StatModifierCombatLastingEffect>().any(
        (existingStatModifier) => existingStatModifier.statModification == statModification,
      );
      if (hasSameStatModification) continue;

      final statModifier = StatModifierCombatLastingEffect(
        statModification: statModification,
        remainingTicks: context.convertSecondsToTicks(seconds.at(application.stars)),
        sourceCombatantId: application.sourceCombatantId,
      );

      context = context.createCopyWithCombatant(addCombatLastingEffect(currentTargetCombatant, statModifier));
    }

    return context;
  }
}
