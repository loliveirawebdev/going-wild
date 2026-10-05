import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';

const PhaseWave backyardWave1 = PhaseWave(
  coinsReward: 10,
  enemies: [
    Placement(
      position: Position(row: 3, column: 1),
      characterCopy: CharacterCopy(character: rat, stars: 1),
    ),
    Placement(
      position: Position(row: 3, column: 2),
      characterCopy: CharacterCopy(character: fox, stars: 1),
    ),
    Placement(
      position: Position(row: 3, column: 3),
      characterCopy: CharacterCopy(character: rat, stars: 1),
    ),
    Placement(
      position: Position(row: 0, column: 1),
      characterCopy: CharacterCopy(character: hawk, stars: 1),
    ),
  ],
);
