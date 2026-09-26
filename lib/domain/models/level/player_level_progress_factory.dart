import 'player_level.dart';
import 'player_level_progress.dart';

class PlayerLevelProgressFactory {
  static PlayerLevelProgress atStartOf(PlayerLevel level) => PlayerLevelProgress(level: level, experience: 0);
}
