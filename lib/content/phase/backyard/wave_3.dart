import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';

import '../../character/enemies/enemies.dart';

const PhaseWave backyardWave3 = PhaseWave(
  coinsReward: 10,
  enemies: [
    Placement(
      position: Position(row: 3, column: 2),
      characterCopy: CharacterCopy(character: cerberus, stars: 3),
    ),
  ],
);
