import '../../shop/shop_rules.dart';
import '../player.dart';

void gainExperience(Player player, ShopRules rules, int experienceAmount) {
  if (player.level >= rules.maxLevel) return;

  player.experience += experienceAmount;

  while (player.level < rules.maxLevel && player.experience >= rules.playerLevels[player.level - 1].experienceToNextLevel) {
    player.experience -= rules.playerLevels[player.level - 1].experienceToNextLevel;
    player.level += 1;
  }

  if (player.level >= rules.maxLevel) player.experience = 0;
}
