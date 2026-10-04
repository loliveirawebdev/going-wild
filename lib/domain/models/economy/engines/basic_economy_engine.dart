import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/economy/engines/economy_engine.dart';
import 'package:going_wild/domain/models/economy/errors/rarity_without_price_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

class BasicEconomyEngine extends EconomyEngine {
  const BasicEconomyEngine({
    required this.startingCoins,
    required this.fixedRerollCostInCoins,
    required this.priceInCoinsByRarity,
    required this.fixedExperiencePerPurchase,
    required this.fixedExperiencePurchaseCostInCoins,
    required this.mergedCharacterSellDiscountInCoins,
  });

  @override
  final int startingCoins;

  final int fixedRerollCostInCoins;
  final int fixedExperiencePerPurchase;
  final int fixedExperiencePurchaseCostInCoins;
  final int mergedCharacterSellDiscountInCoins;
  final Map<Rarity, int> priceInCoinsByRarity;

  @override
  int rerollCostInCoins({required MatchProgress matchProgress}) => fixedRerollCostInCoins;

  @override
  int experiencePerPurchase({required MatchProgress matchProgress}) => fixedExperiencePerPurchase;

  @override
  int experiencePurchaseCostInCoins({required MatchProgress matchProgress}) => fixedExperiencePurchaseCostInCoins;

  @override
  int priceOf(Character character, {required MatchProgress matchProgress}) => priceOfRarity(character.rarity);

  int priceOfRarity(Rarity rarity) => priceInCoinsByRarity[rarity] ?? (throw RarityWithoutPriceError(rarity: rarity));

  @override
  int roundIncome({required MatchProgress matchProgress}) {
    final engines = matchProgress.phase.engines;
    final waveReward = matchProgress.currentWave.coinsReward;
    final boardCharacters = matchProgress.playerRoster.placements.map((placement) => placement.characterCopy.character).toList();
    final activeSets = engines.setEngine.activeSets(boardCharacters);

    return waveReward + engines.setEngine.bonusCoinsPerRound(activeSets);
  }

  @override
  int sellPriceOf(CharacterCopy characterCopy, {required MatchProgress matchProgress}) {
    final character = characterCopy.character;
    final copiesInside = matchProgress.phase.engines.mergeEngine.copiesInside(characterCopy.stars);
    final coinsPaidForAllCopies = priceOfRarity(character.rarity) * copiesInside;

    final isCommon = character.rarity == Rarity.common;
    final isMergedCharacter = characterCopy.stars > 1;
    if (!isMergedCharacter || isCommon) return coinsPaidForAllCopies;

    return coinsPaidForAllCopies - mergedCharacterSellDiscountInCoins;
  }
}
