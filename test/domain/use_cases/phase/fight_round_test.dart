import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/combat/board/faction.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/phase/fight_round.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

final oneRat = EnemyWave(enemies: [placed(rat, 1, 2)]);
final twoRats = EnemyWave(enemies: [placed(rat, 1, 1), placed(rat, 1, 3)]);
final fiveRats = EnemyWave(enemies: [for (var column = 0; column < 5; column++) placed(rat, 1, column)]);

PhaseRun phaseRunWithThreeStarBull(List<EnemyWave> enemyWaves, {int seed = 1}) {
  final phaseRun = startPhase(phaseWith(enemyWaves), phaseRulesWith(), Random(seed));
  phaseRun.player.ownedCharacters.add(owned(bull, stars: 3));
  return phaseRun;
}

void main() {
  final threeStarBull = [placed(bull, 6, 2, stars: 3)];

  test('an invalid team does not fight and changes nothing', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat, oneRat]);
    final coinsBefore = phaseRun.player.coins;

    final roundResult = fightRound(phaseRun, [placed(cow, 6, 2)]);

    expect(roundResult, isNull);
    expect(phaseRun.currentRoundNumber, 1);
    expect(phaseRun.remainingLives, phaseRun.rules.startingPlayerLives);
    expect(phaseRun.player.coins, coinsBefore);
  });

  test('winning a round keeps every life and opens the next round', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat, twoRats]);
    final coinsBefore = phaseRun.player.coins;

    final roundResult = fightRound(phaseRun, threeStarBull)!;

    expect(roundResult.roundNumber, 1);
    expect(roundResult.battleResult.winningFaction, Faction.team);
    expect(roundResult.livesTaken, 0);
    expect(phaseRun.currentRoundNumber, 2);
    expect(phaseRun.currentEnemyWave, twoRats);
    expect(phaseRun.player.coins, coinsBefore + testShopRules.coinsPerRound);
    expect(phaseRun.status, PhaseStatus.inProgress);
  });

  test('every enemy still alive at the end takes one life', () {
    final phaseRun = phaseRunWithThreeStarBull([twoRats, oneRat]);

    final roundResult = fightRound(phaseRun, [])!;

    expect(roundResult.livesTaken, 2);
    expect(phaseRun.remainingLives, phaseRun.rules.startingPlayerLives - 2);
    expect(phaseRun.status, PhaseStatus.inProgress);
  });

  test('losing the last life loses the phase and stops the rounds', () {
    final phaseRun = phaseRunWithThreeStarBull([fiveRats, oneRat]);
    final coinsBefore = phaseRun.player.coins;

    final roundResult = fightRound(phaseRun, [])!;

    expect(roundResult.livesTaken, phaseRun.rules.startingPlayerLives);
    expect(phaseRun.remainingLives, 0);
    expect(phaseRun.status, PhaseStatus.lost);
    expect(phaseRun.player.coins, coinsBefore);
    expect(fightRound(phaseRun, threeStarBull), isNull);
  });

  test('clearing the last round wins the phase', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat, oneRat]);

    fightRound(phaseRun, threeStarBull);
    final coinsBeforeLastRound = phaseRun.player.coins;
    fightRound(phaseRun, threeStarBull);

    expect(phaseRun.status, PhaseStatus.won);
    expect(phaseRun.player.coins, coinsBeforeLastRound);
    expect(fightRound(phaseRun, threeStarBull), isNull);
  });

  test('the same seed plays the same round', () {
    final firstRun = phaseRunWithThreeStarBull([twoRats], seed: 9);
    final secondRun = phaseRunWithThreeStarBull([twoRats], seed: 9);

    final firstEvents = fightRound(firstRun, threeStarBull)!.battleResult.events;
    final secondEvents = fightRound(secondRun, threeStarBull)!.battleResult.events;

    expect(firstEvents.length, secondEvents.length);
    expect(firstRun.player.shopOffers, secondRun.player.shopOffers);
  });

  test('a won round records nothing about lives and starts the next round', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat, twoRats]);
    final eventCountBeforeFight = phaseRun.events.length;

    fightRound(phaseRun, threeStarBull);

    final eventsOfTheFight = phaseRun.events.skip(eventCountBeforeFight).toList();
    expect(eventsOfTheFight.whereType<PlayerLivesLost>(), isEmpty);
    expect(eventsOfTheFight.first, isA<RoundStarted>());
    expect(eventsOfTheFight.first.roundNumber, 2);
  });

  test('lost lives are recorded with what is left', () {
    final phaseRun = phaseRunWithThreeStarBull([twoRats, oneRat]);

    fightRound(phaseRun, []);

    final livesLost = phaseRun.events.whereType<PlayerLivesLost>().single;
    expect(livesLost.roundNumber, 1);
    expect(livesLost.amount, 2);
    expect(livesLost.remainingPlayerLives, phaseRun.rules.startingPlayerLives - 2);
  });

  test('losing the phase records the lost lives and then the defeat, with no new round', () {
    final phaseRun = phaseRunWithThreeStarBull([fiveRats, oneRat]);
    final eventCountBeforeFight = phaseRun.events.length;

    fightRound(phaseRun, []);

    expect(phaseRun.events.skip(eventCountBeforeFight), [isA<PlayerLivesLost>(), isA<PhaseLost>()]);
    expect(phaseRun.events.last.roundNumber, 1);
    expect(phaseRun.currentRoundNumber, 1);
  });

  test('winning the phase records the victory on the last round, with no new round', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat, oneRat]);

    fightRound(phaseRun, threeStarBull);
    final eventCountBeforeLastFight = phaseRun.events.length;
    fightRound(phaseRun, threeStarBull);

    expect(phaseRun.events.skip(eventCountBeforeLastFight), [isA<PhaseWon>()]);
    expect(phaseRun.events.last.roundNumber, 2);
    expect(phaseRun.currentRoundNumber, 2);
  });

  test('an invalid team records nothing', () {
    final phaseRun = phaseRunWithThreeStarBull([oneRat]);
    final eventCountBefore = phaseRun.events.length;

    fightRound(phaseRun, [placed(cow, 6, 2)]);

    expect(phaseRun.events, hasLength(eventCountBefore));
  });
}
