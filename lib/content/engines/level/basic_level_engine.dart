import 'package:going_wild/content/level/player_levels.dart';
import 'package:going_wild/domain/models/level/engines/basic_level_engine.dart';

const BasicLevelEngine basicLevelEngine = BasicLevelEngine(
  playerLevels: playerLevels,
  experiencePerRound: 2,
);
