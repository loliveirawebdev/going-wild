import '../battle.dart';
import '../../events/combat/battle_event.dart';
import '../unit/unit.dart';

void heal(Battle battle, {required Unit sourceUnit, required Unit targetUnit, required double healAmount}) {
  if (!targetUnit.isAlive || healAmount <= 0) return;

  final healthBefore = targetUnit.currentHealth;
  targetUnit.currentHealth = (targetUnit.currentHealth + healAmount).clamp(0, targetUnit.stats.health);

  battle.recordEvent(
    CharacterReceivedHeal(
      time: battle.elapsedSeconds,
      unitId: targetUnit.id,
      sourceUnitId: sourceUnit.id,
      amount: targetUnit.currentHealth - healthBefore,
      healthAfterHeal: targetUnit.currentHealth,
    ),
  );
}
