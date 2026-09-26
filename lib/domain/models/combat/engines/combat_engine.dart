import 'dart:math';

import '../../board/board.dart';
import '../../board/placement.dart';
import '../combat_result.dart';

abstract class CombatEngine {
  const CombatEngine();

  Board get board;

  CombatResult simulate({
    required List<Placement> team,
    required List<Placement> enemies,
    required Random randomGenerator,
  });
}
