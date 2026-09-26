import '../../models/match_progress/match_progress.dart';
import '../../models/player/errors/not_enough_coins_error.dart';
import 'refresh_shop_offers.dart';

class RerollShop {
  const RerollShop();

  MatchProgress call(MatchProgress matchProgress) {
    matchProgress.requireInProgress();

    const refreshShopOffers = RefreshShopOffers();

    final player = matchProgress.player;
    final rerollCostInCoins = matchProgress.phase.engines.economyEngine.rerollCostInCoins;
    if (!player.canAfford(rerollCostInCoins)) throw NotEnoughCoinsError(coins: player.coins, costInCoins: rerollCostInCoins);

    final paidMatchProgress = matchProgress.createCopyWith(
      shop: matchProgress.shop.createCopyUnlocked(),
      player: player.createCopyWithCoinsSpent(rerollCostInCoins),
    );

    return refreshShopOffers(paidMatchProgress);
  }
}
