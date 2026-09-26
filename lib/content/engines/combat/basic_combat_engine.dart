import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat/engines/basic_combat_engine.dart';

import '../../board.dart';
import '../character/basic_character_engine.dart';
import '../set/basic_set_engine.dart';

const BasicCombatEngine basicCombatEngine = BasicCombatEngine(
  board: board,
  setEngine: basicSetEngine,
  characterEngine: basicCharacterEngine,
  rules: CombatRules(ticksPerSecond: 10, maxSeconds: 60, manaPerHit: 10, nearbyRadius: 2, lowHealthTriggerPercentage: 30),
);
