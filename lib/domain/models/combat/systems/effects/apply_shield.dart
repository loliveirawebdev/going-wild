import '../../../models.dart';
import '../../battle.dart';
import '../../../events/combat/battle_event.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';
import 'add_status_effect.dart';

void applyShield(Battle battle, Unit casterUnit, Unit targetUnit, ShieldEffect effect) {
  final amount = effect.value.at(casterUnit.stars);
  final seconds = effect.seconds.at(casterUnit.stars);

  final shieldStatusEffect = ShieldStatusEffect(
    sourceUnit: casterUnit,
    remainingShield: amount,
    remainingSeconds: seconds,
    onExpire: effect.onExpire,
  );

  addStatusEffect(battle, targetUnit, shieldStatusEffect);

  battle.recordEvent(
    CharacterReceivedShield(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      sourceUnitId: casterUnit.id,
      amount: amount,
    ),
  );
}
