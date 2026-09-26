import '../player_level.dart';
import '../player_level_progress.dart';

abstract class LevelEngine {
  const LevelEngine();

  int get experiencePerRound;

  PlayerLevelProgress startingProgress();
  bool isMaxLevel(PlayerLevel level);
  PlayerLevelProgress gainExperience(PlayerLevelProgress playerLevelProgress, int experienceAmount);
}
