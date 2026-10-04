import 'package:going_wild/domain/models/level/player_level.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

abstract class LevelEngine {
  const LevelEngine();

  PlayerLevelProgress startingProgress();
  bool isMaxLevel(PlayerLevel level);
  int experienceForRound({required MatchProgress matchProgress});
  PlayerLevelProgress gainExperience(PlayerLevelProgress playerLevelProgress, int experienceAmount);
}
