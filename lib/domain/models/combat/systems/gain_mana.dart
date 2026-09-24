import '../../models.dart';
import '../battle.dart';
import '../events/battle_event.dart';
import '../unit/unit.dart';

void gainMana(Battle battle, Unit unit, double manaAmount) {
  final manaMax = unit.getCurrentStat(Stat.manaMax);
  if (unit.currentMana >= manaMax || manaAmount <= 0) return;

  unit.currentMana = (unit.currentMana + manaAmount).clamp(0, manaMax);

  battle.recordEvent(
    CharacterReceivedMana(
      time: battle.elapsedSeconds,
      unitId: unit.id,
      amount: manaAmount,
      manaAfterReceived: unit.currentMana,
    ),
  );
}
