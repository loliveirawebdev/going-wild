import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/content/engines/merge/basic_merge_engine.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/economy/engines/basic_economy_engine.dart';
import 'package:going_wild/domain/models/economy/errors/rarity_without_price_error.dart';
import 'package:going_wild/domain/models/merge/engines/basic_merge_engine.dart';
import 'package:going_wild/domain/models/player/player.dart';

import '../../../../helpers/inventory_helpers.dart';

int priceInCoinsOfRarity(Rarity rarity) => basicEconomyEngine.priceInCoinsByRarity[rarity]!;

int sellPriceOf(Character character, {int stars = 1, int? copiesPerMerge}) {
  final mergeEngine = BasicMergeEngine(copiesPerMerge: copiesPerMerge ?? basicMergeEngine.copiesPerMerge);
  return basicEconomyEngine.sellPriceOf(characterCopyOf(character, stars: stars), copiesInside: mergeEngine.copiesInside(stars));
}

void main() {
  final discount = basicEconomyEngine.mergedCharacterSellDiscountInCoins;

  test('the price of a character is the coins of its rarity', () {
    expect(basicEconomyEngine.priceOf(cow), priceInCoinsOfRarity(cow.rarity));
    expect(basicEconomyEngine.priceOf(bull), priceInCoinsOfRarity(bull.rarity));
  });

  test('pricing a character whose rarity has no price fails', () {
    final economyWithoutEpicPrice = BasicEconomyEngine(
      priceInCoinsByRarity: const {Rarity.common: 1},
      startingCoins: basicEconomyEngine.startingCoins,
      rerollCostInCoins: basicEconomyEngine.rerollCostInCoins,
      experiencePerPurchase: basicEconomyEngine.experiencePerPurchase,
      experiencePurchaseCostInCoins: basicEconomyEngine.experiencePurchaseCostInCoins,
      mergedCharacterSellDiscountInCoins: basicEconomyEngine.mergedCharacterSellDiscountInCoins,
    );

    expect(() => economyWithoutEpicPrice.priceOf(bull), throwsA(isA<RarityWithoutPriceError>()));
  });

  test('the round income is the reward of the wave', () {
    const player = Player(coins: 12, remainingLives: 3);
    expect(basicEconomyEngine.roundIncome(player: player, waveReward: 10), 10);
  });

  test('a one-star character gives back what was paid for it', () {
    expect(sellPriceOf(cow), priceInCoinsOfRarity(cow.rarity));
  });

  test('a merged character gives back what was paid for its copies minus the discount', () {
    expect(sellPriceOf(cow, stars: 2), priceInCoinsOfRarity(cow.rarity) * 2 - discount);
    expect(sellPriceOf(cow, stars: 3), priceInCoinsOfRarity(cow.rarity) * 4 - discount);
  });

  test('a merged common character has no discount', () {
    expect(rabbit.rarity, Rarity.common);
    expect(sellPriceOf(rabbit, stars: 2), priceInCoinsOfRarity(rabbit.rarity) * 2);
    expect(sellPriceOf(rabbit, stars: 3), priceInCoinsOfRarity(rabbit.rarity) * 4);
  });

  test('the copies inside follow the copies per merge rule', () {
    expect(sellPriceOf(cow, stars: 3, copiesPerMerge: 3), priceInCoinsOfRarity(cow.rarity) * 9 - discount);
  });
}
