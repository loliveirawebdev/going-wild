import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/errors/position_taken_by_enemy_error.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/use_cases/round/start_round.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

const middleRowRat = PhaseWave(
  coinsReward: 10,
  enemies: [
    Placement(
      position: Position(row: 3, column: 2),
      characterCopy: CharacterCopy(stars: 1, character: rat),
    ),
  ],
);

void main() {
  test('the team can stand on a free cell of the middle row but not where the wave has an enemy', () {
    final matchProgress = withInventory(matchProgressWith(waves: const [middleRowRat], levelNumber: 3), [characterCopyOf(cow)]);

    expect(checkMovingFromInventoryToBoard(matchProgress, position: at(3, 0), inventoryIndex: 0), isNull);
    expect(checkMovingFromInventoryToBoard(matchProgress, position: at(3, 2), inventoryIndex: 0), isA<PositionTakenByEnemyError>());
  });

  test('a round moves a team copy that stands where the new wave has an enemy to the closest free team cell', () {
    final matchProgress = matchProgressWith(
      levelNumber: 3,
      waves: const [middleRowRat],
    ).createCopyWithPlayerPlacements([placed(dog, 3, 2), placed(cat, 4, 1)]);

    final placements = startRound(matchProgress).playerRoster.placements;

    expect(placements, hasLength(2));
    expect(placements.placementAt(at(3, 1))!.characterCopy.character, dog);
    expect(placements.placementAt(at(4, 1))!.characterCopy.character, cat);
    expect(placements.placementAt(at(3, 2)), isNull);
  });
}
