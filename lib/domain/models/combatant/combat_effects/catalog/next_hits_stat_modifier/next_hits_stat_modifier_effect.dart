import '../../../../character/stars/star_values.dart';
import '../../../../character/stats/stat.dart';
import '../../../../character/stats/stat_change_type.dart';
import '../../../../character/stats/stat_modification.dart';
import '../../../capabilities/add_combat_lasting_effect.dart';
import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';
import 'next_hits_stat_modifier_combat_lasting_effect.dart';

class NextHitsStatModifierEffect extends TargetedCombatEffect {
  const NextHitsStatModifierEffect({
    required this.stat,
    required this.hits,
    required this.value,
    required super.target,
    required this.changeType,
  });

  final int hits;
  final Stat stat;
  final StarValues value;
  final StatChangeType changeType;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final statModification = StatModification(stat: stat, value: value.at(application.stars), changeType: changeType);

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final hasSameStatModification = currentTargetCombatant.combatLastingEffects.whereType<NextHitsStatModifierCombatLastingEffect>().any(
        (existingNextHitsStatModifier) => existingNextHitsStatModifier.statModification == statModification,
      );
      if (hasSameStatModification) continue;

      final nextHitsStatModifier = NextHitsStatModifierCombatLastingEffect(
        remainingHits: hits,
        statModification: statModification,
        sourceCombatantId: application.sourceCombatantId,
      );

      context = context.createCopyWithCombatant(addCombatLastingEffect(currentTargetCombatant, nextHitsStatModifier));
    }

    return context;
  }
}
