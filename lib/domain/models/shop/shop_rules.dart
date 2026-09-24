import '../models.dart';
import '../player/level/player_level.dart';

class ShopRules {
  const ShopRules({
    required this.maxStars,
    required this.shopSize,
    required this.playerLevels,
    required this.copiesPerMerge,
    required this.rerollCostInCoins,
    required this.experiencePerRound,
    required this.purchasableCharacters,
    required this.experiencePerPurchase,
    required this.experiencePurchaseCostInCoins,
    required this.maxShopOddsPercentagePerCharacter,
    required this.mergedCharacterSellDiscountInCoins,
  });

  final int maxStars;
  final int shopSize;
  final int copiesPerMerge;
  final int rerollCostInCoins;
  final int experiencePerRound;
  final int experiencePerPurchase;
  final int experiencePurchaseCostInCoins;
  final int maxShopOddsPercentagePerCharacter;
  final int mergedCharacterSellDiscountInCoins;
  final List<PlayerLevel> playerLevels;
  final List<Character> purchasableCharacters;

  int get maxLevel => playerLevels.length;
}
