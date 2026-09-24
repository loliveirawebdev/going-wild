import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/shop/refresh_shop_offers.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  test('rerolling costs coins and replaces the offers', () {
    final phaseRun = phaseRunWith(coins: 5, level: 6);
    refreshShopOffers(phaseRun);
    final offersBeforeReroll = [...phaseRun.player.shopOffers];

    final hasRerolled = rerollShop(phaseRun);

    expect(hasRerolled, isTrue);
    expect(phaseRun.player.coins, 5 - testShopRules.rerollCostInCoins);
    expect(phaseRun.player.shopOffers, hasLength(testShopRules.shopSize));
    expect(phaseRun.player.shopOffers, isNot(offersBeforeReroll));
    expect(phaseRun.events.whereType<ShopOffersRefreshed>(), hasLength(2));
  });

  test('rerolling without enough coins changes nothing', () {
    final phaseRun = phaseRunWith(coins: testShopRules.rerollCostInCoins - 1, level: 6);
    refreshShopOffers(phaseRun);
    final offersBeforeReroll = [...phaseRun.player.shopOffers];

    final hasRerolled = rerollShop(phaseRun);

    expect(hasRerolled, isFalse);
    expect(phaseRun.player.coins, testShopRules.rerollCostInCoins - 1);
    expect(phaseRun.player.shopOffers, offersBeforeReroll);
    expect(phaseRun.events.whereType<ShopOffersRefreshed>(), hasLength(1));
  });
}
