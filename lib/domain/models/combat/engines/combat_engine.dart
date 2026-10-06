import 'dart:math';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';

abstract class CombatEngine {
  const CombatEngine();

  Board get board;
  CombatRules get rules;

  List<Combatant> startingCombatantsOf({required List<Placement> team, required List<Placement> enemies});

  CombatResult simulate({
    required List<Placement> team,
    required bool recordsHistory,
    required List<Placement> enemies,
    required Random randomGenerator,
  });
}
