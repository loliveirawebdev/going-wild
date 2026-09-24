import 'dart:math';

import '../../models/player/player.dart';
import '../../models/shop/refresh_shop_offers.dart';
import '../../models/shop/shop_rules.dart';

bool rerollShop(Player player, ShopRules rules, Random randomGenerator) {
  if (player.coins < rules.rerollCostInCoins) return false;

  player.coins -= rules.rerollCostInCoins;
  refreshShopOffers(player, rules, randomGenerator);
  return true;
}
