import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/use_cases/shop/refresh_shop_offers.dart';

RejectedPlayerActionError? checkRerollingShop(MatchProgress matchProgress) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;

  final player = matchProgress.player;
  final rerollCostInCoins = _rerollCostInCoins(matchProgress);
  if (!player.canAfford(rerollCostInCoins)) return NotEnoughCoinsError(coins: player.coins, costInCoins: rerollCostInCoins);

  return null;
}

MatchProgress rerollShop(MatchProgress matchProgress) {
  if (checkRerollingShop(matchProgress) case final rejection?) throw rejection;

  final paidMatchProgress = matchProgress.createCopyWith(
    shop: matchProgress.shop.createCopyUnlocked(),
    player: matchProgress.player.createCopyWithCoinsSpent(_rerollCostInCoins(matchProgress)),
  );

  return refreshShopOffers(paidMatchProgress);
}

int _rerollCostInCoins(MatchProgress matchProgress) =>
    matchProgress.phase.engines.economyEngine.rerollCostInCoins(matchProgress: matchProgress);
