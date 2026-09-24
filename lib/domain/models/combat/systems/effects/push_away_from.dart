import '../../battle.dart';
import '../../../events/combat/battle_event.dart';
import '../../unit/unit.dart';

void pushAwayFrom(Battle battle, Unit pusherUnit, Unit targetUnit, int cells) {
  final rowDirection = (targetUnit.position.row - pusherUnit.position.row).sign;
  final columnDirection = (targetUnit.position.column - pusherUnit.position.column).sign;
  if (rowDirection == 0 && columnDirection == 0) return;

  var landingPosition = targetUnit.position;

  for (var step = 0; step < cells; step++) {
    final nextPosition = landingPosition.copyMovedBy(rows: rowDirection, columns: columnDirection);
    if (!battle.isPositionFree(nextPosition)) break;
    landingPosition = nextPosition;
  }

  if (landingPosition == targetUnit.position) return;

  final previousPosition = targetUnit.position;
  targetUnit.position = landingPosition;

  battle.recordEvent(
    CharacterMoved(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      from: previousPosition,
      to: landingPosition,
    ),
  );
}
