import '../../battle.dart';
import '../../events/battle_event.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyTaunt(Battle battle, Unit casterUnit, Unit targetUnit, double durationSeconds) {
  targetUnit.statusEffects.removeWhere((statusEffect) => statusEffect is TauntStatusEffect);
  addStatusEffect(battle, targetUnit, TauntStatusEffect(sourceUnit: casterUnit, remainingSeconds: durationSeconds));
  if (targetUnit.target == casterUnit) return;

  targetUnit.target = casterUnit;

  battle.recordEvent(
    CharacterNewTargetAcquired(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      targetUnitId: casterUnit.id,
    ),
  );
}
