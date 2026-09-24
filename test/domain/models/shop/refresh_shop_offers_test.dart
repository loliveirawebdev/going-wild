import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

List<Character?> offersAfterManyRefreshes(PhaseRun phaseRun, {int refreshCount = 500}) {
  final allOffers = <Character?>[];
  for (var refresh = 0; refresh < refreshCount; refresh++) {
    refreshShopOffers(phaseRun);
    allOffers.addAll(phaseRun.player.shopOffers);
  }
  return allOffers;
}

void main() {
  test('fills every slot of the shop', () {
    final phaseRun = phaseRunWith(level: 5);
    refreshShopOffers(phaseRun);
    expect(phaseRun.player.shopOffers, hasLength(testShopRules.shopSize));
    expect(phaseRun.player.shopOffers, everyElement(isNotNull));
  });

  test('records the new offers', () {
    final phaseRun = phaseRunWith(level: 5);
    refreshShopOffers(phaseRun);
    final refreshed = phaseRun.events.whereType<ShopOffersRefreshed>().single;
    expect(refreshed.shopOffers, phaseRun.player.shopOffers);
    expect(refreshed.roundNumber, phaseRun.currentRoundNumber);
  });

  test('the same seed gives the same shop', () {
    final firstPhaseRun = phaseRunWith(level: 6, seed: 42);
    final secondPhaseRun = phaseRunWith(level: 6, seed: 42);
    refreshShopOffers(firstPhaseRun);
    refreshShopOffers(secondPhaseRun);
    expect(firstPhaseRun.player.shopOffers, secondPhaseRun.player.shopOffers);
  });

  test('level 1 offers only common characters', () {
    final allOffers = offersAfterManyRefreshes(phaseRunWith(level: 1));
    expect(allOffers.map((character) => character!.rarity).toSet(), {Rarity.common});
  });

  test('a rarity with zero odds at the current level never shows up', () {
    final allOffers = offersAfterManyRefreshes(phaseRunWith(level: 4));
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('rarities show up close to the odds of the level', () {
    const level = 7;
    final allOffers = offersAfterManyRefreshes(phaseRunWith(level: level), refreshCount: 5000);
    final shopOddsPercentageByRarity = testShopRules.playerLevels[level - 1].shopOddsPercentageByRarity;

    for (final rarity in Rarity.values) {
      final observedPercentage = allOffers.where((character) => character!.rarity == rarity).length / allOffers.length * 100;
      expect(observedPercentage, closeTo(shopOddsPercentageByRarity[rarity]!, 1.5), reason: rarity.name);
    }
  });

  test('the bull shows up at most at the per character cap even when epic odds are higher', () {
    const maxOddsPercentagePerCharacter = 5;
    final rulesWithLowCap = shopRulesWith(maxShopOddsPercentagePerCharacter: maxOddsPercentagePerCharacter);
    final phaseRun = phaseRunWith(level: rulesWithLowCap.maxLevel, shopRules: rulesWithLowCap);
    final allOffers = offersAfterManyRefreshes(phaseRun, refreshCount: 5000);
    final bullPercentage = allOffers.where((character) => character == bull).length / allOffers.length * 100;

    expect(rulesWithLowCap.playerLevels.last.shopOddsPercentageByRarity[Rarity.epic], greaterThan(maxOddsPercentagePerCharacter));
    expect(bullPercentage, closeTo(maxOddsPercentagePerCharacter, 1));
  });

  test('a character owned at max stars stops showing up', () {
    final phaseRun = phaseRunWith(level: 10, benchCharacters: [owned(bull, stars: testShopRules.maxStars)]);
    expect(offersAfterManyRefreshes(phaseRun), isNot(contains(bull)));
  });

  test('a character below max stars keeps showing up', () {
    final phaseRun = phaseRunWith(level: 10, benchCharacters: [owned(bull, stars: testShopRules.maxStars - 1)]);
    expect(offersAfterManyRefreshes(phaseRun), contains(bull));
  });

  test('when a whole rarity is maxed out its odds go to the other rarities', () {
    final phaseRun = phaseRunWith(level: 10, benchCharacters: [owned(bull, stars: testShopRules.maxStars)]);
    final allOffers = offersAfterManyRefreshes(phaseRun);
    expect(allOffers, everyElement(isNotNull));
    expect(allOffers.where((character) => character!.rarity == Rarity.epic), isEmpty);
  });

  test('slots stay empty when nothing is left to offer at the current odds', () {
    final allCommonsAtMaxStars = allTeamCharacters
        .where((character) => character.rarity == Rarity.common)
        .map((character) => owned(character, stars: testShopRules.maxStars))
        .toList();
    final phaseRun = phaseRunWith(level: 1, benchCharacters: allCommonsAtMaxStars);

    refreshShopOffers(phaseRun);

    expect(phaseRun.player.shopOffers, hasLength(testShopRules.shopSize));
    expect(phaseRun.player.shopOffers, everyElement(isNull));
  });
}
