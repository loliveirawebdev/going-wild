import '../errors/unknown_player_level_error.dart';
import '../player_level.dart';
import '../player_level_progress.dart';
import '../player_level_progress_factory.dart';
import 'level_engine.dart';

class BasicLevelEngine extends LevelEngine {
  const BasicLevelEngine({
    required this.playerLevels,
    required this.experiencePerRound,
  });

  final List<PlayerLevel> playerLevels;

  @override
  final int experiencePerRound;

  @override
  PlayerLevelProgress startingProgress() => PlayerLevelProgressFactory.atStartOf(playerLevels.first);

  @override
  bool isMaxLevel(PlayerLevel level) => _indexOf(level) == playerLevels.length - 1;

  @override
  PlayerLevelProgress gainExperience(PlayerLevelProgress playerLevelProgress, int experienceAmount) {
    var levelIndex = _indexOf(playerLevelProgress.level);
    var experience = playerLevelProgress.experience + experienceAmount;
    final lastLevelIndex = playerLevels.length - 1;

    while (levelIndex < lastLevelIndex && experience >= playerLevels[levelIndex].experienceToNextLevel) {
      experience -= playerLevels[levelIndex].experienceToNextLevel;
      levelIndex += 1;
    }

    if (levelIndex == lastLevelIndex) experience = 0;
    return PlayerLevelProgress(level: playerLevels[levelIndex], experience: experience);
  }

  int _indexOf(PlayerLevel level) {
    final levelIndex = playerLevels.indexOf(level);
    if (levelIndex < 0) throw UnknownPlayerLevelError(levelNumber: level.number);
    return levelIndex;
  }
}
