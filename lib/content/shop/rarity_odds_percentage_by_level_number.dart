import 'package:going_wild/domain/models/character/rarity.dart';

const Map<int, Map<Rarity, int>> rarityOddsPercentageByLevelNumber = {
  1: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
  2: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
  3: {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0},
  4: {Rarity.common: 55, Rarity.uncommon: 30, Rarity.rare: 15, Rarity.epic: 0},
  5: {Rarity.common: 45, Rarity.uncommon: 33, Rarity.rare: 20, Rarity.epic: 2},
  6: {Rarity.common: 30, Rarity.uncommon: 40, Rarity.rare: 25, Rarity.epic: 5},
  7: {Rarity.common: 19, Rarity.uncommon: 30, Rarity.rare: 40, Rarity.epic: 11},
  8: {Rarity.common: 18, Rarity.uncommon: 27, Rarity.rare: 43, Rarity.epic: 12},
  9: {Rarity.common: 13, Rarity.uncommon: 28, Rarity.rare: 45, Rarity.epic: 14},
  10: {Rarity.common: 10, Rarity.uncommon: 30, Rarity.rare: 45, Rarity.epic: 15},
};
