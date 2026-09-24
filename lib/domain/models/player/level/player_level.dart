import '../../models.dart';

class PlayerLevel {
  const PlayerLevel({required this.experienceToNextLevel, required this.shopOddsPercentageByRarity});

  final int experienceToNextLevel;
  final Map<Rarity, int> shopOddsPercentageByRarity;
}
