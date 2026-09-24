import 'dart:math';

import '../character/rarity.dart';
import 'owned_character.dart';
import 'shop_rules.dart';

int coinsForSelling(OwnedCharacter ownedCharacter, ShopRules rules) {
  final rarity = ownedCharacter.character.rarity;
  final copiesInside = pow(rules.copiesPerMerge, ownedCharacter.stars - 1).toInt();
  final coinsPaidForAllCopies = rarity.coins * copiesInside;

  final isMergedCharacter = ownedCharacter.stars > 1;
  final isCommon = rarity == Rarity.common;
  if (!isMergedCharacter || isCommon) return coinsPaidForAllCopies;

  return coinsPaidForAllCopies - rules.mergedCharacterSellDiscountInCoins;
}
