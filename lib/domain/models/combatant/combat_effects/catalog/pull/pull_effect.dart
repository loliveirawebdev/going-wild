import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';

class PullEffect extends TargetedCombatEffect {
  const PullEffect({
    required super.target,
  });

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;

    for (final targetCombatant in application.targetsOf(target)) {
      final sourceCombatant = context.combatantWithId(application.sourceCombatantId);
      final landingPosition = context.pickRandomFreePositionClosestTo(sourceCombatant.position);

      if (landingPosition == null) continue;
      context = context.createCopyWithCombatantMovedTo(targetCombatant.id, landingPosition);
    }

    return context;
  }
}
