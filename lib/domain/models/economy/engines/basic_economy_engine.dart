import '../../character/character.dart';
import '../../character/character_copy.dart';
import '../../character/rarity.dart';
import '../../player/player.dart';
import '../errors/rarity_without_price_error.dart';
import 'economy_engine.dart';

class BasicEconomyEngine extends EconomyEngine {
  const BasicEconomyEngine({
    required this.startingCoins,
    required this.rerollCostInCoins,
    required this.priceInCoinsByRarity,
    required this.experiencePerPurchase,
    required this.experiencePurchaseCostInCoins,
    required this.mergedCharacterSellDiscountInCoins,
  });

  @override
  final int startingCoins;

  @override
  final int rerollCostInCoins;

  @override
  final int experiencePerPurchase;

  @override
  final int experiencePurchaseCostInCoins;

  final int mergedCharacterSellDiscountInCoins;
  final Map<Rarity, int> priceInCoinsByRarity;

  @override
  int priceOf(Character character) => priceInCoinsByRarity[character.rarity] ?? (throw RarityWithoutPriceError(rarity: character.rarity));

  @override
  int roundIncome({required Player player, required int waveReward}) => waveReward;

  @override
  int sellPriceOf(CharacterCopy characterCopy, {required int copiesInside}) {
    final character = characterCopy.character;
    final coinsPaidForAllCopies = priceOf(character) * copiesInside;

    final isCommon = character.rarity == Rarity.common;
    final isMergedCharacter = characterCopy.stars > 1;
    if (!isMergedCharacter || isCommon) return coinsPaidForAllCopies;

    return coinsPaidForAllCopies - mergedCharacterSellDiscountInCoins;
  }
}
