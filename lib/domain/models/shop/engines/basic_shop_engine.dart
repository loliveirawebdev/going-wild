import 'dart:math';

import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/shop/engines/shop_engine.dart';
import 'package:going_wild/domain/models/shop/errors/level_without_shop_odds_error.dart';
import 'package:going_wild/domain/models/shop/shop.dart';
import 'package:going_wild/domain/models/shop/shop_factory.dart';

class BasicShopEngine extends ShopEngine {
  const BasicShopEngine({
    required this.size,
    required this.purchasableCharacters,
    required this.maxOddsPercentagePerCharacter,
    required this.rarityOddsPercentageByLevelNumber,
  });

  final int size;
  final int maxOddsPercentagePerCharacter;
  final List<Character> purchasableCharacters;
  final Map<int, Map<Rarity, int>> rarityOddsPercentageByLevelNumber;

  @override
  Shop startingShop() => ShopFactory.empty(size: size);

  @override
  List<Character?> pickOffers({required MatchProgress matchProgress}) {
    final roster = matchProgress.playerRoster;
    final randomGenerator = matchProgress.randomGenerator;
    final maxStars = matchProgress.phase.engines.characterEngine.maxStars;
    final levelNumber = matchProgress.playerLevelProgress.level.number;
    final oddsPercentageByRarity = rarityOddsPercentageByLevelNumber[levelNumber];
    if (oddsPercentageByRarity == null) throw LevelWithoutShopOddsError(levelNumber: levelNumber);

    final charactersAtMaxStars = {
      for (final characterCopy in roster.characterCopies)
        if (characterCopy.stars >= maxStars) characterCopy.character,
    };

    final availableCharacters = purchasableCharacters.where((character) => !charactersAtMaxStars.contains(character)).toList();

    final availableCharacterCountByRarity = {
      for (final rarity in Rarity.values) rarity: availableCharacters.where((character) => character.rarity == rarity).length,
    };

    final oddsByRarity = limitRarityOddsToMaxOddsPerCharacter(
      oddsPercentageByRarity: oddsPercentageByRarity,
      maxOddsPercentagePerCharacter: maxOddsPercentagePerCharacter,
      purchasableCharacterCountByRarity: availableCharacterCountByRarity,
    );

    return List.unmodifiable(
      List.generate(size, (_) {
        final rarity = _pickRandomRarity(oddsByRarity, randomGenerator);
        if (rarity == null) return null;

        final charactersOfRarity = availableCharacters.where((character) => character.rarity == rarity).toList();
        return charactersOfRarity[randomGenerator.nextInt(charactersOfRarity.length)];
      }),
    );
  }
}

Map<Rarity, double> limitRarityOddsToMaxOddsPerCharacter({
  required int maxOddsPercentagePerCharacter,
  required Map<Rarity, int> oddsPercentageByRarity,
  required Map<Rarity, int> purchasableCharacterCountByRarity,
}) {
  final cappedOddsByRarity = {for (final rarity in Rarity.values) rarity: (oddsPercentageByRarity[rarity] ?? 0).toDouble()};
  double capOf(Rarity rarity) => ((purchasableCharacterCountByRarity[rarity] ?? 0) * maxOddsPercentagePerCharacter).toDouble();

  for (var round = 0; round < Rarity.values.length; round++) {
    final raritiesAboveCap = Rarity.values.where((rarity) => cappedOddsByRarity[rarity]! > capOf(rarity)).toList();
    if (raritiesAboveCap.isEmpty) break;

    final excessOdds = raritiesAboveCap.fold(0.0, (sum, rarity) => sum + cappedOddsByRarity[rarity]! - capOf(rarity));
    for (final rarity in raritiesAboveCap) cappedOddsByRarity[rarity] = capOf(rarity);

    final receivingRarities = Rarity.values.where((rrty) => cappedOddsByRarity[rrty]! > 0 && cappedOddsByRarity[rrty]! < capOf(rrty));
    final receivingOdds = receivingRarities.fold(0.0, (sum, rarity) => sum + cappedOddsByRarity[rarity]!);

    if (receivingOdds == 0) {
      _giveExcessBackToRaritiesWithCharacters(cappedOddsByRarity, raritiesAboveCap, capOf, excessOdds);
      break;
    }

    for (final rarity in receivingRarities.toList())
      cappedOddsByRarity[rarity] = cappedOddsByRarity[rarity]! + excessOdds * cappedOddsByRarity[rarity]! / receivingOdds;
  }

  return cappedOddsByRarity;
}

void _giveExcessBackToRaritiesWithCharacters(
  Map<Rarity, double> cappedOddsByRarity,
  List<Rarity> raritiesAboveCap,
  double Function(Rarity rarity) capOf,
  double excessOdds,
) {
  final raritiesWithCharacters = raritiesAboveCap.where((rarity) => capOf(rarity) > 0).toList();
  final totalCap = raritiesWithCharacters.fold(0.0, (sum, rarity) => sum + capOf(rarity));
  if (totalCap == 0) return;

  for (final rarity in raritiesWithCharacters)
    cappedOddsByRarity[rarity] = cappedOddsByRarity[rarity]! + excessOdds * capOf(rarity) / totalCap;
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
