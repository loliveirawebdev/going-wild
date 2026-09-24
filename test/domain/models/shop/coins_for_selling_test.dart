import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/shop/coins_for_selling.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  final discount = testShopRules.mergedCharacterSellDiscountInCoins;

  test('a one-star character gives back what was paid for it', () {
    expect(coinsForSelling(owned(cow), testShopRules), cow.rarity.coins);
  });

  test('a merged character gives back what was paid for its copies minus the discount', () {
    expect(coinsForSelling(owned(cow, stars: 2), testShopRules), cow.rarity.coins * 2 - discount);
    expect(coinsForSelling(owned(cow, stars: 3), testShopRules), cow.rarity.coins * 4 - discount);
  });

  test('a merged common character has no discount', () {
    expect(rabbit.rarity, Rarity.common);
    expect(coinsForSelling(owned(rabbit, stars: 2), testShopRules), rabbit.rarity.coins * 2);
    expect(coinsForSelling(owned(rabbit, stars: 3), testShopRules), rabbit.rarity.coins * 4);
  });

  test('the copies inside follow the copies per merge rule', () {
    final rulesWithThreeCopies = shopRulesWith(copiesPerMerge: 3);
    expect(coinsForSelling(owned(cow, stars: 3), rulesWithThreeCopies), cow.rarity.coins * 9 - discount);
  });
}
