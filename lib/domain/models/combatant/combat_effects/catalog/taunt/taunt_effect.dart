import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/combatant/capabilities/add_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';

class TauntEffect extends TargetedCombatEffect {
  const TauntEffect({required super.target, required this.seconds});
  final StarValues seconds;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final sourceCombatantId = application.sourceCombatantId;
    final durationTicks = context.convertSecondsToTicks(seconds.at(application.stars));

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final isAlreadyTaunted = currentTargetCombatant.combatLastingEffects.any((effect) => effect is TauntCombatLastingEffect);
      if (isAlreadyTaunted) continue;

      final taunt = TauntCombatLastingEffect(remainingTicks: durationTicks, sourceCombatantId: sourceCombatantId);
      final tauntedTarget = addCombatLastingEffect(currentTargetCombatant, taunt);
      context = context.createCopyWithCombatant(tauntedTarget.createCopyWith(targetCombatantId: sourceCombatantId));
    }

    return context;
  }
}
