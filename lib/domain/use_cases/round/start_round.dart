import '../../models/match_progress/match_progress.dart';
import '../shop/refresh_shop_offers.dart';

class StartRound {
  const StartRound();

  MatchProgress call(MatchProgress matchProgress) {
    const refreshShopOffers = RefreshShopOffers();
    final engines = matchProgress.phase.engines;
    final levelEngine = engines.levelEngine;
    final waveReward = matchProgress.currentWave.coinsReward;
    final roundIncome = engines.economyEngine.roundIncome(player: matchProgress.player, waveReward: waveReward);

    final rewardedMatchProgress = matchProgress.createCopyWith(
      player: matchProgress.player.createCopyWithCoinsReceived(roundIncome),
      playerLevelProgress: levelEngine.gainExperience(matchProgress.playerLevelProgress, levelEngine.experiencePerRound),
    );

    if (rewardedMatchProgress.shop.isLocked) return rewardedMatchProgress;
    return refreshShopOffers(rewardedMatchProgress);
  }
}
