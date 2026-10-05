import 'package:going_wild/domain/models/combatant/combat_effects/base/applying/combat_effect_application.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_context.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:meta/meta.dart';

class KnockbackEffect extends TargetedCombatEffect {
  const KnockbackEffect({required super.target, required this.cells});
  final int cells;

  @override
  CombatEffectContext apply(CombatEffectApplication application) {
    var context = application.context;
    final pusherPosition = application.sourceCombatant.position;

    final targetCombatantsFarthestFirst = [...application.targetsOf(target)]
      ..sort((firstTarget, secondTarget) {
        final firstDistance = firstTarget.position.distanceToPosition(pusherPosition);
        final secondDistance = secondTarget.position.distanceToPosition(pusherPosition);

        final distanceOrder = secondDistance.compareTo(firstDistance);
        if (distanceOrder != 0) return distanceOrder;

        return firstTarget.id.compareTo(secondTarget.id);
      });

    for (final targetCombatant in targetCombatantsFarthestFirst) {
      context = _pushAwayFrom(
        context: context,
        cells: cells,
        targetCombatantId: targetCombatant.id,
        pusherCombatantId: application.sourceCombatantId,
      );
    }

    return context;
  }

  @useResult
  CombatEffectContext _pushAwayFrom({
    required CombatEffectContext context,
    required int pusherCombatantId,
    required int targetCombatantId,
    required int cells,
  }) {
    final pusherCombatant = context.combatantWithId(pusherCombatantId);
    final targetCombatant = context.combatantWithId(targetCombatantId);
    if (targetCombatant.position == pusherCombatant.position) return context;

    var landingPosition = targetCombatant.position;

    for (var step = 1; step <= cells; step++) {
      final nextPosition = targetCombatant.position.positionAwayFrom(pusherCombatant.position, steps: step);
      if (!context.isPositionFree(nextPosition)) break;
      landingPosition = nextPosition;
    }

    if (landingPosition == targetCombatant.position) return context;
    return context.createCopyWithCombatantMovedTo(targetCombatantId, landingPosition);
  }
}
