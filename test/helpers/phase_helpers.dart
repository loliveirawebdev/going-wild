import 'dart:math';

import 'package:going_wild/data/character/base_stats.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/merge_curves/merge_curves.dart';
import 'package:going_wild/data/phase/phase_rules.dart' as rules;
import 'package:going_wild/data/set/sets.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_rules.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/shop/owned_character.dart';
import 'package:going_wild/domain/models/shop/shop_rules.dart';

import 'combat_helpers.dart';
import 'shop_helpers.dart';

PhaseRules phaseRulesWith({int startingPlayerLives = rules.startingPlayerLives, ShopRules shopRules = testShopRules}) => PhaseRules(
  board: testBoard,
  sets: allSets,
  baseStats: baseStats,
  shopRules: shopRules,
  battleRules: testRules,
  mergeCurveFor: mergeCurveFor,
  startingPlayerLives: startingPlayerLives,
);

Placement placed(Character character, int row, int column, {int stars = 1}) => Placement(
  character: character,
  stars: stars,
  position: Position(row: row, column: column),
);

Phase phaseWith(List<EnemyWave> enemyWaves) => Phase(id: 'test_phase', enemyWaves: enemyWaves);

PhaseRun phaseRunWith({
  int coins = 0,
  int level = 1,
  int experience = 0,
  int seed = 1,
  List<OwnedCharacter> ownedCharacters = const [],
  List<Character?> shopOffers = const [],
  ShopRules shopRules = testShopRules,
  List<EnemyWave>? enemyWaves,
}) {
  final player = playerWith(coins: coins, level: level, experience: experience, ownedCharacters: ownedCharacters)
    ..shopOffers = [...shopOffers];

  return PhaseRun(
    phase: phaseWith(
      enemyWaves ??
          [
            EnemyWave(enemies: [placed(rat, 1, 2)]),
          ],
    ),
    rules: phaseRulesWith(shopRules: shopRules),
    player: player,
    randomGenerator: Random(seed),
  );
}
