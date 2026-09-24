import 'dart:math';

import '../../models/player/level/gain_experience.dart';
import '../../models/player/player.dart';
import '../../models/shop/refresh_shop_offers.dart';
import '../../models/shop/shop_rules.dart';

void startRound(Player player, ShopRules rules, Random randomGenerator) {
  player.coins += rules.coinsPerRound;
  gainExperience(player, rules, rules.experiencePerRound);
  refreshShopOffers(player, rules, randomGenerator);
}
