import '../../battle.dart';
import '../../events/battle_event.dart';
import '../../unit/status_effect/status_effect.dart';
import '../../unit/unit.dart';

void addStatusEffect(Battle battle, Unit targetUnit, StatusEffect statusEffect) {
  if (!targetUnit.isAlive) return;
  targetUnit.statusEffects.add(statusEffect);

  battle.recordEvent(
    CharacterStatusEffectStarted(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      sourceUnitId: statusEffect.sourceUnit.id,
      statusEffectKind: statusEffect.statusEffectKind,
    ),
  );
}
