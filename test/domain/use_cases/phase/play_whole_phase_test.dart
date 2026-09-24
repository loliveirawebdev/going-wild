import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/round_result.dart';
import 'package:going_wild/domain/use_cases/phase/fight_round.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';

import '../../../helpers/phase_helpers.dart';

List<Placement> strongestTeamPlacements(PhaseRun phaseRun) {
  final board = phaseRun.rules.board;

  final teamPositions = [
    for (var row = board.rows - 2; row >= board.rows ~/ 2; row--)
      for (var column = 0; column < board.columns; column++) Position(row: row, column: column),
    for (var column = 0; column < board.columns; column++) Position(row: board.rows - 1, column: column),
  ];

  int strengthOf(int coins, int stars) => coins * (1 << (stars - 1));

  final strongestFirst = [...phaseRun.player.ownedCharacters]
    ..sort(
      (first, second) =>
          strengthOf(second.character.rarity.coins, second.stars).compareTo(strengthOf(first.character.rarity.coins, first.stars)),
    );

  return [
    for (final (index, ownedCharacter) in strongestFirst.take(phaseRun.player.level).indexed)
      Placement(character: ownedCharacter.character, stars: ownedCharacter.stars, position: teamPositions[index]),
  ];
}

List<RoundResult> playWholePhaseBuyingEverything(int seed) {
  final phaseRun = startPhase(backyard, phaseRulesWith(), Random(seed));
  final roundResults = <RoundResult>[];

  while (phaseRun.status == PhaseStatus.inProgress) {
    for (var offerIndex = 0; offerIndex < phaseRun.player.shopOffers.length; offerIndex++) buyShopOffer(phaseRun, offerIndex);
    while (phaseRun.player.coins >= phaseRun.rules.shopRules.experiencePurchaseCostInCoins + 6) buyExperience(phaseRun);
    roundResults.add(fightRound(phaseRun, strongestTeamPlacements(phaseRun))!);
  }

  return roundResults;
}

void main() {
  test('a whole phase always ends, won or lost, within the round count', () {
    for (final seed in [1, 2, 3]) {
      final roundResults = playWholePhaseBuyingEverything(seed);
      expect(roundResults.length, inInclusiveRange(1, backyard.roundCount));

      expect(roundResults.map((roundResult) => roundResult.roundNumber), [
        for (var round = 1; round <= roundResults.length; round++) round,
      ]);

      expect(
        roundResults.fold(0, (sum, roundResult) => sum + roundResult.livesTaken),
        lessThanOrEqualTo(phaseRulesWith().startingPlayerLives),
      );
    }
  });

  test('the same seed plays the same whole phase', () {
    List<int> livesTakenPerRound(int seed) => playWholePhaseBuyingEverything(seed).map((roundResult) => roundResult.livesTaken).toList();
    expect(livesTakenPerRound(5), livesTakenPerRound(5));
  });
}
