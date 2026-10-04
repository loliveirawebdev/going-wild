import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/content/engines/merge/basic_merge_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/economy/engines/basic_economy_engine.dart';
import 'package:going_wild/domain/models/economy/errors/rarity_without_price_error.dart';
import 'package:going_wild/domain/models/merge/engines/basic_merge_engine.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/set/effects/set_bonus_coins_per_round.dart';
import 'package:going_wild/domain/models/set/engines/basic_set_engine.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

import '../../../../helpers/inventory_helpers.dart';
import '../../../../helpers/use_case_helpers.dart';

int priceInCoinsOfRarity(Rarity rarity) => basicEconomyEngine.priceInCoinsByRarity[rarity]!;

int sellPriceOf(Character character, {int stars = 1, int? copiesPerMerge}) {
  final mergeEngine = BasicMergeEngine(copiesPerMerge: copiesPerMerge ?? basicMergeEngine.copiesPerMerge);
  final matchProgress = matchProgressWith(engines: basicPhaseEngines.createCopyWith(mergeEngine: mergeEngine));

  return basicEconomyEngine.sellPriceOf(characterCopyOf(character, stars: stars), matchProgress: matchProgress);
}

const farmersSet = TeamSet(
  id: SetId('farmers'),
  members: [cow, bull],
  tiers: [
    SetTier(count: 2, effects: [SetBonusCoinsPerRound(coins: 3)]),
  ],
);

Roster rosterWithBoard(List<Placement> placements) => Roster(placements: placements, inventory: inventoryWith(const []));

void main() {
  final discount = basicEconomyEngine.mergedCharacterSellDiscountInCoins;

  test('the price of a character is the coins of its rarity', () {
    final matchProgress = matchProgressWith();

    expect(basicEconomyEngine.priceOf(cow, matchProgress: matchProgress), priceInCoinsOfRarity(cow.rarity));
    expect(basicEconomyEngine.priceOf(bull, matchProgress: matchProgress), priceInCoinsOfRarity(bull.rarity));
  });

  test('pricing a character whose rarity has no price fails', () {
    final economyWithoutEpicPrice = BasicEconomyEngine(
      priceInCoinsByRarity: const {Rarity.common: 1},
      startingCoins: basicEconomyEngine.startingCoins,
      fixedRerollCostInCoins: basicEconomyEngine.fixedRerollCostInCoins,
      fixedExperiencePerPurchase: basicEconomyEngine.fixedExperiencePerPurchase,
      fixedExperiencePurchaseCostInCoins: basicEconomyEngine.fixedExperiencePurchaseCostInCoins,
      mergedCharacterSellDiscountInCoins: basicEconomyEngine.mergedCharacterSellDiscountInCoins,
    );

    expect(() => economyWithoutEpicPrice.priceOf(bull, matchProgress: matchProgressWith()), throwsA(isA<RarityWithoutPriceError>()));
  });

  test('the round income is the reward of the current wave', () {
    final matchProgress = matchProgressWith(waves: [oneRat]);
    expect(basicEconomyEngine.roundIncome(matchProgress: matchProgress), oneRat.coinsReward);
  });

  test('an active set with bonus coins adds them to the round income', () {
    final engines = basicPhaseEngines.createCopyWith(setEngine: const BasicSetEngine(sets: [farmersSet]));
    final fullSetRoster = rosterWithBoard([placed(cow, 6, 1), placed(bull, 6, 3)]);
    final halfSetRoster = rosterWithBoard([placed(cow, 6, 1)]);

    final fullSetIncome = basicEconomyEngine.roundIncome(
      matchProgress: matchProgressWith(engines: engines, roster: fullSetRoster),
    );
    final halfSetIncome = basicEconomyEngine.roundIncome(
      matchProgress: matchProgressWith(engines: engines, roster: halfSetRoster),
    );

    expect(fullSetIncome, oneRat.coinsReward + 3);
    expect(halfSetIncome, oneRat.coinsReward);
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

  test('the copies inside follow the copies per merge rule of the phase', () {
    expect(sellPriceOf(cow, stars: 3, copiesPerMerge: 3), priceInCoinsOfRarity(cow.rarity) * 9 - discount);
  });
}
