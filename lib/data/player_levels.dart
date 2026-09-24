import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/player/level/player_level.dart';

const List<PlayerLevel> playerLevels = [
  PlayerLevel(
    experienceToNextLevel: 2,
    shopOddsPercentageByRarity: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
  ),
  PlayerLevel(
    experienceToNextLevel: 2,
    shopOddsPercentageByRarity: {Rarity.common: 100, Rarity.uncommon: 0, Rarity.rare: 0, Rarity.epic: 0},
  ),
  PlayerLevel(
    experienceToNextLevel: 6,
    shopOddsPercentageByRarity: {Rarity.common: 75, Rarity.uncommon: 25, Rarity.rare: 0, Rarity.epic: 0},
  ),
  PlayerLevel(
    experienceToNextLevel: 10,
    shopOddsPercentageByRarity: {Rarity.common: 55, Rarity.uncommon: 30, Rarity.rare: 15, Rarity.epic: 0},
  ),
  PlayerLevel(
    experienceToNextLevel: 20,
    shopOddsPercentageByRarity: {Rarity.common: 45, Rarity.uncommon: 33, Rarity.rare: 20, Rarity.epic: 2},
  ),
  PlayerLevel(
    experienceToNextLevel: 36,
    shopOddsPercentageByRarity: {Rarity.common: 30, Rarity.uncommon: 40, Rarity.rare: 25, Rarity.epic: 5},
  ),
  PlayerLevel(
    experienceToNextLevel: 48,
    shopOddsPercentageByRarity: {Rarity.common: 19, Rarity.uncommon: 30, Rarity.rare: 40, Rarity.epic: 11},
  ),
  PlayerLevel(
    experienceToNextLevel: 76,
    shopOddsPercentageByRarity: {Rarity.common: 18, Rarity.uncommon: 27, Rarity.rare: 43, Rarity.epic: 12},
  ),
  PlayerLevel(
    experienceToNextLevel: 84,
    shopOddsPercentageByRarity: {Rarity.common: 13, Rarity.uncommon: 28, Rarity.rare: 45, Rarity.epic: 14},
  ),
  PlayerLevel(
    experienceToNextLevel: 0,
    shopOddsPercentageByRarity: {Rarity.common: 10, Rarity.uncommon: 30, Rarity.rare: 45, Rarity.epic: 15},
  ),
];
