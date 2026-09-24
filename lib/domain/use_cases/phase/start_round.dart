import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/player/level/gain_experience.dart';
import '../../models/shop/refresh_shop_offers.dart';

void startRound(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final rules = phaseRun.rules.shopRules;
  final coinsReward = phaseRun.currentEnemyWave.coinsReward;
  final roundNumber = phaseRun.currentRoundNumber;

  phaseRun.recordEvent(RoundStarted(roundNumber: roundNumber));

  player.coins += coinsReward;
  phaseRun.recordEvent(PlayerReceivedCoins(roundNumber: roundNumber, amount: coinsReward, coinsAfterReceived: player.coins));

  gainExperience(phaseRun, rules.experiencePerRound);
  if (!player.isShopLocked) refreshShopOffers(phaseRun);
}
