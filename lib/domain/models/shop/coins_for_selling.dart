import 'dart:math';

import 'owned_character.dart';
import 'shop_rules.dart';

int coinsForSelling(OwnedCharacter ownedCharacter, ShopRules rules) {
  final copiesInside = pow(rules.copiesPerMerge, ownedCharacter.stars - 1).toInt();
  return ownedCharacter.character.rarity.coins * copiesInside;
}
