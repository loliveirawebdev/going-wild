import 'dart:math';

import 'package:going_wild/data/rules.dart';
import 'package:going_wild/domain/combat/battle.dart';
import 'package:going_wild/domain/combat/battle_rules.dart';
import 'package:going_wild/domain/combat/board/board.dart';
import 'package:going_wild/domain/combat/board/faction.dart';
import 'package:going_wild/domain/combat/board/position.dart';
import 'package:going_wild/domain/combat/unit/unit.dart';
import 'package:going_wild/domain/models/models.dart';

const testRules = BattleRules(
  tickSeconds: tickSeconds,
  manaPerHit: manaPerHit,
  nearbyRadius: nearbyRadius,
  lowHealthTriggerPercentage: lowHealthTriggerPercentage,
  maxSeconds: 60,
);

const testBoard = Board(rows: boardRows, columns: boardColumns);
const noAbility = Ability(id: 'none', trigger: AbilityTrigger.manaFull, effects: []);

Character dummy({String id = 'dummy', Role role = Role.damage, Ability ability = noAbility}) => Character(
  id: id,
  role: role,
  rarity: Rarity.common,
  statMultipliers: const StatMultipliers({}),
  ability: ability,
);

Stats statsOf({
  double health = 1000,
  double damage = 100,
  double armor = 0,
  double shield = 0,
  double attackSpeed = 1,
  double moveSpeed = 1,
  double damageTakenPercentage = 1,
  double manaStart = 0,
  double manaMax = 50,
  double range = 1,
}) => Stats(
  health: health,
  damage: damage,
  armor: armor,
  shield: shield,
  attackSpeed: attackSpeed,
  moveSpeed: moveSpeed,
  damageTakenPercentage: damageTakenPercentage,
  manaStart: manaStart,
  manaMax: manaMax,
  range: range,
);

int _nextId = 1;

Unit unit({
  required Faction faction,
  required Position at,
  Stats? stats,
  Character? character,
  int stars = 1,
}) => Unit(
  id: _nextId++,
  character: character ?? dummy(),
  faction: faction,
  stars: stars,
  stats: stats ?? statsOf(),
  position: at,
);

Battle battleWith(List<Unit> units, {int seed = 1}) {
  return Battle(
    board: testBoard,
    rules: testRules,
    units: units,
    randomGenerator: Random(seed),
  );
}

Position at(int row, int column) => Position(row: row, column: column);
