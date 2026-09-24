import '../../models/phase/phase_run.dart';
import '../../models/shop/refresh_shop_offers.dart';

bool rerollShop(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final rerollCostInCoins = phaseRun.rules.shopRules.rerollCostInCoins;
  if (player.coins < rerollCostInCoins) return false;

  player.coins -= rerollCostInCoins;
  refreshShopOffers(phaseRun);
  return true;
}
