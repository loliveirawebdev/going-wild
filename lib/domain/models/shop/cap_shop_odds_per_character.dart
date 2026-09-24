import '../models.dart';

Map<Rarity, double> capShopOddsPerCharacter({
  required Map<Rarity, int> oddsPercentageByRarity,
  required Map<Rarity, int> purchasableCharacterCountByRarity,
  required int maxOddsPercentagePerCharacter,
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
