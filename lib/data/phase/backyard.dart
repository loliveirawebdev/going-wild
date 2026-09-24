import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';
import 'package:going_wild/domain/models/phase/phase.dart';

import '../character/enemies/enemies.dart';

const Phase backyard = Phase(
  id: 'backyard',
  enemyWaves: [
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: rat, stars: 1, position: Position(row: 3, column: 2)),
        Placement(character: rat, stars: 1, position: Position(row: 3, column: 1)),
        Placement(character: rat, stars: 1, position: Position(row: 3, column: 3)),
        Placement(character: fox, stars: 1, position: Position(row: 3, column: 0)),
        Placement(character: fox, stars: 1, position: Position(row: 3, column: 4)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: boar, stars: 1, position: Position(row: 3, column: 2)),
        Placement(character: boar, stars: 1, position: Position(row: 3, column: 1)),
        Placement(character: fox, stars: 1, position: Position(row: 3, column: 3)),
        Placement(character: snake, stars: 1, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 1, position: Position(row: 3, column: 4)),
        Placement(character: rat, stars: 1, position: Position(row: 1, column: 2)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: boar, stars: 2, position: Position(row: 3, column: 2)),
        Placement(character: bear, stars: 1, position: Position(row: 3, column: 1)),
        Placement(character: snake, stars: 1, position: Position(row: 3, column: 3)),
        Placement(character: snake, stars: 1, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 1, position: Position(row: 3, column: 4)),
        Placement(character: fox, stars: 2, position: Position(row: 1, column: 2)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: bear, stars: 1, position: Position(row: 3, column: 2)),
        Placement(character: boar, stars: 2, position: Position(row: 3, column: 1)),
        Placement(character: alligator, stars: 1, position: Position(row: 3, column: 3)),
        Placement(character: snake, stars: 2, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: fox, stars: 1, position: Position(row: 1, column: 2)),
        Placement(character: rat, stars: 2, position: Position(row: 1, column: 1)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: bear, stars: 2, position: Position(row: 3, column: 2)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 1)),
        Placement(character: boar, stars: 2, position: Position(row: 3, column: 3)),
        Placement(character: bat, stars: 2, position: Position(row: 3, column: 0)),
        Placement(character: snake, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: fox, stars: 2, position: Position(row: 1, column: 2)),
        Placement(character: rat, stars: 1, position: Position(row: 1, column: 1)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: acromantula, stars: 1, position: Position(row: 3, column: 2)),
        Placement(character: bear, stars: 2, position: Position(row: 3, column: 1)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 3)),
        Placement(character: boar, stars: 3, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: snake, stars: 2, position: Position(row: 1, column: 2)),
        Placement(character: fox, stars: 1, position: Position(row: 1, column: 1)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: cerberus, stars: 1, position: Position(row: 3, column: 2)),
        Placement(character: acromantula, stars: 1, position: Position(row: 3, column: 1)),
        Placement(character: bear, stars: 3, position: Position(row: 3, column: 3)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 3, position: Position(row: 3, column: 4)),
        Placement(character: snake, stars: 2, position: Position(row: 1, column: 2)),
        Placement(character: fox, stars: 1, position: Position(row: 1, column: 1)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: cerberus, stars: 2, position: Position(row: 3, column: 2)),
        Placement(character: bear, stars: 3, position: Position(row: 3, column: 1)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 3)),
        Placement(character: dragon, stars: 1, position: Position(row: 3, column: 0)),
        Placement(character: bat, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: snake, stars: 2, position: Position(row: 1, column: 2)),
        Placement(character: rat, stars: 1, position: Position(row: 1, column: 1)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: kraken, stars: 2, position: Position(row: 3, column: 2)),
        Placement(character: cerberus, stars: 2, position: Position(row: 3, column: 1)),
        Placement(character: acromantula, stars: 1, position: Position(row: 3, column: 3)),
        Placement(character: bear, stars: 3, position: Position(row: 3, column: 0)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: fox, stars: 2, position: Position(row: 1, column: 2)),
      ],
    ),
    EnemyWave(
      coinsReward: 10,
      enemies: [
        Placement(character: cerberus, stars: 2, position: Position(row: 3, column: 2)),
        Placement(character: acromantula, stars: 2, position: Position(row: 3, column: 1)),
        Placement(character: bear, stars: 3, position: Position(row: 3, column: 3)),
        Placement(character: alligator, stars: 2, position: Position(row: 3, column: 0)),
        Placement(character: dragon, stars: 2, position: Position(row: 3, column: 4)),
        Placement(character: bat, stars: 2, position: Position(row: 1, column: 2)),
      ],
    ),
  ],
);
