import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/combatant/capabilities/add_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';

class StunEffect extends TargetedCombatEffect {
  const StunEffect({required super.target, required this.seconds});
  final StarValues seconds;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final durationTicks = context.convertSecondsToTicks(seconds.at(application.stars));

    for (final targetCombatant in application.targetsOf(target)) {
      final currentTargetCombatant = context.combatantWithId(targetCombatant.id);
      final isAlreadyStunned = currentTargetCombatant.combatLastingEffects.any((effect) => effect is StunCombatLastingEffect);
      if (isAlreadyStunned) continue;

      final stun = StunCombatLastingEffect(remainingTicks: durationTicks, sourceCombatantId: application.sourceCombatantId);
      context = context.createCopyWithCombatant(addCombatLastingEffect(currentTargetCombatant, stun));
    }

    return context;
  }
}
