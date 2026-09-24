import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';

bool lockShop(PhaseRun phaseRun) {
  if (!phaseRun.isInProgress) return false;

  if (phaseRun.player.isShopLocked) return false;

  phaseRun.player.isShopLocked = true;
  phaseRun.recordEvent(ShopLocked(roundNumber: phaseRun.currentRoundNumber));
  return true;
}
