import 'package:going_wild/domain/models/level/engines/basic_level_engine.dart';

import '../../level/player_levels.dart';

const BasicLevelEngine basicLevelEngine = BasicLevelEngine(
  playerLevels: playerLevels,
  experiencePerRound: 2,
);
