import 'dart:math';

import '../models.dart';
import '../player/player.dart';
import 'cap_shop_odds_per_character.dart';
import 'shop_rules.dart';

void refreshShopOffers(Player player, ShopRules rules, Random randomGenerator) {
  final purchasableCharacters = rules.purchasableCharacters.where((character) => !_isOwnedAtMaxStars(player, rules, character)).toList();
  final oddsPercentageByRarity = rules.playerLevels[player.level - 1].shopOddsPercentageByRarity;

  final purchasableCharacterCountByRarity = {
    for (final rarity in Rarity.values) rarity: purchasableCharacters.where((character) => character.rarity == rarity).length,
  };

  final shopOddsByRarity = capShopOddsPerCharacter(
    oddsPercentageByRarity: oddsPercentageByRarity,
    purchasableCharacterCountByRarity: purchasableCharacterCountByRarity,
    maxOddsPercentagePerCharacter: rules.maxShopOddsPercentagePerCharacter,
  );

  player.shopOffers = List.generate(rules.shopSize, (_) {
    final rarity = _pickRandomRarity(shopOddsByRarity, randomGenerator);
    if (rarity == null) return null;

    final charactersOfRarity = purchasableCharacters.where((character) => character.rarity == rarity).toList();
    return charactersOfRarity[randomGenerator.nextInt(charactersOfRarity.length)];
  });
}

bool _isOwnedAtMaxStars(Player player, ShopRules rules, Character character) {
  return player.ownedCharacters.any((ownedCharacter) {
    return ownedCharacter.character == character && ownedCharacter.stars >= rules.maxStars;
  });
}

Rarity? _pickRandomRarity(Map<Rarity, double> oddsByRarity, Random randomGenerator) {
  final totalOdds = oddsByRarity.values.fold(0.0, (sum, odds) => sum + odds);
  if (totalOdds == 0) return null;

  var remainingRoll = randomGenerator.nextDouble() * totalOdds;

  for (final MapEntry(key: rarity, value: odds) in oddsByRarity.entries) {
    if (remainingRoll < odds) return rarity;
    remainingRoll -= odds;
  }

  return oddsByRarity.entries.lastWhere((entry) => entry.value > 0).key;
}
