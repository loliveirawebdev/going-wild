import 'package:going_wild/content/board.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/set/basic_set_engine.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat/engines/basic_combat_engine.dart';

const BasicCombatEngine basicCombatEngine = BasicCombatEngine(
  board: board,
  setEngine: basicSetEngine,
  characterEngine: basicCharacterEngine,

  rules: CombatRules(
    maxSeconds: 60,
    manaPerHit: 10,
    nearbyRadius: 2,
    ticksPerSecond: 10,
    moveSpeedWeightOnSteps: 0.2,
    stepSecondsAtBaseMoveSpeed: 1.4,
  ),
);
