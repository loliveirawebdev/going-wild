import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';

bool unlockShop(PhaseRun phaseRun) {
  if (!phaseRun.isInProgress) return false;

  if (!phaseRun.player.isShopLocked) return false;

  phaseRun.player.isShopLocked = false;
  phaseRun.recordEvent(ShopUnlocked(roundNumber: phaseRun.currentRoundNumber));
  return true;
}
