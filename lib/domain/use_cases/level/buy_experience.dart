import '../../models/level/errors/max_level_reached_error.dart';
import '../../models/match_progress/match_progress.dart';
import '../../models/player/errors/not_enough_coins_error.dart';

class BuyExperience {
  const BuyExperience();

  MatchProgress call(MatchProgress matchProgress) {
    matchProgress.requireInProgress();
    final engines = matchProgress.phase.engines;
    final levelEngine = engines.levelEngine;
    final economyEngine = engines.economyEngine;

    final player = matchProgress.player;
    final cost = economyEngine.experiencePurchaseCostInCoins;
    if (!player.canAfford(cost)) throw NotEnoughCoinsError(costInCoins: cost, coins: player.coins);

    final level = matchProgress.playerLevelProgress.level;
    if (levelEngine.isMaxLevel(level)) throw MaxLevelReachedError(maxLevel: level.number);

    return matchProgress.createCopyWith(
      player: player.createCopyWithCoinsSpent(cost),
      playerLevelProgress: levelEngine.gainExperience(matchProgress.playerLevelProgress, economyEngine.experiencePerPurchase),
    );
  }
}
