import 'package:going_wild/domain/models/level/player_level.dart';

class PlayerLevelProgress {
  const PlayerLevelProgress({required this.level, required this.experience});

  final PlayerLevel level;
  final int experience;
}
