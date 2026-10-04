import 'package:going_wild/domain/models/level/player_level.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';

class PlayerLevelProgressFactory {
  static PlayerLevelProgress atStartOf(PlayerLevel level) => PlayerLevelProgress(level: level, experience: 0);
}
