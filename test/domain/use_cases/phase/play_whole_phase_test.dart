import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/round_result.dart';
import 'package:going_wild/domain/use_cases/phase/fight_round.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';

import '../../../helpers/phase_helpers.dart';

void arrangeStrongestOnField(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final board = phaseRun.rules.board;

  final teamPositions = [
    for (var row = board.rows - 2; row >= board.rows ~/ 2; row--)
      for (var column = 0; column < board.columns; column++) Position(row: row, column: column),
    for (var column = 0; column < board.columns; column++) Position(row: board.rows - 1, column: column),
  ];

  int strengthOf(int coins, int stars) => coins * (1 << (stars - 1));

  final strongestFirst = [...player.ownedCharacters]
    ..sort(
      (first, second) =>
          strengthOf(second.character.rarity.coins, second.stars).compareTo(strengthOf(first.character.rarity.coins, first.stars)),
    );

  player.field.clear();
  player.bench.fillRange(0, player.bench.length, null);

  for (final (index, ownedCharacter) in strongestFirst.indexed) {
    if (index < player.level) {
      player.field[teamPositions[index]] = ownedCharacter;
      continue;
    }

    player.bench[index - player.level] = ownedCharacter;
  }
}

List<RoundResult> playWholePhaseBuyingEverything(int seed) {
  final phaseRun = startPhase(backyard, phaseRulesWith(), Random(seed));
  final roundResults = <RoundResult>[];

  while (phaseRun.status == PhaseStatus.inProgress) {
    for (var offerIndex = 0; offerIndex < phaseRun.player.shopOffers.length; offerIndex++) buyShopOffer(phaseRun, offerIndex);
    while (phaseRun.player.coins >= phaseRun.rules.shopRules.experiencePurchaseCostInCoins + 6) buyExperience(phaseRun);
    arrangeStrongestOnField(phaseRun);
    roundResults.add(fightRound(phaseRun)!);
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
        roundResults.where((roundResult) => roundResult.isLost).length,
        lessThanOrEqualTo(phaseRulesWith().startingPlayerLives),
      );
    }
  });

  test('the same seed plays the same whole phase', () {
    List<bool> lostRounds(int seed) => playWholePhaseBuyingEverything(seed).map((roundResult) => roundResult.isLost).toList();
    expect(lostRounds(5), lostRounds(5));
  });
}
