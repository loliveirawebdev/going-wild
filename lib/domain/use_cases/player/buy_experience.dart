import '../../models/player/level/gain_experience.dart';
import '../../models/player/player.dart';
import '../../models/shop/shop_rules.dart';

bool buyExperience(Player player, ShopRules rules) {
  if (player.level >= rules.maxLevel || player.coins < rules.experiencePurchaseCostInCoins) return false;

  player.coins -= rules.experiencePurchaseCostInCoins;
  gainExperience(player, rules, rules.experiencePerPurchase);
  return true;
}
