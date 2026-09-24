import '../../battle.dart';
import '../../../events/combat/battle_event.dart';
import '../../unit/unit.dart';

void pullNextTo(Battle battle, Unit pullerUnit, Unit targetUnit) {
  final landingPosition = battle.pickRandomFreePositionClosestTo(pullerUnit.position);
  if (landingPosition == null) return;

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
