import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/shop/coins_for_selling.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  test('selling gives back every coin paid for the copies inside', () {
    expect(coinsForSelling(owned(cow), testShopRules), cow.rarity.coins);
    expect(coinsForSelling(owned(cow, stars: 2), testShopRules), cow.rarity.coins * 2);
    expect(coinsForSelling(owned(cow, stars: 3), testShopRules), cow.rarity.coins * 4);
  });

  test('the copies inside follow the copies per merge rule', () {
    final rulesWithThreeCopies = shopRulesWith(copiesPerMerge: 3);
    expect(coinsForSelling(owned(cow, stars: 3), rulesWithThreeCopies), cow.rarity.coins * 9);
  });
}
