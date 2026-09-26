import 'package:meta/meta.dart';

import '../../base/applying/combat_effect_application.dart';
import '../../base/combat_effect_context.dart';
import '../../base/targeted_combat_effect.dart';

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
    final rowDirection = (targetCombatant.position.row - pusherCombatant.position.row).sign;
    final columnDirection = (targetCombatant.position.column - pusherCombatant.position.column).sign;
    if (rowDirection == 0 && columnDirection == 0) return context;

    var landingPosition = targetCombatant.position;

    for (var step = 0; step < cells; step++) {
      final nextPosition = landingPosition.createCopyMovedBy(rows: rowDirection, columns: columnDirection);
      if (!context.isPositionFree(nextPosition)) break;
      landingPosition = nextPosition;
    }

    if (landingPosition == targetCombatant.position) return context;
    return context.createCopyWithCombatantMovedTo(targetCombatantId, landingPosition);
  }
}
