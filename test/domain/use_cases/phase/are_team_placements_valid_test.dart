import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/phase/are_team_placements_valid.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

PhaseRun phaseRunOwningCatAndTwoStarDog() {
  final phaseRun = startPhase(backyard, phaseRulesWith(), Random(1));
  phaseRun.player.ownedCharacters.addAll([owned(cat), owned(dog, stars: 2)]);
  return phaseRun;
}

void main() {
  test('owned characters inside the team half and within the level limit are valid', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog();
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, 1), placed(dog, 7, 3, stars: 2)]), isTrue);
  });

  test('an empty team is valid and simply loses the round', () {
    expect(
      areTeamPlacementsValid(phaseRunOwningCatAndTwoStarDog(), []),
      isTrue,
    );
  });

  test('more characters than the player level is invalid', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog();
    phaseRun.player.ownedCharacters.add(owned(rabbit));

    expect(phaseRun.player.level, 2);
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, 1), placed(dog, 6, 2, stars: 2), placed(rabbit, 6, 3)]), isFalse);
  });

  test('a character the player does not own is invalid', () {
    expect(
      areTeamPlacementsValid(phaseRunOwningCatAndTwoStarDog(), [placed(bull, 6, 1)]),
      isFalse,
    );
  });

  test('an owned character placed with other stars is invalid', () {
    expect(
      areTeamPlacementsValid(phaseRunOwningCatAndTwoStarDog(), [placed(dog, 6, 1)]),
      isFalse,
    );
  });

  test('one owned copy cannot be placed twice', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog();
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, 1), placed(cat, 6, 2)]), isFalse);

    phaseRun.player.ownedCharacters.add(owned(cat));
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, 1), placed(cat, 6, 2)]), isTrue);
  });

  test('a position in the enemy half is invalid', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog();
    final lastEnemyRow = phaseRun.rules.board.rows ~/ 2 - 1;
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, lastEnemyRow, 1)]), isFalse);
  });

  test('a position outside the board is invalid', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog();
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, phaseRun.rules.board.rows, 1)]), isFalse);
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, -1)]), isFalse);
  });

  test('two characters on the same position is invalid', () {
    expect(
      areTeamPlacementsValid(phaseRunOwningCatAndTwoStarDog(), [placed(cat, 6, 1), placed(dog, 6, 1, stars: 2)]),
      isFalse,
    );
  });

  test('nothing is valid once the phase is over', () {
    final phaseRun = phaseRunOwningCatAndTwoStarDog()..status = PhaseStatus.lost;
    expect(areTeamPlacementsValid(phaseRun, [placed(cat, 6, 1)]), isFalse);
  });
}
